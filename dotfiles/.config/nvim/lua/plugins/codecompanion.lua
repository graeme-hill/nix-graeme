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
    config = function(_, opts)
      require("codecompanion").setup(opts)

      -- Custom "implement this" command
      vim.keymap.set("v", "<leader>ax", function()
        vim.cmd("'<,'>CodeCompanion #buffer implement this")
      end, { desc = "Implement selection" })

      vim.keymap.set("n", "<leader>ax", function()
        local line = vim.fn.line(".")
        local col = vim.fn.col(".")
        local current_line = vim.fn.getline(".")
        local prompt = string.format(
          "#buffer implement the code at line %d (cursor at column %d). The line content is: %s",
          line, col, current_line
        )
        vim.cmd("CodeCompanion " .. prompt)
      end, { desc = "Implement at cursor" })
    end,
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = "n", desc = "Code Companion Actions" },
      { "<leader>aa", ":'<,'>CodeCompanionActions<cr>", mode = "v", desc = "Code Companion Actions" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle Chat" },
      { "<leader>ai", ":CodeCompanion #buffer ", mode = "n", desc = "Inline Assistant (with buffer)" },
      { "<leader>ai", ":'<,'>CodeCompanion ", mode = "v", desc = "Inline Assistant" },
      { "<leader>ap", ":'<,'>CodeCompanionChat Add<cr>", mode = "v", desc = "Add Selection to Chat" },
      { "<leader>ax", desc = "Implement this" },
    },
  },
}
