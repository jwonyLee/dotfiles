## IMPORTANT

If the prompt matches any available skill keywords, use Skill(skill-name) to activate it.

Step 1 - EVALUATE: For each skill, state YES/NO with reason
Step 2 - ACTIVATE: Use Skill() tool NOW
Step 3 - IMPLEMENT: Only after activation

CRITICAL: The evaluation is WORTHLESS unless you ACTIVATE the skills.

## Build Verification

- After every task, verify the build by running `xcodebuild` piped through `xcsift -f toon -w`.
- Infer the correct build command from the project structure:
    - Use `-workspace` if `.xcworkspace` exists, otherwise `-project`
    - Detect the primary scheme via `xcodebuild -list`
    - Choose destination based on the target platform (e.g., iOS Simulator for iOS, macOS for macOS)
- Treat build failure as a blocking issue that must be resolved before closing the task.
- Document the build result (pass/fail) in your final response.
