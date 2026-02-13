-- Configure neo-tree to show hidden files and respect .gitignore
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
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
