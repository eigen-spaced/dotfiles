local status_ok, cmp = pcall(require, "cmp")

if not status_ok then
  return
end

local lsp = {
  kinds = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "塞",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = "",
  },
}

local prequire = require("core.utils").prequire
local luasnip = prequire("luasnip")

-- supertab-like mapping
local mapping = {
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip and luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    else
      fallback()
    end
  end, {
    "i",
    "s",
  }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip and luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, {
    "i",
    "s",
  }),
  ["<C-n>"] = cmp.mapping.select_next_item {
    behavior = cmp.SelectBehavior.Insert,
  },
  ["<C-p>"] = cmp.mapping.select_prev_item {
    behavior = cmp.SelectBehavior.Insert,
  },
  ["<CR>"] = cmp.mapping.confirm {
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  },
  ["<C-d>"] = cmp.mapping.scroll_docs(-4),
  ["<C-f>"] = cmp.mapping.scroll_docs(4),
  ["<C-Space>"] = cmp.mapping.complete(),
  ["<C-e>"] = cmp.mapping.close(),
}

cmp.setup {
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = mapping,
  sources = {
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "buffer", keyword_length = 3 },
  },
  formatting = {
    format = function(_, vim_item)
      vim_item.kind = string.format(
        "%s [%s]",
        lsp.kinds[vim_item.kind],
        vim_item.kind
      )
      return vim_item
    end,
  },
  experimental = { ghost_text = true },
}
