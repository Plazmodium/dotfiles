-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.scrolloff = 8 -- Keep 8 lines above/below cursor
vim.opt.undofile = true -- Persistent undo
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Case sensitive if uppercase present

-- Set cursor color and style
vim.opt.termguicolors = true
vim.opt.guicursor =
	"n-v-c:block-OrangeCursor/lCursor-blinkwait175-blinkoff150-blinkon175,i:ver25-OrangeCursor/lCursor-blinkwait175-blinkoff150-blinkon175"

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 0
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client:supports_method("textDocument/formatting") then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf })
				end,
			})
		end
	end,
})
vim.g.mapleader = " "
vim.wo.relativenumber = true

vim.keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>th", ":split | terminal<CR>", { noremap = true, silent = true })
