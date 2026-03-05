-- ============================================================================
-- LSP CONFIGURATION - FULLSTACK DEVELOPMENT
-- ============================================================================
--
-- This config supports a fullstack development workflow:
--
-- FRONTEND (via mason-lspconfig):
--   - ts_ls: TypeScript/JavaScript language server
--   - angularls: Angular template support
--   - eslint: JavaScript/TypeScript linting
--   - html, cssls, tailwindcss, emmet_ls: Web development
--
-- BACKEND (via Mason, configured in java.lua):
--   - jdtls: Java language server (Spring Boot)
--   - java-debug-adapter: Debugging support
--   - java-test: JUnit test runner
--   - google-java-format: Code formatting
--
-- ============================================================================
-- MASON INSTALLATION COMMANDS
-- ============================================================================
--
-- After installing this config, run these commands in Neovim:
--
-- For Java/Spring Boot (run manually, handled by java.lua):
--   :MasonInstall jdtls java-debug-adapter java-test google-java-format
--
-- For additional frontend tools (optional):
--   :MasonInstall js-debug-adapter (for debugging JS/TS)
--
-- ============================================================================

return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		event = "BufReadPre",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				-- ============================================================
				-- FRONTEND LSP SERVERS
				-- ============================================================
				-- These are auto-installed by mason-lspconfig
				-- Java (jdtls) is handled separately by nvim-jdtls
				ensure_installed = {
					-- JavaScript / TypeScript
					"eslint",
					"ts_ls",

					-- Angular
					"angularls",

					-- HTML / CSS
					"html",
					"cssls",
					"cssmodules_ls",
					"css_variables",
					"tailwindcss",
					"emmet_ls",

					-- Other web
					"astro",
					"jsonls",
					"dockerls",

					-- Lua (for Neovim config)
					"lua_ls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			-- Diagnostic keymaps
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {})
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {})
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})

			-- LSP keymaps
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

			-- Get capabilities from cmp_nvim_lsp
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Global LSP config (applies to all servers)
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- Angular LSP config
			vim.lsp.config("angularls", {
				cmd = {
					"angular-language-server",
					"--ngProbeLocations",
					vim.fn.stdpath("data") .. "/mason/packages/angular-language-server/lib/node_modules",
					"--tsProbeLocations",
					vim.fn.stdpath("data") .. "/mason/packages/typescript-language-server",
					"--stdio",
				},
				filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
				root_markers = { "angular.json", "package.json" },
			})

			-- HTML config
			vim.lsp.config("html", {
				filetypes = { "html", "templ" },
				init_options = {
					configurationSection = { "html", "css", "javascript" },
					embeddedLanguages = {
						css = true,
						javascript = true,
					},
					provideFormatter = true,
				},
			})

			-- CSS config
			vim.lsp.config("cssls", {
				settings = {
					css = {
						validate = true,
						lint = {
							unknownAtRules = "ignore",
						},
					},
					scss = {
						validate = true,
						lint = {
							unknownAtRules = "ignore",
						},
					},
				},
			})

			-- Emmet config
			vim.lsp.config("emmet_ls", {
				filetypes = {
					"css",
					"eruby",
					"html",
					"javascript",
					"javascriptreact",
					"less",
					"sass",
					"scss",
					"svelte",
					"pug",
					"typescriptreact",
					"vue",
				},
			})

			-- ESLint config
			vim.lsp.config("eslint", {
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "css" },
				root_markers = { ".eslintrc", ".eslintrc.json", ".eslintrc.js", "eslint.config.js" },
			})

			-- Enable all LSP servers
			vim.lsp.enable({
				"angularls",
				"astro",
				"cssls",
				"cssmodules_ls",
				"css_variables",
				"dockerls",
				"emmet_ls",
				"eslint",
				"html",
				"jsonls",
				"lua_ls",
				"tailwindcss",
				"ts_ls",
			})
		end,
	},

	-- Autocompletion plugins
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			-- Load friendly-snippets
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
}
