---
name: generate-skill
description: Guide for creating effective skills that extend Claude's capabilities with specialized knowledge, workflows, or tool integrations. Use when users want to create a new skill, update an existing skill, need help with SKILL.md files, skill architecture, frontmatter, bundled resources, or troubleshooting skill discovery issues.
---

# Skill Creator

This skill provides guidance for creating effective skills.

## About Skills

Skills are modular, self-contained packages that extend Claude's capabilities by providing specialized knowledge, workflows, and tools. Think of them as "onboarding guides" for specific domains or tasks—they transform Claude from a general-purpose agent into a specialized agent equipped with procedural knowledge that no model can fully possess.

### What Skills Provide

1. **Specialized workflows** - Multi-step procedures for specific domains
2. **Tool integrations** - Instructions for working with specific file formats or APIs
3. **Domain expertise** - Company-specific knowledge, schemas, business logic
4. **Bundled resources** - Scripts, references, and assets for complex and repetitive tasks

## Core Principles

### Concise is Key

The context window is a public good. Skills share the context window with everything else Claude needs: system prompt, conversation history, other Skills' metadata, and the actual user request.

**Default assumption: Claude is already very smart.** Only add context Claude doesn't already have. Challenge each piece of information:
- "Does Claude really need this explanation?"
- "Does this paragraph justify its token cost?"

Prefer concise examples over verbose explanations.

### Set Appropriate Degrees of Freedom

Match the level of specificity to the task's fragility and variability:

**High freedom (text-based instructions)**: Use when multiple approaches are valid, decisions depend on context, or heuristics guide the approach.

**Medium freedom (pseudocode or scripts with parameters)**: Use when a preferred pattern exists, some variation is acceptable, or configuration affects behavior.

**Low freedom (specific scripts, few parameters)**: Use when operations are fragile and error-prone, consistency is critical, or a specific sequence must be followed.

Think of Claude as exploring a path: a narrow bridge with cliffs needs specific guardrails (low freedom), while an open field allows many routes (high freedom).

## Anatomy of a Skill

Every skill consists of a required SKILL.md file and optional bundled resources:

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter metadata (required)
│   │   ├── name: (required)
│   │   └── description: (required)
│   └── Markdown instructions (required)
└── Bundled Resources (optional)
    ├── scripts/          - Executable code (Python/Bash/etc.)
    ├── references/       - Documentation loaded into context as needed
    └── assets/           - Files used in output (templates, icons, fonts)
```

### SKILL.md (required)

Every SKILL.md consists of:

- **Frontmatter** (YAML): Contains `name` and `description` fields. These are the only fields that Claude reads to determine when the skill gets used, thus it is very important to be clear and comprehensive in describing what the skill is, and when it should be used.
- **Body** (Markdown): Instructions and guidance for using the skill. Only loaded AFTER the skill triggers.

### Bundled Resources (optional)

#### scripts/

Executable code (Python/Bash/etc.) for tasks that require deterministic reliability or are repeatedly rewritten.

- **When to include**: When the same code is being rewritten repeatedly or deterministic reliability is needed
- **Example**: `scripts/rotate_pdf.py` for PDF rotation tasks
- **Benefits**: Token efficient, deterministic, may be executed without loading into context
- **Note**: Scripts may still need to be read by Claude for patching or environment-specific adjustments

#### references/

Documentation and reference material intended to be loaded as needed into context.

- **When to include**: For documentation that Claude should reference while working
- **Examples**: `references/schema.md` for database schemas, `references/api_docs.md` for API specifications
- **Use cases**: Database schemas, API documentation, domain knowledge, company policies
- **Benefits**: Keeps SKILL.md lean, loaded only when Claude determines it's needed
- **Best practice**: If files are large (>10k words), include grep search patterns in SKILL.md
- **Avoid duplication**: Information should live in either SKILL.md or references files, not both

#### assets/

Files not intended to be loaded into context, but rather used within the output Claude produces.

- **When to include**: When the skill needs files that will be used in the final output
- **Examples**: `assets/logo.png` for brand assets, `assets/template.html` for boilerplate
- **Use cases**: Templates, images, icons, boilerplate code, fonts
- **Benefits**: Separates output resources from documentation, enables Claude to use files without loading them into context

### What NOT to Include in a Skill

A skill should only contain essential files that directly support its functionality. Do NOT create extraneous documentation or auxiliary files, including:

- README.md
- INSTALLATION_GUIDE.md
- QUICK_REFERENCE.md
- CHANGELOG.md
- etc.

The skill should only contain the information needed for an AI agent to do the job at hand.

## Progressive Disclosure

Skills use a three-level loading system to manage context efficiently:

1. **Metadata (name + description)** - Always in context (~100 words)
2. **SKILL.md body** - When skill triggers (<500 lines recommended)
3. **Bundled resources** - As needed by Claude

Keep SKILL.md body to the essentials and under 500 lines to minimize context bloat. Split content into separate files when approaching this limit.

### Pattern 1: High-level guide with references

```markdown
# PDF Processing

## Quick start
Extract text with pdfplumber:
[code example]

## Advanced features
- **Form filling**: See [FORMS.md](FORMS.md) for complete guide
- **API reference**: See [REFERENCE.md](REFERENCE.md) for all methods
```

Claude loads FORMS.md or REFERENCE.md only when needed.

### Pattern 2: Domain-specific organization

For Skills with multiple domains, organize content by domain:

```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── references/
    ├── finance.md (revenue, billing metrics)
    ├── sales.md (opportunities, pipeline)
    └── product.md (API usage, features)
```

When a user asks about sales metrics, Claude only reads sales.md.

### Pattern 3: Conditional details

```markdown
# DOCX Processing

## Creating documents
Use docx-js for new documents. See [DOCX-JS.md](DOCX-JS.md).

## Editing documents
For simple edits, modify the XML directly.
**For tracked changes**: See [REDLINING.md](REDLINING.md)
```

**Important guidelines:**
- Keep references one level deep from SKILL.md
- For files longer than 100 lines, include a table of contents at the top

## Skill Creation Process

### Step 1: Understand with Concrete Examples

To create an effective skill, clearly understand concrete examples of how the skill will be used. Ask questions like:

- "What functionality should this skill support?"
- "Can you give some examples of how this skill would be used?"
- "What would a user say that should trigger this skill?"

Conclude this step when there is a clear sense of the functionality the skill should support.

### Step 2: Plan Reusable Contents

Analyze each example by:
1. Considering how to execute on the example from scratch
2. Identifying what scripts, references, and assets would be helpful

**Example analysis:**
- `pdf-editor` skill for "Help me rotate this PDF" → `scripts/rotate_pdf.py`
- `frontend-builder` skill for "Build me a todo app" → `assets/hello-world/` template
- `bigquery` skill for "How many users logged in?" → `references/schema.md`

### Step 3: Initialize the Skill

Create the skill directory:

```bash
# Project skill (git-tracked, team-shared)
mkdir -p .claude/skills/skill-name

# Personal skill (available across all projects)
mkdir -p ~/.claude/skills/skill-name
```

Create the basic structure:
```bash
mkdir -p skill-name/{scripts,references,assets}
touch skill-name/SKILL.md
```

### Step 4: Edit the Skill

Remember that the skill is being created for another instance of Claude to use. Include information that would be beneficial and non-obvious.

#### Frontmatter

Write the YAML frontmatter with `name` and `description`:

```yaml
---
name: skill-name
description: What this skill does and specific triggers for when to use it. Include all "when to use" information here.
---
```

**Field requirements:**

| Field | Required | Max Length | Rules |
|-------|----------|------------|-------|
| `name` | Yes | 64 chars | Lowercase, numbers, hyphens only. Must match directory name. |
| `description` | Yes | 1024 chars | Include WHAT it does + WHEN to use it. Third person only. |

Do not include any other fields in YAML frontmatter.

#### Writing Effective Descriptions

**Formula:** `[What it does] + [When to use it] + [Trigger keywords]`

**Good examples:**

```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.

description: Comprehensive document creation, editing, and analysis with support for tracked changes. Use when Claude needs to work with .docx files for creating, modifying, or editing content.
```

**Bad examples:**

```yaml
description: Helps with documents  # Too vague
description: For data analysis  # Too generic
description: I can help you process PDF files  # First person - causes discovery issues
```

#### Body

Write instructions using imperative/infinitive form. Include:
- Quick start example
- Step-by-step instructions
- References to bundled resources

### Step 5: Validate

Before finalizing, verify:

**File Structure:**
- [ ] SKILL.md exists in skill directory
- [ ] Directory name matches frontmatter `name`
- [ ] No deeply nested references (max 1 level)
- [ ] No extraneous files (README.md, CHANGELOG.md, etc.)

**YAML Frontmatter:**
- [ ] Opens with `---` on line 1
- [ ] Closes with `---` before content
- [ ] Valid YAML syntax (no tabs, correct indentation)
- [ ] `name`: lowercase, hyphens only, ≤64 chars
- [ ] `description`: specific, ≤1024 chars, third person

**Description Quality:**
- [ ] Includes WHAT it does
- [ ] Includes WHEN to use it
- [ ] Contains trigger keywords
- [ ] Specific enough to distinguish from other skills

**Content Quality:**
- [ ] SKILL.md body under 500 lines
- [ ] Instructions are step-by-step
- [ ] Examples are concrete (real code, not pseudocode)
- [ ] Scripts tested and working
- [ ] File paths use forward slashes

### Step 6: Iterate

After testing the skill, users may request improvements.

**Iteration workflow:**
1. Use the skill on real tasks
2. Notice struggles or inefficiencies
3. Identify how SKILL.md or bundled resources should be updated
4. Implement changes and test again

## Troubleshooting

### Skill Doesn't Activate

1. **Make description more specific:**
   - Add trigger words users would say
   - Include file types and operations
   - Add "Use when..." clause

2. **Check file location:**
   ```bash
   ls ~/.claude/skills/skill-name/SKILL.md
   ls .claude/skills/skill-name/SKILL.md
   ```

3. **Validate YAML:**
   ```bash
   head -n 10 SKILL.md
   ```

### Multiple Skills Conflict

- Make descriptions more distinct
- Use different trigger words
- Narrow each skill's scope

### Skill Has Errors

- Check YAML syntax (no tabs, proper indentation)
- Verify file paths use forward slashes
- Ensure scripts have execute permissions
- Test scripts before including them

## Output Format

When creating a Skill, follow this process:

1. Ask clarifying questions about scope and requirements
2. Analyze concrete examples to identify reusable resources
3. Suggest a skill name and location
4. Create SKILL.md with proper frontmatter
5. Include clear instructions and concrete examples
6. Add bundled resources (scripts, references, assets) as needed
7. Validate against the checklist
8. Provide testing instructions

The result: a complete, working Skill that follows all best practices.
