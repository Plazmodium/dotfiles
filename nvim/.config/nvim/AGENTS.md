# AGENTS.md - Neovim Configuration

Instructions for AI coding agents working in this repository.

## Project Overview

Personal Neovim configuration using lazy.nvim as the plugin manager. Lua-based config targeting web development workflows (TypeScript, Angular, HTML/CSS).

## Architecture

```
init.lua              # Entry point: bootstraps lazy.nvim, loads vim-commands and plugins
lua/
  vim-commands.lua    # Core Neovim settings (options, highlights, basic keymaps)
  plugins.lua         # Empty placeholder (plugins loaded from plugins/ directory)
  plugins/            # Each file returns a lazy.nvim plugin spec
```

lazy.nvim auto-discovers plugin specs from `lua/plugins/` directory.

## Build/Test/Lint Commands

This is a Neovim configuration, not a typical software project. There are no build or test commands.

### Validation Commands (run inside Neovim)

```vim
:checkhealth              " Check Neovim and plugin health
:Lazy                     " Open lazy.nvim UI to manage plugins
:Lazy sync                " Update all plugins
:Mason                    " Open Mason UI to manage LSP servers
:LspInfo                  " Show attached LSP clients
:messages                 " View recent messages/errors
```

### Linting/Formatting

- **Lua files**: Formatted with `stylua` via none-ls.nvim
- **Auto-format on save**: Enabled via `BufWritePre` autocmd in `vim-commands.lua:31`
- **Run stylua manually**: `stylua lua/`

### Testing Changes

1. Save the file (triggers auto-format)
2. Restart Neovim or run `:source %` for simple changes
3. Run `:checkhealth` to verify plugin health
4. Check `:messages` for errors

## Code Style Guidelines

### Indentation and Whitespace

- Use tabs for indentation (displayed as 2 spaces)
- Config: `tabstop=2`, `softtabstop=2`, `shiftwidth=0` (follows tabstop)
- `expandtab` is enabled, so tabs are converted to spaces

### Quotes

- Use **double quotes** for all strings
- Consistent throughout: `"plugin/name"`, `"normal"`, `"leader"`

### Table Formatting

Multi-line tables with trailing commas:

```lua
return {
	{
		"author/plugin-name",
		config = function()
			-- setup code
		end,
	},
}
```

Inline tables for simple options:

```lua
{ noremap = true, silent = true, desc = "Description" }
```

### Imports and Requires

```lua
-- Standard pattern: require then call setup
local cmp = require("cmp")
require("mason").setup()

-- For plugin specs, require inside config function
config = function()
	local builtin = require("telescope.builtin")
end
```

### Naming Conventions

| Type | Convention | Examples |
|------|------------|----------|
| Files | kebab-case or lowercase | `lsp-config.lua`, `telescope.lua` |
| Variables | snake_case | `null_ls`, `lazypath`, `builtin` |
| Short aliases | lowercase | `cmp`, `gs`, `opts` |
| Plugin specs | No top-level locals | Return table directly |

### Function Style

- Use **anonymous functions** for plugin configs
- Prefer `vim.keymap.set` over legacy `vim.api.nvim_set_keymap`

```lua
config = function()
	vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
end
```

### Keymap Definitions

```lua
-- Modern style (preferred)
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

-- With description for which-key
vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon Add File" })

-- Legacy style (avoid for new code)
vim.api.nvim_set_keymap("n", "<Leader>tv", ":vsplit | terminal<CR>", { noremap = true, silent = true })
```

### Error Handling

Use `pcall` for optional/potentially failing operations:

```lua
pcall(vim.treesitter.start)

if not pcall(vim.treesitter.language.add, lang) then
	pcall(function()
		require("nvim-treesitter").install({ lang })
	end)
end
```

### Comments

```lua
-- Single line comment for explanations
-- URL references for solutions
-- https://stackoverflow.com/questions/...

-- Section headers
-- Diagnostic keymaps
-- Actions
```

## Plugin Spec Patterns

### Single Plugin

```lua
return {
	"author/plugin-name",
	config = function()
		require("plugin-name").setup({})
	end,
}
```

### Multiple Plugins

```lua
return {
	{
		"plugin-one",
		config = function() end,
	},
	{
		"plugin-two",
		dependencies = { "dep/plugin" },
		config = function() end,
	},
}
```

### Common Spec Fields

| Field | Usage |
|-------|-------|
| `config` | Function-based setup (most common) |
| `opts` | Table-based setup (simple configs) |
| `dependencies` | Plugin dependencies |
| `branch` | Specific branch (`"0.1.x"`) |
| `build` | Build command (`":TSUpdate"`) |
| `event` | Lazy loading trigger (`"InsertEnter"`) |
| `cmd` | Command-based lazy loading |
| `lazy` | Explicit lazy loading control |
| `priority` | Load order (themes use `1000`) |

## Leader Key

Space is the leader key: `vim.g.mapleader = " "`

## Important Files

- `init.lua` - Entry point, bootstraps lazy.nvim
- `lua/vim-commands.lua` - Core settings, highlights, basic keymaps
- `lua/plugins/lsp-config.lua` - Mason, LSP, and completion setup
- `lua/plugins/none-ls.lua` - Formatting and linting (stylua, prettier, eslint_d)

## Adding New Plugins

Create a new file in `lua/plugins/` returning a lazy.nvim spec:

```lua
return {
	"author/plugin-name",
	dependencies = { "optional/dependency" },
	config = function()
		require("plugin-name").setup({
			-- options
		})
		-- keymaps
		vim.keymap.set("n", "<leader>xx", function() end, { desc = "Description" })
	end,
}
```

## Vim API Preferences

```lua
-- Options (use vim.opt)
vim.opt.scrolloff = 8
vim.opt.termguicolors = true
vim.g.mapleader = " "
vim.wo.relativenumber = true

-- Avoid vim.cmd for settings when vim.opt works
-- vim.cmd("set expandtab")  -- legacy
vim.opt.expandtab = true     -- preferred

-- Highlights
vim.api.nvim_command("highlight GroupName guifg=#color guibg=#color")
```
