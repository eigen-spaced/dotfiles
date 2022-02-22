local U = {}

-- mappings
function U.map(mode, key, cmd, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, key, cmd, options)
end

local keymap = function(mode, lhs, rhs, opts, bufnr)
  -- extend the default options with user's overrides
  local default_opts = { noremap = true, silent = true }
  opts = opts and vim.tbl_extend("keep", opts, default_opts) or default_opts

  -- set a buffer local mapping only if a buffer number is given to us
  if bufnr then
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  else
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  end
end

-- set a key mapping for normal mode
_G.nmap = function(...)
  keymap("n", ...)
end
-- set a key mapping for visual mode
_G.vmap = function(...)
  keymap("v", ...)
end
-- set a key mapping for insert mode
_G.imap = function(...)
  keymap("i", ...)
end
-- set a key mapping for command-line mode
_G.cmap = function(...)
  keymap("c", ...)
end
-- set a key mapping for terminal mode
_G.tmap = function(...)
  keymap("t", ...)
end
-- set a key mapping for oator-pending mode
_G.omap = function(...)
  keymap("o", ...)
end

_G.xmap = function(...)
  keymap("x", ...)
end
-- set a key mapping for insert and command-line mode
_G.icmap = function(...)
  keymap("!", ...)
end

-- Reload current buffer if it is a vim or lua file
U.source_filetype = function()
  local ft = vim.api.nvim_buf_get_option(0, "filetype")
  if ft == "lua" or ft == "vim" then
    vim.cmd("source %")
    print(ft .. " file reloaded!")
  else
    print("Not a lua or vim file")
  end
end

function U.is_buffer_empty()
  -- Check whether the current buffer is empty
  return vim.fn.empty(vim.fn.expand("%:t")) == 1
end

function U._echo_multiline(msg)
  for _, s in ipairs(vim.fn.split(msg, "\n")) do
    vim.cmd("echom '" .. s:gsub("'", "''") .. "'")
  end
end

function U.prequire(...)
  local status, lib = pcall(require, ...)
  if status then
    return lib
  end
  return nil
end

function U.info(msg)
  vim.cmd("echohl Directory")
  U._echo_multiline(msg)
  vim.cmd("echohl None")
end

function U.warn(msg)
  vim.cmd("echohl WarningU.g")
  U._echo_multiline(msg)
  vim.cmd("echohl None")
end

function U.err(msg)
  vim.cmd("echohl ErrorU.g")
  U._echo_multiline(msg)
  vim.cmd("echohl None")
end

-- sudo write and execute within neovim
-- directly stolen from https://github.com/ibhagwan/nvim-lua/blob/main/lua/utils.lua#L307
U.sudo_exec = function(cmd, print_output)
  local password = vim.fn.inputsecret("Password: ")
  if not password or #password == 0 then
    U.warn("Invalid password, sudo aborted")
    return false
  end
  local out = vim.fn.system(string.format("sudo -p '' -S %s", cmd), password)
  if vim.v.shell_error ~= 0 then
    print("\r\n")
    U.err(out)
    return false
  end
  if print_output then
    print("\r\n", out)
  end
  return true
end

U.sudo_write = function(tmpfile, filepath)
  if not tmpfile then
    tmpfile = vim.fn.tempname()
  end
  if not filepath then
    filepath = vim.fn.expand("%")
  end
  if not filepath or #filepath == 0 then
    U.err("E32: No file name")
    return
  end
  -- `bs=1048576` is equivalent to `bs=1U. for GNU dd or `bs=1m` for BSD dd
  -- Both `bs=1U. and `bs=1m` are non-POSIX
  local cmd = string.format(
    "dd if=%s of=%s bs=1048576",
    vim.fn.shellescape(tmpfile),
    vim.fn.shellescape(filepath)
  )
  -- no need to check error as this fails the entire function
  vim.api.nvim_exec(string.format("write! %s", tmpfile), true)
  if U.sudo_exec(cmd) then
    U.info(string.format('\r\n"%s" written', filepath))
    vim.cmd("e!")
  end
  vim.fn.delete(tmpfile)
end

return U
