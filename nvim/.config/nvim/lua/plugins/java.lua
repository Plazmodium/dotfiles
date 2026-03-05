-- ============================================================================
-- SPRING BOOT / JAVA DEVELOPMENT SETUP
-- ============================================================================
--
-- WHY nvim-jdtls INSTEAD OF lspconfig?
-- ------------------------------------
-- Unlike other languages, Java requires special handling. The nvim-jdtls plugin
-- provides features that lspconfig cannot:
--   - Proper project root detection (Maven/Gradle)
--   - Debug adapter integration (DAP)
--   - Test runner integration (JUnit)
--   - Code actions: extract variable/method/constant, organize imports
--   - Hot code replace during debugging
--
-- WHAT IS JDTLS?
-- --------------
-- JDTLS (Java Development Tools Language Server) is Eclipse's Java language
-- server. It powers VS Code's Java extension and provides:
--   - IntelliSense (completions, hover, signatures)
--   - Go to definition, find references
--   - Refactoring (rename, extract, inline)
--   - Diagnostics (errors, warnings)
--   - Code actions (quick fixes, source actions)
--
-- SPRING BOOT AWARENESS
-- ---------------------
-- JDTLS understands Spring Boot annotations (@RestController, @Autowired, etc.)
-- and provides intelligent completions for:
--   - Spring annotations and their attributes
--   - Bean injection candidates
--   - Configuration properties
--   - Test utilities (MockMvc, etc.)
--
-- PREREQUISITES
-- -------------
-- 1. Java 17+ installed (Spring Boot 3.x requires Java 17)
-- 2. JAVA_HOME environment variable set
-- 3. Run these Mason commands after installing this plugin:
--      :MasonInstall jdtls
--      :MasonInstall java-debug-adapter
--      :MasonInstall java-test
--
-- RECOMMENDED: Use SDKMAN to manage Java versions
--   curl -s "https://get.sdkman.io" | bash
--   sdk install java 21.0.2-tem
--
-- ============================================================================

return {
	"mfussenegger/nvim-jdtls",
	ft = "java", -- Only load when opening Java files
	dependencies = {
		"mfussenegger/nvim-dap", -- Debug Adapter Protocol client
	},
	config = function()
		local jdtls = require("jdtls")

		-- Helper function to check if Mason package is installed
		local function get_mason_package_path(package_name)
			local mason_registry = require("mason-registry")
			if mason_registry.is_installed(package_name) then
				return mason_registry.get_package(package_name):get_install_path()
			end
			return nil
		end

		-- ====================================================================
		-- PATH CONFIGURATION
		-- ====================================================================
		-- Mason installs tools to: ~/.local/share/nvim/mason/packages/

		local jdtls_path = get_mason_package_path("jdtls")
		if not jdtls_path then
			vim.notify("jdtls not installed. Run :MasonInstall jdtls", vim.log.levels.WARN)
			return
		end

		-- The launcher JAR bootstraps the language server
		local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

		-- OS-specific configuration directory
		-- JDTLS ships with configs for each OS
		local os_config
		if vim.fn.has("mac") == 1 then
			os_config = "config_mac"
		elseif vim.fn.has("unix") == 1 then
			os_config = "config_linux"
		else
			os_config = "config_win"
		end

		-- ====================================================================
		-- WORKSPACE CONFIGURATION
		-- ====================================================================
		-- JDTLS needs a workspace directory for each project to store:
		--   - Compiled class files
		--   - Index data for fast navigation
		--   - Project-specific settings
		--
		-- Each project gets its own workspace to avoid conflicts

		local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
		local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

		-- ====================================================================
		-- DEBUG & TEST BUNDLES
		-- ====================================================================
		-- These JAR files extend JDTLS with debugging and test running capabilities
		-- They're loaded as "bundles" that plug into the language server

		local bundles = {}

		-- Java Debug Adapter - enables breakpoints, step debugging, variable inspection
		local java_debug_path = get_mason_package_path("java-debug-adapter")
		if java_debug_path then
			local debug_jar = vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
			if debug_jar ~= "" then
				table.insert(bundles, debug_jar)
			end
		end

		-- Java Test Runner - enables running JUnit tests from Neovim
		local java_test_path = get_mason_package_path("java-test")
		if java_test_path then
			local test_jars = vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", true), "\n")
			for _, jar in ipairs(test_jars) do
				if jar ~= "" then
					table.insert(bundles, jar)
				end
			end
		end

		-- ====================================================================
		-- JDTLS CONFIGURATION
		-- ====================================================================

		local config = {
			-- Command to start JDTLS
			-- These JVM arguments are recommended by the JDTLS maintainers
			cmd = {
				"java",
				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",
				"-Xmx1g", -- Max heap size (increase for large projects)
				"--add-modules=ALL-SYSTEM",
				"--add-opens", "java.base/java.util=ALL-UNNAMED",
				"--add-opens", "java.base/java.lang=ALL-UNNAMED",
				"-jar", launcher_jar,
				"-configuration", jdtls_path .. "/" .. os_config,
				"-data", workspace_dir,
			},

			-- ================================================================
			-- ROOT DIRECTORY DETECTION
			-- ================================================================
			-- JDTLS needs to know the project root to:
			--   - Find build files (pom.xml, build.gradle)
			--   - Resolve dependencies
			--   - Determine source/test directories
			--
			-- It searches upward from the current file for these markers:
			root_dir = require("jdtls.setup").find_root({
				".git",
				"mvnw",       -- Maven wrapper (Spring Boot projects often include this)
				"gradlew",    -- Gradle wrapper
				"pom.xml",    -- Maven build file
				"build.gradle", -- Gradle build file
				"build.gradle.kts", -- Kotlin DSL Gradle
			}),

			-- ================================================================
			-- LANGUAGE SERVER SETTINGS
			-- ================================================================
			settings = {
				java = {
					-- Signature help shows method parameters as you type
					signatureHelp = { enabled = true },

					-- Use fernflower for decompiling .class files (view library source)
					contentProvider = { preferred = "fernflower" },

					-- ========================================================
					-- COMPLETION SETTINGS
					-- ========================================================
					completion = {
						-- Static imports to suggest without qualification
						-- These are common in Spring Boot testing
						favoriteStaticMembers = {
							-- JUnit assertions
							"org.junit.Assert.*",
							"org.junit.jupiter.api.Assertions.*",
							-- Mockito mocking framework
							"org.mockito.Mockito.*",
							"org.mockito.ArgumentMatchers.*",
							-- Spring MVC test utilities
							"org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
							"org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
							"org.springframework.test.web.servlet.result.MockMvcResultHandlers.*",
							-- Hamcrest matchers
							"org.hamcrest.Matchers.*",
							"org.hamcrest.CoreMatchers.*",
						},
						-- Filter out types you rarely want to import
						filteredTypes = {
							"com.sun.*",
							"io.micrometer.shaded.*",
							"java.awt.*",
							"jdk.*",
							"sun.*",
						},
						-- Import all suggestions (not just from current file)
						importOrder = {
							"java",
							"javax",
							"org",
							"com",
						},
					},

					-- ========================================================
					-- IMPORT ORGANIZATION
					-- ========================================================
					sources = {
						organizeImports = {
							-- High threshold = no star imports (import java.util.*)
							-- Explicit imports are cleaner and easier to track
							starThreshold = 9999,
							staticStarThreshold = 9999,
						},
					},

					-- ========================================================
					-- CODE GENERATION
					-- ========================================================
					codeGeneration = {
						-- Template for generated toString() methods
						toString = {
							template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
						},
						-- Use Objects.hash() and Objects.equals() (Java 7+)
						hashCodeEquals = {
							useJava7Objects = true,
						},
						-- Use blocks in generated code
						useBlocks = true,
					},

					-- ========================================================
					-- JAVA RUNTIME CONFIGURATION
					-- ========================================================
					-- Configure which Java versions are available on your system
					-- JDTLS uses this to compile projects with the correct Java version
					--
					-- IMPORTANT: Update these paths to match your system!
					-- Common locations:
					--   macOS (Homebrew): /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home
					--   macOS (SDKMAN):   ~/.sdkman/candidates/java/17.0.9-tem
					--   Linux:            /usr/lib/jvm/java-17-openjdk
					configuration = {
						runtimes = {
							{
								name = "JavaSE-17",
								path = vim.fn.expand("~/.sdkman/candidates/java/17.0.9-tem"),
							},
							{
								name = "JavaSE-21",
								path = vim.fn.expand("~/.sdkman/candidates/java/21.0.2-tem"),
							},
							-- Add more runtimes as needed:
							-- {
							-- 	name = "JavaSE-11",
							-- 	path = "/path/to/java-11",
							-- },
						},
					},

					-- ========================================================
					-- FORMATTING
					-- ========================================================
					-- You can use Eclipse formatter settings or google-java-format via none-ls
					-- format = {
					-- 	settings = {
					-- 		url = "~/.config/nvim/java-formatter.xml",
					-- 	},
					-- },
				},
			},

			-- Load debug/test bundles
			init_options = {
				bundles = bundles,
			},

			-- ================================================================
			-- ON ATTACH CALLBACK
			-- ================================================================
			-- Called when JDTLS connects to a buffer
			-- Set up keymaps and additional features here
			on_attach = function(client, bufnr)
				-- Enable jdtls-specific DAP extensions
				-- hotcodereplace = "auto" means changes are applied while debugging
				jdtls.setup_dap({ hotcodereplace = "auto" })

				-- Configure DAP for main class detection
				-- This enables "Run" and "Debug" code lenses
				pcall(function()
					require("jdtls.dap").setup_dap_main_class_configs()
				end)

				-- ============================================================
				-- JAVA-SPECIFIC KEYMAPS
				-- ============================================================
				-- These only apply to Java buffers

				local opts = { buffer = bufnr, desc = "" }

				-- Organize imports (removes unused, adds missing, sorts)
				opts.desc = "Organize Imports"
				vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, opts)

				-- Extract variable from expression
				opts.desc = "Extract Variable"
				vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, opts)
				vim.keymap.set("v", "<leader>jv", function()
					jdtls.extract_variable(true)
				end, opts)

				-- Extract constant from expression
				opts.desc = "Extract Constant"
				vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, opts)
				vim.keymap.set("v", "<leader>jc", function()
					jdtls.extract_constant(true)
				end, opts)

				-- Extract method from selected code
				opts.desc = "Extract Method"
				vim.keymap.set("v", "<leader>jm", function()
					jdtls.extract_method(true)
				end, opts)

				-- ============================================================
				-- TEST RUNNER KEYMAPS
				-- ============================================================
				-- Run tests directly from Neovim (requires java-test bundle)

				-- Run all tests in current class
				opts.desc = "Test Class"
				vim.keymap.set("n", "<leader>jtc", jdtls.test_class, opts)

				-- Run test method under cursor
				opts.desc = "Test Nearest Method"
				vim.keymap.set("n", "<leader>jtm", jdtls.test_nearest_method, opts)

				-- Pick a test to run (shows all tests in file)
				opts.desc = "Pick Test"
				vim.keymap.set("n", "<leader>jtp", function()
					require("jdtls.dap").pick_test()
				end, opts)
			end,

			-- Use nvim-cmp capabilities for better completions
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		}

		-- ====================================================================
		-- AUTO-START JDTLS
		-- ====================================================================
		-- Start JDTLS when opening any Java file
		-- Uses start_or_attach to reuse existing server for same project

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = function()
				jdtls.start_or_attach(config)
			end,
		})
	end,
}

-- ============================================================================
-- QUICK REFERENCE: JAVA KEYMAPS
-- ============================================================================
--
-- REFACTORING (prefix: <leader>j)
-- --------------------------------
-- <leader>jo  - Organize imports
-- <leader>jv  - Extract variable (normal/visual)
-- <leader>jc  - Extract constant (normal/visual)
-- <leader>jm  - Extract method (visual)
--
-- TESTING (prefix: <leader>jt)
-- ----------------------------
-- <leader>jtc - Run all tests in class
-- <leader>jtm - Run test method under cursor
-- <leader>jtp - Pick test to run
--
-- STANDARD LSP (work for all languages)
-- -------------------------------------
-- K          - Hover documentation
-- gd         - Go to definition
-- <leader>ca - Code actions
-- <leader>e  - Show diagnostics
-- [d / ]d    - Previous/next diagnostic
-- <leader>gf - Format file
--
-- DEBUGGING (see dap.lua)
-- -----------------------
-- <leader>db - Toggle breakpoint
-- <leader>dc - Continue/start debugging
-- <leader>di - Step into
-- <leader>do - Step over
-- <leader>dO - Step out
--
-- ============================================================================
