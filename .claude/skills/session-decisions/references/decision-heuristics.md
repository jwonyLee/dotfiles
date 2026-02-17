# Decision Detection Heuristics

Patterns and keywords for identifying technical decisions in Claude Code session conversations.

## Signal Scoring

### HIGH Signal (score 3+) — Deep analysis target

Sessions likely containing meaningful technical decisions:

- **Explicit architecture discussion**: "Let's structure this as...", "The module should..."
- **Technology comparison**: "X vs Y", "Should we use A or B?"
- **Design pattern application**: "Use the coordinator pattern because..."
- **Migration strategy**: "Convert from RxSwift to Concurrency by..."
- **Constraint-driven design**: "We can't do X because of Y, so instead..."

### MEDIUM Signal (score 2) — Include if HIGH count < 10

May contain decisions worth extracting:

- Debugging with root cause analysis (not just fixing a typo)
- Refactoring rationale: "This should be separated because..."
- Performance optimization choices: "Use lazy loading instead of..."
- API design decisions: "The interface should expose..."

### LOW Signal (score 1) — Skip unless combined with other signals

Usually routine work:

- Simple bug fixes
- Configuration changes
- Dependency updates
- Routine feature implementation without significant design choices

### NONE (score 0) — Always skip

- `/exit`, `/mcp`, system commands
- Very short sessions (< 5 messages)
- Sessions with only tool calls and no substantive text

---

## Keyword Groups

### Architecture & Design
```
architect|design|pattern|structure|module|layer|separation|dependency|injection|
coordinator|protocol|interface|abstraction|encapsulation|coupling|cohesion
```

### Technology Selection & Tradeoffs
```
versus|vs|compare|comparison|tradeoff|trade-off|pros|cons|advantage|disadvantage|
alternative|approach|option|migrate|migration|replace|switch|adopt
```

### Problem-Solving & Constraints
```
constraint|limitation|workaround|cannot|blocked|issue|root cause|debug|
investigate|hypothesis|bottleneck|optimize|performance|memory|latency
```

### Process & Workflow
```
refactor|automation|workflow|process|improve|efficiency|ci|cd|pipeline|
convention|standard|practice|review
```

---

## Conversation Patterns

### 1. Question-Exploration-Conclusion Arc

A question is asked, alternatives are explored, and a conclusion is reached.

**Indicators:**
- User asks "How should we...", "What's the best way to..."
- Assistant explores 2+ options
- User confirms direction or asks follow-up

### 2. Rejection-Revision Loop

First approach is attempted, fails or is rejected, and an alternative is chosen.

**Indicators:**
- Attempt → error or suboptimal result
- "That doesn't work because..."
- New approach proposed and accepted

### 3. Pros/Cons Enumeration

Explicit listing of advantages and disadvantages for alternatives.

**Indicators:**
- Structured comparison in assistant response
- Words: "pros", "cons", "advantage", "disadvantage", "trade-off"
- Numbered or bulleted comparison lists

### 4. "Instead" / "Rather" Markers

Expressions indicating a deliberate choice between alternatives.

**Indicators:**
- "Instead of X, let's use Y"
- "Rather than..., we should..."
- "A better approach would be..."
- "I chose X over Y because..."

### 5. Long Analytical Responses

Multi-paragraph technical analysis usually indicates decision support.

**Indicators:**
- Assistant response > 500 words with structured reasoning
- Multiple sections or headers in response
- Code examples comparing approaches

---

## User Attribution Signals

### How to Determine WHO Made the Decision

When analyzing a session, always check the `role` field of each message. Only `"human"` role messages count as user decisions.

### User-Driven Decision Patterns

These patterns in **user messages** indicate the user actively drove the decision:

#### 1. Explicit Choice (User selects from options)
```
User: "2번으로 가자" / "A 방식으로 해" / "Input/Output/Signal 패턴 써"
Context: Claude presented multiple options, user picked one
Attribution: user-directed
```

#### 2. Rejection-Redirect (User rejects and redirects)
```
User: "그거 말고 ~처럼 해" / "아니, 이건 아닌 것 같아" / "다시 해봐"
Context: Claude proposed something, user rejected it
Attribution: user-rejected
```

#### 3. Reference Specification (User names a specific reference)
```
User: "MPTextViewV2 참고해" / "Airport 패턴 따라" / "socar-ios에서 쓰는 방식으로"
Context: User specifies a concrete reference for Claude to follow
Attribution: user-directed
```

#### 4. Mid-Course Correction (User changes direction during work)
```
User: "이게 아니라 ~로 바꿔" / "여기서 ~ 방식이 더 나을 것 같아"
Context: Implementation was underway, user corrected course
Attribution: user-feedback
```

#### 5. Iterative Rejection (Multiple rounds of revision)
```
User: (round 1) "개별 속성으로 제어하고 싶어"
User: (round 2) "setBorderColor 같은 문법으로"
User: (round 3) "setter 메서드 방식으로"
Context: User rejected 2+ proposals, progressively refining requirements
Attribution: user-rejected (strongest signal — multiple rejections)
```

### NOT User Decisions (Exclude by Default)

#### 1. Passive Approval
```
User: "ㅇㅇ" / "좋아" / "진행해" / "ㄱㄱ" / "그래"
Context: Claude proposed and user just approved
Attribution: claude-proposed (user merely accepted)
```

#### 2. Task Delegation Without Direction
```
User: "리팩토링 해줘" / "테스트 추가해줘" / "빌드 에러 고쳐줘"
Context: User assigned task but didn't specify HOW
Attribution: claude-autonomous (Claude chose the approach)
```

#### 3. Claude's Implementation Choices
```
Assistant: "Swift Testing을 사용하겠습니다" (user didn't ask for it)
Assistant: "KVO를 사용하는 것이 적합합니다" (Claude's technical judgment)
Context: Claude made technical selection during implementation
Attribution: claude-autonomous
```

### Edge Cases

| Scenario | Attribution | Reasoning |
|---|---|---|
| User asks "어떻게 하면 좋을까?" then accepts Claude's answer | claude-proposed | User asked for advice and accepted it |
| User says "C -> A -> B 순서로 해" after seeing Claude's analysis | user-directed | User specified the execution order |
| User says "커밋 나눠줘" and Claude decides how to split | claude-autonomous | User requested outcome, not method |
| User says "커밋 3개로 나눠줘, 각각 빌드되게" | user-directed | User specified constraints |

---

## Learning Indicator Patterns

Borrowed from learning-extractor agent for complementary detection:

- **Questions**: "How does X work?", "Why did Y fail?", "Best way to do Z?"
- **Trial and error**: Multiple attempts before success
- **Surprises**: "Interesting!", "Didn't know that", "Unexpected"
- **Corrections**: "Actually X doesn't work that way", "Should do Y instead"
- **Optimizations**: "This is faster/better than the old way"
