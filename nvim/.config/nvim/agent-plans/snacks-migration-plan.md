# Snacks.nvim Migration Plan

## Overview

Migrate from current plugin setup to snacks.nvim for consolidated functionality, plus add diffview.nvim for conflict resolution.

## Summary of Changes

### Plugins to Remove

| File | Plugin | Replaced By |
|------|--------|-------------|
| `lua/plugins/telescope.lua` | nvim-telescope/telescope.nvim | snacks.picker |
| `lua/plugins/telescope.lua` | telescope-ui-select.nvim | snacks.input |
| `lua/plugins/neotree.lua` | nvim-tree/nvim-tree.lua | snacks.explorer |
| `lua/plugins/lazygit.lua` | kdheepak/lazygit.nvim | snacks.lazygit |

### Plugins to Add

| File | Plugin | Purpose |
|------|--------|---------|
| `lua/plugins/snacks.lua` | folke/snacks.nvim | Consolidated QoL plugins |
| `lua/plugins/diffview.lua` | sindrets/diffview.nvim | Git diff/merge conflict resolution |

### Plugins to Keep (No Changes)

| File | Plugin | Reason |
|------|--------|--------|
| `lua/plugins/harpoon.lua` | ThePrimeagen/harpoon | No overlap, works independently |
| `lua/plugins/gitsigns.lua` | lewis6991/gitsigns.nvim | Complementary (buffer signs vs utilities) |
| `lua/plugins/folke.lua` | folke/trouble.nvim, folke/which-key.nvim | Compatible, snacks integrates with which-key |
| `lua/plugins/lualine.lua` | nvim-lualine/lualine.nvim | Statusline != statuscolumn |
| `lua/plugins/treesitter.lua` | nvim-treesitter | Required by snacks.scope |
| `lua/plugins/lsp-config.lua` | Mason, LSP, cmp | Core LSP functionality |
| `lua/plugins/none-ls.lua` | nvimtools/none-ls.nvim | Formatting/linting |
| `lua/plugins/autopairs.lua` | windwp/nvim-autopairs | No overlap |
| `lua/plugins/commenting.lua` | Comment plugin | No overlap |
| `lua/plugins/dap.lua` | Debug adapter | No overlap |
| `lua/plugins/themes.lua` | Colorschemes | No overlap |
| `lua/plugins/java.lua` | Java support | No overlap |

---

## Detailed Implementation

### Step 1: Create snacks.nvim Configuration

Create `lua/plugins/snacks.lua`:

```lua
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- Core features (enabled)
		bigfile = { enabled = true },
		explorer = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		notifier = { enabled = true, timeout = 3000 },
		picker = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		lazygit = { enabled = true },
		-- Optional features
		dashboard = { enabled = false }, -- Enable if you want a start screen
		dim = { enabled = false },
		zen = { enabled = false },
		scratch = { enabled = false },
	},
	keys = {
		-- File Explorer
		{ "<leader>n", function() Snacks.explorer() end, desc = "File Explorer" },

		-- Picker (replaces Telescope)
		{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
		{ "<leader>fg", function() Snacks.picker.grep() end, desc = "Live Grep" },
		{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
		{ "<leader>fh", function() Snacks.picker.help() end, desc = "Help Tags" },
		{ "<leader>fs", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
		{ "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
		{ "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },

		-- Git (via picker)
		{ "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
		{ "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },

		-- LazyGit
		{ "<leader>gg", function() Snacks.lazygit() end, desc = "LazyGit" },

		-- Search
		{ "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
		{ "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
		{ "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
		{ "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Grep Word", mode = { "n", "x" } },

		-- LSP (via picker)
		{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
		{ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
		{ "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
		{ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
		{ "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },

		-- Notifications
		{ "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss Notifications" },
		{ "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Notification History" },

		-- Buffer
		{ "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },

		-- Terminal
		{ "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal" },

		-- Words (LSP references navigation)
		{ "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
		{ "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Debug helpers
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end

				-- Toggle mappings (integrates with which-key)
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.indent():map("<leader>ug")
				Snacks.toggle.dim():map("<leader>uD")
			end,
		})
	end,
}
```

### Step 2: Create diffview.nvim Configuration

Create `lua/plugins/diffview.lua`:

```lua
return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
	keys = {
		{ "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
		{ "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
		{ "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History" },
		{ "<leader>dH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview Branch History" },
	},
	config = function()
		require("diffview").setup({
			enhanced_diff_hl = true,
			view = {
				default = {
					layout = "diff2_horizontal",
				},
				merge_tool = {
					layout = "diff3_mixed",
					disable_diagnostics = true,
				},
			},
			file_panel = {
				win_config = {
					position = "left",
					width = 35,
				},
			},
			keymaps = {
				view = {
					{ "n", "<leader>co", "<cmd>DiffviewConflictChooseOurs<cr>", { desc = "Choose Ours" } },
					{ "n", "<leader>ct", "<cmd>DiffviewConflictChooseTheirs<cr>", { desc = "Choose Theirs" } },
					{ "n", "<leader>cb", "<cmd>DiffviewConflictChooseBoth<cr>", { desc = "Choose Both" } },
					{ "n", "<leader>cB", "<cmd>DiffviewConflictChooseBase<cr>", { desc = "Choose Base" } },
					{ "n", "]x", "<cmd>DiffviewNextConflict<cr>", { desc = "Next Conflict" } },
					{ "n", "[x", "<cmd>DiffviewPrevConflict<cr>", { desc = "Prev Conflict" } },
				},
			},
		})
	end,
}
```

### Step 3: Delete Old Plugin Files

Remove these files:
- `lua/plugins/telescope.lua`
- `lua/plugins/neotree.lua`
- `lua/plugins/lazygit.lua`

### Step 4: Update gitsigns.lua Keymaps (Optional)

Some gitsigns keymaps may conflict with snacks git pickers. Review and adjust if needed.

Current gitsigns keymaps that may overlap:
- `<leader>gp` - gitsigns: Preview Hunk | snacks: could be git_pull
- `<leader>gb` - gitsigns: Blame Line | snacks: git_branches
- `<leader>gd` - gitsigns: Diff This | snacks: git_diff

Recommendation: Keep gitsigns keymaps as-is since they're buffer-specific actions. Use different prefix for snacks git pickers if needed.

---

## Keymap Reference (After Migration)

### File Navigation
| Keymap | Action | Plugin |
|--------|--------|--------|
| `<leader>n` | File Explorer | snacks.explorer |
| `<leader>ff` | Find Files | snacks.picker |
| `<leader>fg` | Live Grep | snacks.picker |
| `<leader>fb` | Buffers | snacks.picker |
| `<leader>fr` | Recent Files | snacks.picker |
| `<leader>fc` | Config Files | snacks.picker |

### Harpoon (Unchanged)
| Keymap | Action |
|--------|--------|
| `<leader>a` | Add File |
| `<leader>r` | Remove File |
| `<leader>h` | Toggle Menu |
| `<leader>j/k/l/;` | Go to File 1-4 |

### Git
| Keymap | Action | Plugin |
|--------|--------|--------|
| `<leader>gg` | LazyGit | snacks.lazygit |
| `<leader>gl` | Git Log | snacks.picker |
| `<leader>gf` | Git File Log | snacks.picker |
| `<leader>gs` | Stage Hunk | gitsigns |
| `<leader>gr` | Reset Hunk | gitsigns |
| `<leader>gp` | Preview Hunk | gitsigns |
| `<leader>gb` | Blame Line | gitsigns |
| `<leader>gd` | Diff This | gitsigns |

### Diffview (New)
| Keymap | Action |
|--------|--------|
| `<leader>dv` | Open Diffview |
| `<leader>dc` | Close Diffview |
| `<leader>dh` | File History |
| `<leader>dH` | Branch History |
| `<leader>co` | Choose Ours (in merge) |
| `<leader>ct` | Choose Theirs (in merge) |
| `<leader>cb` | Choose Both (in merge) |
| `]x` / `[x` | Next/Prev Conflict |

### LSP
| Keymap | Action | Plugin |
|--------|--------|--------|
| `gd` | Go to Definition | snacks.picker |
| `gr` | References | snacks.picker |
| `gI` | Implementations | snacks.picker |
| `gy` | Type Definition | snacks.picker |
| `<leader>ss` | LSP Symbols | snacks.picker |

### Toggles (New)
| Keymap | Action |
|--------|--------|
| `<leader>us` | Toggle Spelling |
| `<leader>uw` | Toggle Wrap |
| `<leader>uL` | Toggle Relative Number |
| `<leader>ud` | Toggle Diagnostics |
| `<leader>ul` | Toggle Line Numbers |
| `<leader>uh` | Toggle Inlay Hints |
| `<leader>ug` | Toggle Indent Guides |

---

## Execution Checklist

- [ ] Create `lua/plugins/snacks.lua`
- [ ] Create `lua/plugins/diffview.lua`
- [ ] Delete `lua/plugins/telescope.lua`
- [ ] Delete `lua/plugins/neotree.lua`
- [ ] Delete `lua/plugins/lazygit.lua`
- [ ] Run `:Lazy sync` to install new plugins
- [ ] Run `:checkhealth snacks` to verify setup
- [ ] Test keymaps work correctly
- [ ] Test diffview conflict resolution

---

## Rollback Plan

If issues arise, restore deleted files from git:
```bash
git checkout HEAD -- lua/plugins/telescope.lua lua/plugins/neotree.lua lua/plugins/lazygit.lua
```

Then remove snacks.lua and diffview.lua, and run `:Lazy sync`.

---

## Notes

- snacks.nvim requires Neovim >= 0.9.4
- diffview.nvim works best with nvim-web-devicons (already installed via other plugins)
- First launch after migration will install new plugins automatically
- Some features like `snacks.image` require terminal support (kitty, wezterm, ghostty)
