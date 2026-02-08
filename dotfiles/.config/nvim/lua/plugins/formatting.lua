return {
  -- ensure prettier is installed via mason
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "prettier",
      },
    },
  },

  -- configure conform.nvim with prettier for common web filetypes
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
      },
    },
  },
}
