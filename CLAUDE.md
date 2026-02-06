# dotfiles

Mac 초기화 후 복원을 위한 개인 설정 백업 저장소. **public repo이므로 민감 정보 절대 금지.**

## 작업 규칙

### 금지 사항 (public repo)
- SSH 키, 인증 토큰, API 키, 비밀번호 절대 커밋 금지
- `.env` 파일, `hosts.yml`(gh 인증), `config.json`(Docker 인증) 금지
- 개인 식별 정보(주민번호, 전화번호 등) 금지

### 파일 수정 시
- 설정 파일 수정 후 반드시 `symlink.sh`의 매핑 테이블도 함께 업데이트
- 새 설정 추가 시: 파일 생성 → `symlink.sh`에 링크 추가 → `setup.sh`에 필요한 설치 단계 추가 → `README.md` 구조 업데이트
- 셸 스크립트는 `bash -n <파일>`로 문법 검사

### Brewfile
- `brew bundle dump`를 쓰지 말 것 — 의존성까지 전부 들어감
- 직접 설치한 패키지만 수동으로 관리

### macOS defaults
- `macos/defaults.sh`에 `defaults write` 명령어로 관리
- 새 설정 추가 시 주석으로 설명 필수

## Claude Code 복원

settings.json과 CLAUDE.md는 `symlink.sh`가 자동으로 처리.

### 마켓플레이스 등록 (모두 auto-update 활성화)

| 마켓플레이스 | GitHub 저장소 | auto-update |
|-------------|--------------|-------------|
| claude-plugins-official | `anthropics/claude-plugins-official` | O |
| corca-plugins | `corca-ai/claude-plugins` | O |
| claude-hud | `jarrodwatts/claude-hud` | O |
| superpowers-marketplace | `obra/superpowers-marketplace` | O |
| team-attention-plugins | `team-attention/plugins-for-claude-natives` | O |
| anthropic-agent-skills | `anthropics/skills` | O |
| swiftui-expert-skill | `AvdLee/SwiftUI-Agent-Skill` | O |

### 플러그인 설치

**claude-plugins-official:**
- swift-lsp
- ralph-loop
- superpowers
- playground

**corca-plugins:**
- suggest-tidyings

**기타 마켓플레이스:**
- claude-hud (claude-hud)
- document-skills (anthropic-agent-skills)
- example-skills (anthropic-agent-skills)
- swiftui-expert (swiftui-expert-skill)

### 설정 확인

- `defaultMode`: `plan`
- `language`: `Korean`
- `env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`: `1`
- 영어 코칭 훅: `~/.claude/hooks/english-coach.sh` (별도 설정 필요)
