return {
  {
    "yioneko/nvim-vtsls",
    opts = {
      settings = {
        typescript = {
          inlayHints = {
            enumMemberValues = { enabled = false },
            functionLikeReturnTypes = { enabled = false },
            parameterNames = { enabled = "none" },
            parameterTypes = { enabled = false },
            propertyDeclarationTypes = { enabled = false },
            variableTypes = { enabled = false },
          },
        },
        javascript = {
          inlayHints = {
            enumMemberValues = { enabled = false },
            functionLikeReturnTypes = { enabled = false },
            parameterNames = { enabled = "none" },
            parameterTypes = { enabled = false },
            propertyDeclarationTypes = { enabled = false },
            variableTypes = { enabled = false },
          },
        },
      },
    },
  },
}
