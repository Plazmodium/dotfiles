return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
	keys = {
		{ "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
		{ "<leader>dC", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
		{ "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History" },
		{ "<leader>dH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview Branch History" },
	},
	config = function()
		local actions = require("diffview.actions")

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
					{ "n", "<leader>co", actions.conflict_choose("ours"), { desc = "Choose Ours" } },
					{ "n", "<leader>ct", actions.conflict_choose("theirs"), { desc = "Choose Theirs" } },
					{ "n", "<leader>cb", actions.conflict_choose("base"), { desc = "Choose Base" } },
					{ "n", "<leader>ca", actions.conflict_choose("all"), { desc = "Choose All" } },
					{ "n", "<leader>cB", actions.conflict_choose_all("base"), { desc = "Choose Base (File)" } },
					{ "n", "]x", "<cmd>DiffviewNextConflict<cr>", { desc = "Next Conflict" } },
					{ "n", "[x", "<cmd>DiffviewPrevConflict<cr>", { desc = "Prev Conflict" } },
				},
			},
		})
	end,
}
