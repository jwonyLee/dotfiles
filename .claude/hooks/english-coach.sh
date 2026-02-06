#!/bin/bash
# english-coach.sh — 영어 프롬프트 작성 코칭 훅
# 한국어 프롬프트 감지 시 Claude에게 영어 코칭 컨텍스트를 주입

INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty' 2>/dev/null)

[ -z "$PROMPT" ] && exit 0

# 한국어 문자(가-힣) 포함 여부 확인
if echo "$PROMPT" | perl -CSD -ne 'exit 0 if /[\x{AC00}-\x{D7AF}]/; exit 1'; then
  jq -n '{
    "additionalContext": "The user wrote their prompt in Korean. Before responding to the task, briefly suggest a natural English version of their prompt (1-2 sentences) as a coaching tip. Keep it concise and friendly. Format: \"English tip: [suggested English version]\". Then proceed with the task normally in Korean as configured."
  }'
fi

exit 0
