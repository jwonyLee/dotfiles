-- 위키 목록
local wikis = {
  {
    path = "~/Workspace/core/",
    syntax = "markdown",
    ext = ".md"
  },
  {
    path = "~/Workspace/jwonylee.github.io/",
    syntax = "markdown",
    ext = ".md"
  }
}

return {
  "vimwiki/vimwiki",
  keys = { "<leader>ww", "<leader>wt" },
  init = function()
     vim.g.vimwiki_list = wikis
     vim.g.vimwiki_global_ext = 0
  end,
  config = function()
  end,
}
