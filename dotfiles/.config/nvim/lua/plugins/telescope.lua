-- Paths to include even if gitignored (relative to project root)
local whitelist = {
  -- ".env.example",
  -- "vendor/important-lib",
}

local function build_find_command()
  if #whitelist == 0 then
    return { "rg", "--files", "--hidden", "--glob", "!.git" }
  end

  -- Combine: normal rg search + explicit find for whitelisted paths
  local whitelist_finds = {}
  for _, path in ipairs(whitelist) do
    table.insert(whitelist_finds, string.format("find %q -type f 2>/dev/null", path))
  end

  local cmd = string.format(
    "{ rg --files --hidden --glob '!.git' 2>/dev/null; %s; } | sort -u",
    table.concat(whitelist_finds, "; ")
  )
  return { "bash", "-c", cmd }
end

return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      pickers = {
        find_files = {
          hidden = true,
          find_command = build_find_command(),
        },
      },
    },
  },
}
