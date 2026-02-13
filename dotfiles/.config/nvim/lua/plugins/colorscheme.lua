return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "dark",
      color_overrides = {
        vscBack = "#000000",
        vscTabCurrent = "#000000",
        vscTabOther = "#000000",
        vscTabOutside = "#000000",
        vscLeftDark = "#000000",
        vscLeftMid = "#000000",
        vscLeftLight = "#000000",
        vscPopupBack = "#000000",
        vscCursorDark = "#000000",
        vscCursorDarkDark = "#000000",
      },
    },
    config = function(_, opts)
      require("vscode").setup(opts)
      require("vscode").load()
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },
}
