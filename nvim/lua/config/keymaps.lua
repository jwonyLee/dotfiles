local mapKey = require("utils.keyMapper").mapKey
local wiki_template = require('utils.template')

-- Neotree toggle 
mapKey('<leader>e', ':Neotree toggle<cr>')

-- Xcodebuild
mapKey('<leader>r', ':XcodebuildBuildRun<cr>')

-- pane navigation 
mapKey('<C-h>', '<C-w>h') -- Left 
mapKey('<C-j>', '<C-w>j') -- Down
mapKey('<C-k>', '<C-w>k') -- Up
mapKey('<C-l>', '<C-w>l') -- Right 

-- clear search hl 
mapKey('<leader>h', ':nohlsearch<CR>')

-- indent 
mapKey('<', '<gv', 'v')
mapKey('>', '>gv', 'v')

-- Insert Template
mapKey('<leader>tt', function() wiki_template.insert_wiki_template() end)

-- 터미널 모드에서 일반 모드로 전환
mapKey("<Esc><Esc>", "<C-\\><C-n>", "t")
