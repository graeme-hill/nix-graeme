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
        -- Get selection range
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")
        local selection = table.concat(vim.fn.getline(start_line, end_line), "\n")
        local full_buffer = table.concat(vim.fn.getline(1, "$"), "\n")
        local filetype = vim.bo.filetype

        local prompt = string.format(
          [[Complete or fix the selected code. Follow any conventions, patterns, or instructions in the rest of the file.

FULL FILE CONTEXT (%s):
```%s
%s
```

SELECTED CODE TO COMPLETE OR FIX (lines %d-%d):
```%s
%s
```

Complete or fix this selection, following any instructions or patterns from the file context.]],
          filetype, filetype, full_buffer, start_line, end_line, filetype, selection
        )

        require("codecompanion").inline({
          args = prompt,
          mode = "v",
        })
      end, { desc = "Complete or fix selection" })

      vim.keymap.set("n", "<leader>ax", function()
        local line = vim.fn.line(".")
        local current_line = vim.fn.getline(".")
        local full_buffer = table.concat(vim.fn.getline(1, "$"), "\n")
        local filetype = vim.bo.filetype

        local prompt = string.format(
          [[Implement the code at line %d. Follow any conventions, patterns, or instructions in the file.

FULL FILE (%s):
```%s
%s
```

Implement code at line %d, which currently contains: %s]],
          line, filetype, filetype, full_buffer, line, current_line
        )

        require("codecompanion").inline({
          args = prompt,
          mode = "n",
        })
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
