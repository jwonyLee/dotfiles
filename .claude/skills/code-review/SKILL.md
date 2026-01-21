---
name: code-review
description: Review code changes in the current branch compared to the base branch. Analyzes commits for bugs, logic errors, code style, conventions, and architecture. Use when the user asks to review code, review PR, review changes, code review, or check code quality.
---

# Code Review

Review code changes in the current branch by analyzing commits that differ from the base branch.

## Workflow

### Step 1: Identify the review scope

```bash
# Find base branch (usually master or main)
git merge-base HEAD master || git merge-base HEAD main

# List commits to review
git log --oneline $(git merge-base HEAD master)..HEAD

# Get changed files
git diff --name-only $(git merge-base HEAD master)..HEAD
```

### Step 2: Analyze changes

For each changed file, run:
```bash
git diff $(git merge-base HEAD master)..HEAD -- <file_path>
```

### Step 3: Review criteria

Evaluate each change against:

**Bugs & Logic**
- Null/nil checks and optional handling
- Edge cases and boundary conditions
- Race conditions in async code
- Memory leaks (retain cycles, unclosed resources)
- Error handling completeness

**Code Style & Conventions**
- Naming conventions (files, classes, variables)
- Code formatting and indentation
- Comment quality (not excessive, explains "why" not "what")
- Dead code or unused imports

**Architecture & Design**
- MVVM pattern compliance (ViewModel handles logic, VC handles UI)
- Dependency injection usage
- Single responsibility principle
- Appropriate abstraction level
- API layer usage (CoreClient vs legacy APIs)

**iOS/Swift Specific**
- Memory management (@escaping closures, weak self)
- RxSwift disposal (DisposeBag lifecycle)
- Thread safety (main thread for UI)
- SnapKit constraint conflicts

### Step 4: Output format

Present findings as inline comments per file:

```
## filename.swift

### Line 42-45
[severity: critical|warning|suggestion]
<issue description>
<suggested fix if applicable>

### Line 78
[severity: suggestion]
<issue description>
```

Severity levels:
- **critical**: Bugs, crashes, security issues - must fix
- **warning**: Code smell, potential issues - should fix
- **suggestion**: Style, readability improvements - nice to have

### Step 5: Summary

After file-by-file review, provide:
- Total issues by severity
- Overall assessment (approve/request changes)
- Key patterns or recurring issues

## Quick start

```
/code-review
```

This reviews all commits on the current branch that are not in the base branch (master/main).
