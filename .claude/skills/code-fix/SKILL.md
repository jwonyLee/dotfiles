---
name: code-fix
description: Analyze and fix code issues in referenced files. Use when user references a file with @ prefix and asks to analyze, fix, modify, or review code. Handles "원인 파악", "수정해줘", "검토해줘" requests.
---

# Code Fix

Analyze and fix code issues based on file references and user requests.

## Trigger Patterns

- `/fix` or `/code-fix` command
- `@filepath` + modification request
- Keywords: "수정해줘", "바꿔줘", "변경해줘", "제거해줘", "추가해줘"
- Analysis: "원인을 파악해줘", "검토해줘", "확인해줘"

## Workflow

### Step 1: Identify Target File

If user provides `@filepath`:
1. Read the referenced file completely
2. Understand the file structure and context

```bash
# Example: Read Swift file
cat <filepath>
```

### Step 2: Understand the Request

Classify the request type:

| Type | Keywords | Action |
|------|----------|--------|
| **Analyze** | "원인 파악", "검토", "확인" | Analyze only, suggest fixes |
| **Modify** | "수정해줘", "바꿔줘" | Propose and apply changes |
| **Compare** | "비교해줘", "차이" | Compare with another file/version |

### Step 3: Analyze Code (for Swift/iOS)

Check for common issues:

**Memory & Lifecycle**
- Retain cycles in closures (missing `[weak self]`)
- DisposeBag lifecycle issues
- Deinitialization problems

**Optional Handling**
- Force unwrapping without safety
- Optional chaining correctness
- Guard/if-let usage

**RxSwift Patterns**
- Proper disposal
- Thread scheduling (observeOn/subscribeOn)
- Memory leaks in subscriptions

**Animation Issues**
- UIView.animate block correctness
- layoutIfNeeded() placement
- Animation timing conflicts

### Step 4: Present Findings

For **Analysis** requests:
```markdown
## Analysis: {filename}

### Issue 1: {description}
- **Location**: Line {n}
- **Problem**: {explanation}
- **Suggestion**: {fix}

### Issue 2: ...
```

For **Modification** requests:
```markdown
## Proposed Change

**File**: {filepath}
**Line**: {n}-{m}

**Current**:
```code
...
```

**Proposed**:
```code
...
```

Proceed with this change? (응/아니)
```

### Step 5: Apply Changes

On user approval ("응", "응 수정해줘", "해줘"):
- Use Edit tool to apply changes
- Report completion

## Quick Approval Patterns

Recognize short approvals:
- "응" → proceed with suggested fix
- "응 수정해줘" → apply fix
- "응 해줘" → execute action
- "나머지도" → apply to remaining items
- "2번으로" → select option 2

## Examples

### Example 1: Analysis Request
```
User: @SomeFile.swift 에서 애니메이션이 동작하지 않는 원인을 파악해줘
```
→ Analyze file, identify animation issues, suggest fixes

### Example 2: Modification Request
```
User: @SomeFile.swift 에서 isExpanded 를 반대로 수정해줘
```
→ Find isExpanded usage, propose toggle change, wait for approval

### Example 3: Quick Fix
```
User: 응 수정해줘
```
→ Apply previously suggested fix immediately

## Notes

- Always read the full file before analyzing
- Preserve original code style and conventions
- For iOS/Swift: Consider thread safety, memory management
- Ask for clarification if request is ambiguous
