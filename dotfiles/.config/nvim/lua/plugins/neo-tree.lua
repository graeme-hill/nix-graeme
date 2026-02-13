-- Configure neo-tree to show hidden files and respect .gitignore
return {
  -- Disable other file explorers that might conflict
  { "nvim-mini/mini.files", enabled = false },

  -- Configure snacks.nvim: disable explorer, configure picker to show hidden files
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = false },
      picker = {
        sources = {
          files = {
            hidden = true, -- Show hidden files (dotfiles)
          },
        },
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        hijack_netrw_behavior = "open_current", -- neo-tree handles directory arguments
        filtered_items = {
          visible = true, -- Show hidden files by default
          hide_dotfiles = false, -- Don't hide dotfiles
          hide_gitignored = true, -- Still respect .gitignore
          hide_hidden = false, -- Don't hide files with hidden attribute (Windows)
          hide_by_name = {
            ".git",
            ".DS_Store",
          },
          never_show = {
            ".git",
          },
        },
      },
    },
  },
}
