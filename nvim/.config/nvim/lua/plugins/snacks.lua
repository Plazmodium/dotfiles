return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- Core features (enabled)
		bigfile = { enabled = true },
		explorer = {
			enabled = true,
		},
		indent = { enabled = true },
		input = { enabled = true },
		notifier = { enabled = true, timeout = 3000 },
		picker = {
			enabled = true,
			-- Exclude directories (frontend + backend) - matching previous telescope config
			sources = {
				files = {
					hidden = true,
					ignored = false,
					exclude = {
						"node_modules",
						"dist",
						".git",
						"target",
						"build",
						".gradle",
						"*.class",
						"*.jar",
					},
				},
				grep = {
					hidden = true,
					ignored = false,
					exclude = {
						"node_modules",
						"dist",
						".git",
						"target",
						"build",
						".gradle",
						"*.class",
						"*.jar",
					},
				},
				explorer = {
					hidden = true,
					ignored = true,
					exclude = {
						"node_modules",
						"dist",
						".git",
						"target",
						"build",
						".gradle",
						"*.class",
						"*.jar",
					},
				},
			},
		},
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		lazygit = { enabled = true },
		-- Optional features (disabled by default)
		dashboard = { enabled = false },
		dim = { enabled = false },
		zen = { enabled = false },
		scratch = { enabled = false },
	},
	keys = {
		-- File Explorer
		{ "<leader>n", function() Snacks.explorer() end, desc = "File Explorer" },
		{
			"<leader>ni",
			function()
				vim.g.snacks_explorer_show_ignored = not vim.g.snacks_explorer_show_ignored
				Snacks.explorer({ ignored = vim.g.snacks_explorer_show_ignored == true })
				vim.notify("Explorer ignored files: " .. (vim.g.snacks_explorer_show_ignored and "ON" or "OFF"))
			end,
			desc = "Explorer Toggle Ignored",
		},

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
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				if vim.fn.argc() == 0 then
					Snacks.explorer()
				end
			end,
		})

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
