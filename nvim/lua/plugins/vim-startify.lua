return {
  {
    "mhinz/vim-startify",
    lazy = false, -- startify should be loaded at startup
    config = function()
      -- 세션 저장 디렉토리 설정
      -- vim.g.startify_session_dir = '~/.config/nvim/session'
      -- 세션 자동 로드 (해당 디렉토리에서 Vim 시작 시)
      vim.g.startify_session_autoload = 1
      -- Vim 종료 시 자동 세션 저장
      vim.g.startify_session_persistence = 1
      -- 세션 저장 전 모든 버퍼 삭제
      vim.g.startify_session_delete_buffers = 1
      -- 세션 저장 전 실행할 명령어
      vim.g.startify_session_before_save = {'silent! Neotree close'} 
      -- 세션 시작 후 실행할 명령어
      vim.g.startify_session_after_load = {'Neotree show'}
      -- 세션 목록 표시 설정
      vim.g.startify_lists = {
        { type = "sessions",  header = {"   세션"} },
        { type = "bookmarks", header = {"   북마크"} },
        { type = "files",     header = {"   최근 파일"} },
        { type = "dir",       header = {"   현재 디렉토리 " .. vim.fn.getcwd()} },
      }
      vim.g.startify_bookmarks = {
        { c = "~/.config/nvim/init.lua" },
        { z = "~/.zshrc" },
      }
      vim.g.startify_custom_header = {
        "",
        "   Welcome to Neovim!   ",
        "",
      }
    end,
  },
}
