return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>a", desc = "Harpoon Add File" },
			{ "<leader>r", desc = "Harpoon Remove File" },
			{ "<leader>h", desc = "Harpoon Toggle Menu" },
			{ "<leader>j", desc = "Harpoon Go to File 1" },
			{ "<leader>k", desc = "Harpoon Go to File 2" },
			{ "<leader>l", desc = "Harpoon Go to File 3" },
			{ "<leader>;", desc = "Harpoon Go to File 4" },
		},
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()

			vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { noremap = true, silent = true, desc = "Harpoon Add File" })
			vim.keymap.set("n", "<leader>r", function() harpoon:list():remove() end, { noremap = true, silent = true, desc = "Harpoon Remove File" })
			vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { noremap = true, silent = true, desc = "Harpoon Toggle Menu" })
			vim.keymap.set("n", "<leader>j", function() harpoon:list():select(1) end, { noremap = true, silent = true, desc = "Harpoon Go to File 1" })
			vim.keymap.set("n", "<leader>k", function() harpoon:list():select(2) end, { noremap = true, silent = true, desc = "Harpoon Go to File 2" })
			vim.keymap.set("n", "<leader>l", function() harpoon:list():select(3) end, { noremap = true, silent = true, desc = "Harpoon Go to File 3" })
			vim.keymap.set("n", "<leader>;", function() harpoon:list():select(4) end, { noremap = true, silent = true, desc = "Harpoon Go to File 4" })
		end,
	},
}
