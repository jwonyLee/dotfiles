local M = {}

-- UUID 생성 함수
local function generate_uuid()
  local random = math.random
  local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
    local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
    return string.format('%x', v)
  end)
end

-- 새 위키 페이지 템플릿 생성 함수
function M.insert_wiki_template()
  local uuid = generate_uuid()
  local resource_id = string.sub(uuid, 1, 2) .. '/' .. string.sub(uuid, 3)
  local permalink = generate_uuid()
  
  local template = {
    '---',
    'layout    : wiki',
    'title     : ',
    'summary   : ',
    'permalink : ' .. permalink,
    'date      : ' .. os.date('%Y-%m-%d %H:%M:%S +0900'),
    'updated   : ' .. os.date('%Y-%m-%d %H:%M:%S +0900'),
    'tag       : ',
    'resource  : ' .. resource_id,
    'toc       : true',
    'public    : true',
    'parent    : ',
    'latex     : false',
    '---',
    '',
    '* TOC',
    '{:toc}',
    '',
    '## '
  }
  
  -- 현재 커서 위치에 템플릿 삽입
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_lines(0, cursor[1] - 1, cursor[1] - 1, false, template)
  
  -- 커서를 템플릿의 마지막 줄로 이동
  vim.api.nvim_win_set_cursor(0, {cursor[1] + #template - 1, 0})
end

return M
