local cmd = vim.cmd -- execute vim commands
local fn = vim.fn -- call vim functions
local set = vim.opt
local execute = vim.api.nvim_command

local map = require('core.utils').map
local nmap = require('core.utils').nmap
local vmap = require('core.utils').vmap
local imap = require('core.utils').imap

-- Bootstrap packer
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system {
    'git',
    'clone',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  }
  execute 'packadd packer.nvim'
end

local packer = require 'packer'
local use = packer.use

packer.startup(function()
  use { 'wbthomason/packer.nvim', opt = true }

  use { 'kyazdani42/nvim-web-devicons' }

  use {
    'kyazdani42/nvim-tree.lua',
    opt = true,
    cmd = { 'NvimTreeOpen', 'NvimTreeToggle' },
    setup = function()
      require('modules.nvim-tree').setup()
    end,
    config = function()
      require('modules.nvim-tree').config()
    end,
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('modules.treesitter').config()
    end,
  }

  use 'nvim-lua/plenary.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    module = 'telescope',
    setup = function()
      require('modules.telescope').setup()
    end,
    config = function()
      require('modules.telescope').config()
    end,
  }

  use {
    'neovim/nvim-lspconfig',
    config = require 'core.lsp',
  }

  use { 'williamboman/nvim-lsp-installer' }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    'jose-elias-alvarez/nvim-lsp-ts-utils',
  }

  use {
    'folke/trouble.nvim',
    config = function()
      require('modules.trouble').config()
    end,
    requires = { 'kyazdani42/nvim-web-devicons' },
  }

  use {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  }

  use {
    'nanozuki/tabby.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('tabby').setup()
    end,
  }

  use {
    'is0n/fm-nvim',
    config = function()
      require('modules.fm').config()
    end,
  }

  use {
    'AckslD/nvim-neoclip.lua',
    module = 'neoclip',
    event = { 'TextYankPost' },
    setup = function()
      require('modules.neoclip').setup()
    end,
    config = function()
      require('modules.neoclip').config()
    end,
  }

  use {
    'windwp/nvim-autopairs',
    event = { 'InsertEnter' },
    config = function()
      require('modules.autopairs').config()
    end,
  }

  use {
    'hrsh7th/nvim-cmp',
    config = function()
      require('core.cmp').config()
    end,
    requires = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
    },
  }

  --[[ use {
    'hoob3rt/lualine.nvim',
    config = require('modules.lualine').config
  } ]]

  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('modules.gitsigns').config()
    end,
    event = { 'BufReadPre', 'BufNewFile' },
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup {
        show_current_context = true,
        buftype_exclude = { 'terminal', 'readonly' },
      }
    end,
  }

  use 'tpope/vim-eunuch'

  use {
    'tpope/vim-surround',
    event = { 'InsertEnter' },
  }

  use {
    'projekt0n/github-nvim-theme',
    --[[ config = function()
      require("github-theme").setup({
        theme_style = "dark"
      })
    end ]]
  }

  use 'tpope/vim-fugitive'

  use 'folke/tokyonight.nvim'

  use 'bluz71/vim-moonfly-colors'

  use 'b3nj5m1n/kommentary'

  use {
    'famiu/bufdelete.nvim',
    cmd = { 'Bdelete', 'Bwipeout' },
  }
end)

local executable = function(e)
  return fn.executable(e) > 0
end

vim.g.mapleader = ' '

-- PLUGIN: b3nj5m1n / kommentary {{{
vim.g.kommentary_create_default_mappings = false
nmap('<leader>cc', '<Plug>kommentary_line_default', {})
nmap('<leader>c', '<Plug>kommentary_motion_default', {})
vmap('<leader>c', '<Plug>kommentary_visual_default<C-c>', {})

-- }}}

-----------------------------------------------------------------------------//
-- Indentation {{{1
-----------------------------------------------------------------------------//
set.expandtab = true -- Use spaces instead of tabs
set.shiftwidth = 2 -- Size of an indent
set.tabstop = 2 -- Number of spaces tabs count for
set.softtabstop = 2
set.smartindent = true -- Insert indents automatically
set.shiftround = true -- Round indent
set.joinspaces = false -- No double spaces with join after a dot

-----------------------------------------------------------------------------//
-- Display {{{1
-----------------------------------------------------------------------------//
set.number = true -- Display line number
set.relativenumber = true -- Relative line numbers
set.numberwidth = 2
set.signcolumn = 'yes:1' -- 'auto:1-2'
set.colorcolumn = '81'

set.wrap = true
set.linebreak = true -- wrap, but on words, not randomly
-- set.textwidth = 80
set.synmaxcol = 1024 -- don't syntax highlight long lines
vim.g.vimsyn_embed = 'lPr' -- allow embedded syntax highlighting for lua, python, ruby
set.showmode = false
set.lazyredraw = true
set.emoji = false -- turn off as they are treated as double width characters
set.list = true -- show invisible characters

set.listchars = {
  eol = ' ',
  tab = '→ ',
  extends = '…',
  precedes = '…',
  trail = '·',
}
set.shortmess:append 'I' -- disable :intro startup screen

-----------------------------------------------------------------------------//
-- Title {{{1
-----------------------------------------------------------------------------//
set.titlestring = '❐ %t'
set.titleold = '%{fnamemodify(getcwd(), ":t")}'
set.title = true
set.titlelen = 70

-----------------------------------------------------------------------------//
-- Folds {{{1
-----------------------------------------------------------------------------//
-- TODO: Understand these settings
set.foldtext = 'folds#render()'
set.foldopen:append { 'search' }
set.foldlevelstart = 10
set.foldmethod = 'syntax'
-- set.foldmethod = 'expr'
-- set.foldexpr='nvim_treesitter#foldexpr()'

-----------------------------------------------------------------------------//
-- Backup {{{1
-----------------------------------------------------------------------------//
set.swapfile = false
set.backup = false
set.writebackup = false
set.undofile = true -- Save undo history
set.confirm = true -- prompt to save before destructive actions
-- set.updatetime = 1000 -- cursor update and swapfile write time. Do not set to 0

-----------------------------------------------------------------------------//
-- Search {{{1
-----------------------------------------------------------------------------//
set.ignorecase = true -- Ignore case
set.smartcase = true -- Don't ignore case with capitals
set.wrapscan = true -- Search wraps at end of file
set.scrolloff = 5 -- Lines of context
set.sidescrolloff = 8 -- Columns of context
set.showmatch = true
cmd [[set nohlsearch]]

-- Use faster grep alternatives if possible
if executable 'rg' then
  set.grepprg =
    [[rg --hidden --glob "!.git" --no-heading --smart-case --vimgrep --follow $*]]
  set.grepformat:prepend { '%f:%l:%c:%m' }
end

-----------------------------------------------------------------------------//
-- window splitting and buffers {{{1
-----------------------------------------------------------------------------//
set.hidden = true -- Enable modified buffers in background
set.splitbelow = true -- Put new windows below current
set.splitright = true -- Put new windows right of current
set.fillchars = {
  vert = '│',
  fold = ' ',
  diff = '-', -- alternatives: ⣿ ░
  msgsep = '‾',
  foldopen = '▾',
  foldsep = '│',
  foldclose = '▸',
}

-----------------------------------------------------------------------------//
-- Terminal {{{1
-----------------------------------------------------------------------------//
-- Open a terminal pane on the right using :Term
-- cmd [[command Term :botright vsplit term://$SHELL]]

-- Terminal visual tweaks
-- Enter insert mode when switching to terminal
-- Close terminal buffer on process exit
cmd [[
    autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
    autocmd TermOpen * startinsert
    autocmd BufEnter,BufWinEnter,WinEnter term://* startinsert
    autocmd BufLeave term://* stopinsert
    autocmd TermClose term://* call nvim_input('<CR>')
    autocmd TermClose * call feedkeys("i")
]]

-----------------------------------------------------------------------------//
-- Mouse {{{1
-----------------------------------------------------------------------------//
set.mouse = 'a'

-----------------------------------------------------------------------------//
-- Netrw {{{1
-----------------------------------------------------------------------------//
-- do not display info on the top of window
vim.g.netrw_banner = 0

-----------------------------------------------------------------------------//
-- Colorscheme {{{1
-----------------------------------------------------------------------------//
set.termguicolors = true

-- tokyonight config
vim.g.tokyonight_style = 'night'
vim.cmd [[ colorscheme tokyonight ]]

-----------------------------------------------------------------------------//
-- Keymaps {{{1
-----------------------------------------------------------------------------//
-- unmap any functionality tied to space
nmap('<Space>', '<NOP>')

-- Toggle highlighting
nmap('<leader><leader>h', '<cmd>set hlsearch!<CR>')

imap('jk', '<Esc>')
imap('kj', '<Esc>')

-- Better split navigation
nmap('<C-h>', '<C-w>h')
nmap('<C-j>', '<C-w>j')
nmap('<C-k>', '<C-w>k')
nmap('<C-l>', '<C-w>l')

nmap('<Leader>o', 'o<Esc>k')
nmap('<Leader>O', 'O<Esc>j')

-- Better indenting
vmap('<', '<gv')
vmap('>', '>gv')

-- Buffer management
nmap('<Tab>', '<cmd>bnext<CR>')
nmap('<S-Tab>', '<cmd>bprev<CR>')

nmap('<Leader>bk', '<cmd>Bdelete<CR>')

-- Exit terminal using easier keybindings
-- U.map('t', 'jk', '<C-\\><C-n>')

-- Source lua.init
nmap('<leader>si', '<cmd>luafile ~/.config/nvim/init.lua<CR>')
-- Source current lua file
nmap('<leader>so', '<cmd>source %<CR>')

-- Line bubbling
map('x', 'J', ':m \'>+1<CR>gv-gv')
map('x', 'K', ':m \'<-2<CR>gv-gv')
imap('<C-j>', '<cmd>move .+1<CR><esc>==a')
imap('<C-k>', '<cmd>move .-2<CR><esc>==a')
nmap('<leader>j', '<cmd>move .+1<CR>==')
nmap('<leader>k', '<cmd>move .-2<CR>==')

-- Close readonly buffers with q
nmap('q', '&readonly ? \':close!<CR>\' : \'q\'', {
  expr = true,
  noremap = true,
})

map('', 'Q', '') -- disable Q for ex mode
map('', 'q:', '') -- disable Q for ex mode
-- U.map('n', 'x', '"_x') --delete char without yank
-- U.map('x', 'x', '"_x') -- delete visual selection without yank
--
nmap('Y', 'y$', { noremap = true })

imap(',', ',<C-g>u')
imap('.', '.<C-g>u')
imap('!', '!<C-g>u')
imap('(', '(<C-g>u')

map(
  'c',
  'w!!',
  '<esc>:lua require \'core.utils\'.sudo_write()<CR>',
  { silent = true }
)

nmap('<leader>.', '<cmd>Nnn<CR>')
-----------------------------------------------------------------------------//
-- }}}1
-----------------------------------------------------------------------------//
