return {
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },
  {
    "lalitmee/codecompanion-spinners.nvim",
    dependencies = {
      "olimorris/codecompanion.nvim",
      "j-hui/fidget.nvim",
    },
    opts = {
      spinner_type = "fidget",
    },
  },
}
