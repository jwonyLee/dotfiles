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
function M.insert_diary_template()
  local uuid = generate_uuid()
  local filename = vim.fn.expand('%:t')  -- 현재 파일 이름 가져오기
  local resource_id = string.sub(uuid, 1, 2) .. '/' .. string.sub(uuid, 3)
  local permalink = generate_uuid()
  
  local template = {
    '---',
    'layout    : wiki',
    'title     : ' .. (filename or ''),
    'summary   : ',
    'permalink : ' .. permalink,
    'date      : ' .. os.date('%Y-%m-%d %H:%M:%S +0900'),
    'updated   : ' .. os.date('%Y-%m-%d %H:%M:%S +0900'),
    'tag       : ',
    'resource  : ' .. resource_id,
    'toc       : true',
    'public    : false',
    'parent    : ',
    'latex     : false',
    '---',
    '',
    '* TOC',
    '{:toc}',
    '',
    '> ## 참고 사항',
    '> 기록할 가치가 있는 것들:',
    '> - 수행한 작업 및 결과 (예: 프로젝트/작업 시작, 마일스톤 달성)',
    '> - 작업의 산출물 (예: 디자인 문서, 풀 리퀘스트 등)',
    '> - 일반적인 책임 외의 작업: (예: 질의응답, 다른 사람 돕기, 멘토링, 자원 봉사 등)',
    '>',
    '> 다음 사항도 고려할 수 있습니다:',
    '> - 다른 사람의 피드백 (예: 채팅 메시지/이메일 스크린샷)',
    '> - 다른 프로젝트에 대한 도움의 영향 (예: 마감일 맞추기 지원, 다른 사람의 차단 해제)',
    '> - 기대 이상으로 노력한 경우 (예: 업무 마무리를 위해 늦게까지 작업, 주요 작업을 완료하기 위해 다른 일을 우선순위에서 제외)',
    '> - 배운 점',
    '',
    '## 회의',
    '',
    '- ',
    '## 작업',
    '',
    '- ',
    '## 기타',
    '',
    '- ',
    '## Research',
    '',
    '- ',
    '## Reading',
    '',
    '- ',
    ''
  }
  
  -- 현재 커서 위치에 템플릿 삽입
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_lines(0, cursor[1] - 1, cursor[1] - 1, false, template)
  
  -- 커서를 템플릿의 마지막 줄로 이동
  vim.api.nvim_win_set_cursor(0, {cursor[1] + #template - 1, 0})
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
