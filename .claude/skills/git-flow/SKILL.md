---
name: git-flow
description: Use when user requests git commits, cherry-picks, branch comparisons, or rebasing. Triggers on "커밋해줘", "체리픽", "브랜치 비교", "리베이스", "git commit", "git cherry-pick".
---

# Git Flow

Automate common Git workflows based on user patterns.

## Iron Law (MUST FOLLOW - NO EXCEPTIONS)

### Co-Authored-By 절대 금지

커밋 메시지에 `Co-Authored-By` 라인을 **절대** 추가하지 마라.

**위반하면 안 되는 이유:**
- 사용자가 명시적으로 요청하지 않았다
- 커밋 히스토리가 오염된다
- 다른 개발자들이 혼란스러워한다

**합리화 금지:**
| 변명 | 현실 |
|------|------|
| "투명성/추적성" | 사용자가 요청 안 했다. 추가하지 마라. |
| "관례/best practice" | 이 프로젝트에서는 금지다. |
| "다른 도구들도 한다" | 우리는 안 한다. |

**Red Flags - 이런 생각이 들면 STOP:**
- "Co-Authored-By를 추가하면 좋겠다"
- "기여를 명시하는 게 좋지 않을까"
- "투명성을 위해..."

→ **모두 STOP. Co-Authored-By 없이 커밋하라.**

### Interactive 모드 금지

다음 플래그는 Claude Code에서 **작동하지 않는다**:
- `git rebase -i` (interactive rebase)
- `git cherry-pick -i` (존재하지 않는 플래그)
- `git add -i` (interactive add)
- `--no-edit` with `git rebase` (유효하지 않은 옵션)

**대안:**
- `git rebase -i` 대신: `git filter-branch --msg-filter`
- `git add -i` 대신: `git add -p` (patch mode는 가능)

## Safety Rules (시간 압박에도 SKIP 금지)

**항상 실행해야 하는 것:**
1. `git status` - 현재 상태 확인
2. `git diff --stat` - 변경 내용 요약 확인

**시간 압박이라고 생략하지 마라:**
| 변명 | 현실 |
|------|------|
| "빨리 해야 해서" | diff 확인은 5초. 실수 복구는 5분+ |
| "간단한 변경이라서" | 간단한 변경에서도 실수한다 |
| "사용자가 급하다고 해서" | 잘못된 커밋이 더 급한 문제를 만든다 |

**추가 Safety Rules:**
- Never force push without explicit request
- Ask before rewriting history
- Warn about uncommitted changes before checkout

## Trigger Patterns

- `/git-flow` command
- Keywords: "커밋", "체리픽", "브랜치 비교", "리베이스"
- Requests: "변경사항을 커밋해줘", "커밋 메시지는 ~"

## Operations

### 1. Smart Commit

**Trigger**: "커밋해줘", "변경사항을 커밋"

**Workflow**:
```bash
# 1. Check status (REQUIRED - never skip)
git status

# 2. Show diff summary (REQUIRED - never skip)
git diff --stat

# 3. Stage and commit (NO Co-Authored-By!)
git add <files>
git commit -m "<message>"
```

**Options**:
- Split commits: "커밋을 쪼개서" → use `git add -p` to stage by hunk/line

**Commit Message Format**:
- 프리픽스 없이 간결하게 작성
- 변경 내용을 명확히 설명
- **Co-Authored-By 절대 금지**

예시: "throttle 호출 순서 변경"

### 2. Split Commits (Line/Chunk Level)

**Trigger**: "커밋을 쪼개서", "청크별로 커밋", "라인 단위로 커밋"

**Workflow**:
```bash
# 1. Show diff to understand changes
git diff

# 2. Use patch mode to stage specific hunks/lines
git add -p <file>
# Interactive options:
# y - stage this hunk
# n - skip this hunk
# s - split into smaller hunks
# e - manually edit the hunk

# 3. Verify staged changes
git diff --cached

# 4. Commit the staged hunks (NO Co-Authored-By!)
git commit -m "<description>"

# 5. Repeat for remaining changes
```

**Key Point**: 파일 단위가 아닌 **라인/청크(hunk) 단위**로 커밋하여 논리적으로 관련된 변경사항만 묶어서 커밋

### 3. Cherry-Pick Range

**Trigger**: "체리픽 해오고 싶어", "~ 부터 ~ 까지"

**Workflow**:
```bash
# 1. Show commits in range
git log --oneline <start>..<end>

# 2. Cherry-pick range (NO -i flag - it doesn't exist!)
git cherry-pick <start>^..<end>

# Or one by one with message modification
git cherry-pick <hash> --edit
```

**With Message Modification**:
```bash
# Replace pattern in commit messages
git cherry-pick <hash>
git commit --amend -m "$(git log -1 --format='%B' | sed 's/OLD/NEW/g')"
```

### 4. Branch Comparison

**Trigger**: "브랜치 비교", "차이가 얼마나"

**Workflow**:
```bash
# Line count diff
git diff --stat origin/develop..HEAD | tail -1

# File list
git diff --name-only origin/develop..HEAD

# Commit count
git rev-list --count origin/develop..HEAD
```

**Output Format**:
```markdown
## Branch Comparison: current vs origin/develop

- **Commits**: {n} commits ahead
- **Files Changed**: {n} files
- **Lines**: +{added} / -{removed}

### Changed Files:
- file1.swift
- file2.swift
```

### 5. Interactive Rebase Helper

**Trigger**: "커밋 메시지 수정", "NEWMU-1081 을 1100 으로"

**Workflow** (NO `git rebase -i` - use filter-branch instead):
```bash
# Find commits to modify
git log --oneline -n 10

# Rebase with message filter (non-interactive)
git filter-branch --msg-filter 'sed "s/PATTERN/REPLACEMENT/g"' HEAD~N..HEAD
```

**For single commit message change:**
```bash
git commit --amend -m "new message"
```

## Quick Commands

| User Says | Action |
|-----------|--------|
| "git status" | Run `git status` |
| "git push" | Run `git push` |
| "!git push" | Run `git push` immediately |

## Examples

### Example 1: Simple Commit
```
User: 변경사항을 커밋해줘. 커밋 메시지는 "throttle 호출 순서 변경."
```
→ Run git status, git diff --stat, then stage and commit (NO Co-Authored-By)

### Example 2: Split Commit (Line/Chunk)
```
User: 이 파일에서 버그 수정한 부분만 먼저 커밋해줘
```
→ Use `git add -p` to stage only the bug fix hunks, then commit

### Example 3: Cherry-Pick with Modification
```
User: e83fb2a 부터 2eee28f 까지 체리픽하고, 1081 을 1100 으로 바꿔줘
```
→ Cherry-pick range (NO -i flag), then modify commit messages with sed

### Example 4: Branch Diff
```
User: 현재 브랜치랑 origin/develop 이랑 라인 수 차이
```
→ Show line count comparison

## Notes

- Use HEREDOC for multi-line commit messages
- Always verify before destructive operations
- **NEVER add Co-Authored-By to commit messages**
