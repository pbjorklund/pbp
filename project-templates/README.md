# pbproject Templates

This directory contains template files used by `pbproject` and `llm-setup` to bootstrap new projects.

## Files Created by `llm-setup`

When you run `llm-setup` in a project directory, it will:

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
- **Centralized updates**: All AI tool configs are symlinked to one LLM_INSTRUCTIONS.md file
- **Project-specific**: Each project gets its own copy of LLM_INSTRUCTIONS.md to customize

The actual instruction files are created by the `llm-setup` script, not stored as templates.