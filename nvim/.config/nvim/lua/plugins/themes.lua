return {
  --{
  --"catppuccin/nvim",
  --name = "catppuccin",
  --priority = 1000,
  --config = function()
  --vim.cmd.colorscheme "catppuccin"
  --end
  --},
  {
    "tanvirtin/monokai.nvim",
    name = "monokai",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("monokai_pro")

      local function apply_highlights()
        vim.api.nvim_set_hl(0, "OrangeCursor", { fg = "white", bg = "#ff8800" })
        vim.api.nvim_set_hl(0, "Visual", { bg = "#ff8800", fg = "white" })
        vim.api.nvim_set_hl(0, "Search", { bg = "#ff8800", fg = "white" })
        vim.api.nvim_set_hl(0, "IncSearch", { bg = "#ff8800", fg = "white" })
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#402200" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ff8800" })
        vim.api.nvim_set_hl(0, "WildMenu", { bg = "#ff8800", fg = "white" })
      end

      apply_highlights()

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = apply_highlights,
      })
    end,
  },
}
