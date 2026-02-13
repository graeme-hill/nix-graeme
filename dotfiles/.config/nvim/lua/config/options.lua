-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable auto-format on save by default
-- Enable per-project by creating .nvim.lua with: vim.g.autoformat = true
vim.g.autoformat = false

-- Allow project-local .nvim.lua config files
vim.opt.exrc = true

-- Disable inlay hints by default (toggle with <leader>uh)
vim.lsp.inlay_hint.enable(false)

-- Disable LazyVim's auto root detection - always use the directory nvim was started in
vim.g.root_spec = { "cwd" }

-- Keep cursor centered vertically
vim.opt.scrolloff = 999
