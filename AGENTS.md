# Dotfiles Guidelines

## Formatting

- Use one tab per indentation level in Lua and Zsh files.
- Run Stylua for Lua files; `nvim/.config/nvim/stylua.toml` enforces tab indentation.
- In Makefiles, use tabs only for recipe commands. Do not indent targets or variable assignments.
- Keep JSON and TOML files formatted with spaces. Do not manually reformat generated lockfiles.
