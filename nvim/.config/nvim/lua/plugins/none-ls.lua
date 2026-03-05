-- ============================================================================
-- FORMATTING & LINTING (none-ls / null-ls)
-- ============================================================================
--
-- none-ls acts as a bridge between external formatters/linters and Neovim's LSP
-- This allows non-LSP tools (like prettier, eslint, stylua) to provide:
--   - Formatting (triggered by <leader>gf or on save)
--   - Diagnostics (shown as LSP warnings/errors)
--   - Code actions (quick fixes)
--
-- FULLSTACK FORMATTERS:
-- ---------------------
-- Frontend (JS/TS/Angular):
--   - prettier: Formats JS, TS, HTML, CSS, JSON, etc.
--   - eslint: Linting and code actions for JS/TS
--
-- Backend (Java/Spring Boot):
--   - google_java_format: Google's opinionated Java formatter
--
-- Lua (Neovim config):
--   - stylua: Lua formatter
--
-- ============================================================================

-- https://stackoverflow.com/questions/78108133/issue-with-none-ls-configuration-error-with-eslint-d
-- solution to eslint_d not working. Requires dependency none-ls-extras.nvim
return {
	"nvimtools/none-ls.nvim",
	event = "BufReadPre",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				-- ============================================================
				-- LUA
				-- ============================================================
				null_ls.builtins.formatting.stylua,

				-- ============================================================
				-- JAVASCRIPT / TYPESCRIPT / ANGULAR / HTML / CSS
				-- ============================================================
				null_ls.builtins.formatting.prettier,

				-- ============================================================
				-- JAVA / SPRING BOOT
				-- ============================================================
				-- Google Java Format - opinionated formatter used by many projects
				-- Install via: :MasonInstall google-java-format
				null_ls.builtins.formatting.google_java_format,
			},
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
