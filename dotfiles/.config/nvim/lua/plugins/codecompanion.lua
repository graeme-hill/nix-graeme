return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "VeryLazy",
    opts = {
      strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
        cmd = {
          adapter = "anthropic",
        },
      },
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            schema = {
              model = {
                default = "claude-sonnet-4-20250514",
              },
            },
          })
        end,
      },
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = "n", desc = "Code Companion Actions" },
      { "<leader>aa", ":'<,'>CodeCompanionActions<cr>", mode = "v", desc = "Code Companion Actions" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle Chat" },
      { "<leader>ai", ":CodeCompanion #buffer ", mode = "n", desc = "Inline Assistant (with buffer)" },
      { "<leader>ai", ":'<,'>CodeCompanion ", mode = "v", desc = "Inline Assistant" },
      { "<leader>ap", ":'<,'>CodeCompanionChat Add<cr>", mode = "v", desc = "Add Selection to Chat" },
    },
  },
}
