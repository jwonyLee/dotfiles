---
name: debug-analyze
description: Debug and analyze errors from logs, crash reports, or runtime issues. Use when user pastes error logs, mentions "원인을 파악해줘", "오류가 발생", or describes intermittent/unexpected behavior.
---

# Debug Analyze

Analyze errors and debug issues from logs, descriptions, or runtime behavior.

## Trigger Patterns

- `/debug` command
- Keywords: "원인을 파악해줘", "이유를 파악해줘"
- Symptoms: "오류가 발생", "간헐적으로", "동작하지 않아"
- Pasted content: `[Pasted text #1 +N lines]`

## Workflow

### Step 1: Collect Information

**From Pasted Logs**:
```
User: 오류가 발생하는 원인을 분석해:
[Pasted text #1 +16 lines]
```
→ Parse the pasted content for:
- Error messages
- Stack traces
- API responses
- Console output patterns

**From Description**:
```
User: 간헐적으로 애니메이션이 씹히는 현상이 발생하고 있어
```
→ Identify:
- Symptom type (UI, data, network, crash)
- Frequency (always, intermittent, first-time only)
- Context (when does it happen?)

### Step 2: Locate Related Code

```bash
# Search for error-related code
grep -r "errorKeyword" --include="*.swift" .

# Find related files
find . -name "*RelatedClass*"
```

For referenced files (`@filepath`):
- Read the full file
- Understand the flow

### Step 3: Analyze Patterns

**Intermittent Issues** ("간헐적으로"):
- Race conditions
- Timing issues
- State management bugs
- Animation conflicts

**First-Time Issues** ("첫 번째 터치 시"):
- Lazy initialization problems
- Missing initial state
- Uninitialized variables

**Repeated Pattern Issues** ("반복 클릭"):
- Debounce/throttle missing
- State not resetting
- Animation queue conflicts

**API/Network Issues** ("401 에러", "토큰"):
- Token refresh timing
- Header injection issues
- Retry logic problems

### Step 4: Form Hypotheses

Present findings as:
```markdown
## Debug Analysis

### Symptom
{description of the issue}

### Possible Causes

**1. {Most likely cause}** (확률: 높음)
- Location: `{file}:{line}`
- Evidence: {why this is likely}
- Fix: {suggested solution}

**2. {Alternative cause}** (확률: 중간)
- Location: `{file}:{line}`
- Evidence: {supporting evidence}
- Fix: {suggested solution}

### Recommended Action
{which fix to try first}
```

### Step 5: Propose Fix

After analysis:
```markdown
## Proposed Fix

**File**: {filepath}
**Issue**: {description}

**Current Code**:
```swift
// problematic code
```

**Fixed Code**:
```swift
// corrected code
```

Apply this fix? (응/아니)
```

## iOS/Swift Specific Patterns

### Animation Issues
```swift
// Problem: Animation skipping
UIView.animate(withDuration: 0.3) {
    // Changes here might conflict
}

// Fix: Ensure layout is ready
view.layoutIfNeeded()
UIView.animate(withDuration: 0.3) {
    // Apply changes
    self.view.layoutIfNeeded()
}
```

### Race Conditions
```swift
// Problem: Rapid taps causing issues
// Fix: Add throttle/debounce
observable
    .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
    .subscribe(...)
```

### Token/Auth Issues
```swift
// Problem: Stale token in closure capture
let token = UserDefaults.token  // Captured once

// Fix: Fetch fresh token
{ [weak self] in
    let token = UserDefaults.token  // Fresh each time
}
```

## Quick Responses

| User Says | Action |
|-----------|--------|
| "응 현재 동시에 클릭하면 발생하는 문제야" | Focus on race condition analysis |
| "여전히 발생하고 있어" | Previous fix didn't work, try next hypothesis |
| "응 수정해줘" | Apply the proposed fix |

## Comparison Analysis

**Trigger**: "A 는 정상인데 B 는 문제가 있어"

**Workflow**:
1. Read both files
2. Diff the relevant sections
3. Identify what A has that B lacks
4. Propose changes to B

```markdown
## Comparison: {A} vs {B}

### Key Differences
| Aspect | A (Working) | B (Broken) |
|--------|-------------|------------|
| {aspect1} | {value} | {value} |
| {aspect2} | {value} | {value} |

### Root Cause
{B is missing X that A has}

### Fix
{Apply X to B}
```

## Examples

### Example 1: Log Analysis
```
User: 실행했을 때 패턴이 반복되고 있어:
[Pasted text #1 +106 lines]
```
→ Parse logs, identify repeated API calls, find infinite loop cause

### Example 2: Intermittent Bug
```
User: 반복 클릭했을 때 여전히 간헐적으로 애니메이션 없이 동작해
```
→ Check throttle logic, animation queue, state management

### Example 3: Comparison
```
User: 베이직은 매끄러운데 체크박스는 애니메이션이 씹혀
```
→ Compare both implementations, find missing throttle or state handling

## Notes

- Always ask for logs if not provided
- Check related files, not just the mentioned one
- Consider timing and state management for UI issues
- For "간헐적" issues, focus on race conditions first
