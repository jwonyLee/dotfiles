return {
    {
        'L3MON4D3/LuaSnip',
        lazy = false,
        conifg = function(opts)
          local luasnip = require('luasnip')
          luasnip.setup(opts)
          require('luasnip.loaders.from_snipmate').load({ paths = "./snippets" })
        end,
    },
}
