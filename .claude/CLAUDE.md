## IMPORTANT

If the prompt matches any available skill keywords, use Skill(skill-name) to activate it.

Step 1 - EVALUATE: For each skill, state YES/NO with reason
Step 2 - ACTIVATE: Use Skill() tool NOW
Step 3 - IMPLEMENT: Only after activation

CRITICAL: The evaluation is WORTHLESS unless you ACTIVATE the skills.

## Scope & Approach

- Do NOT expand scope beyond what was explicitly requested. If you see opportunities to do more, ask first.
- When asked to fix a bug, try the simplest targeted fix first before attempting architectural changes.
- If your first approach fails, step back and re-analyze the root cause before trying another fix of the same type.

## Language & Communication

- Always write skills, documentation, comments, and code docs in English unless explicitly asked for another language.
- When explaining concepts, be direct and concise — avoid lengthy preambles.

## Build Verification

- After every task, verify the build by running `xcodebuild` piped through `xcsift -f toon -w`.
- Infer the correct build command from the project structure:
    - Use `-workspace` if `.xcworkspace` exists, otherwise `-project`
    - Detect the primary scheme via `xcodebuild -list`
    - Choose destination based on the target platform (e.g., iOS Simulator for iOS, macOS for macOS)
- Treat build failure as a blocking issue that must be resolved before closing the task.
- Document the build result (pass/fail) in your final response.

## Decision Dialogue

When there are 2+ valid implementation approaches, present them as structured options with tradeoffs before proceeding. Include:
- What each option entails (1-2 sentences)
- Key tradeoff (e.g., simplicity vs flexibility, performance vs readability)

When the user picks an option or rejects a suggestion, briefly ask why — e.g., "어떤 점 때문에 이걸 선택하셨어요?" or "이 방식이 마음에 안 드는 이유가 있나요?" Keep it to one follow-up question, not an interrogation.

Before implementing the chosen approach, summarize the decision in one line:
> Decision: [what was chosen] because [user's stated reason]

This creates a traceable decision trail for session-decisions extraction.

Do NOT apply this to trivial choices (naming, formatting, single-line fixes). Only for architectural, structural, or design decisions.

## Git Operations

- When asked to merge a branch, only merge the specific branch requested unless explicitly told to merge additional branches.
- After any merge or rebase, always run a build verification before pushing.
- When splitting commits, present the proposed split plan before executing.
