# pbproject Templates

This directory contains template files used by `pbproject` and `llm-link` to bootstrap new projects.

## Files Created by `llm-link`

When you run `llm-link` in a project directory, it will:

1. **Copy** `LLM_INSTRUCTIONS.md` as the main instruction file
2. **Create symlinks** for all AI tools that point to `LLM_INSTRUCTIONS.md`:
   - `AGENTS.md` → `LLM_INSTRUCTIONS.md` (OpenCode)
   - `CLAUDE.md` → `LLM_INSTRUCTIONS.md` (Claude Desktop)
   - `GEMINI.md` → `LLM_INSTRUCTIONS.md` (Gemini CLI)
3. **Copy directory structures** and create internal symlinks:
   - `.github/` directory (for GitHub Copilot)
     - `copilot-instructions.md` → `../LLM_INSTRUCTIONS.md`
   - `.roo/` directory (for Roo)
     - `rules/00-general.md` → `../../LLM_INSTRUCTIONS.md`

## Benefits

- **Single source of truth**: All AI tools read from the same `LLM_INSTRUCTIONS.md` file
- **Easy customization**: Edit one file to update instructions for all AI tools
- **Project-specific**: Each project gets its own copy of the template to customize
- **Detachable**: Use `llm-link --detach` to convert symlinks to independent copies when needed

## Template Structure

```
project-templates/
├── README.md                    # This file
├── LLM_INSTRUCTIONS.md         # Main template with project analysis TODOs and anti-sycophancy rules
├── github/                     # GitHub Copilot directory structure
└── roo/                        # Roo directory structure
    └── rules/
```

The actual instruction files are created by the `llm-link` script, not stored as templates.