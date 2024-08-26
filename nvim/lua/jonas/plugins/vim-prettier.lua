return {
  {
    -- Add vim-prettier with lazy loading
    "prettier/vim-prettier",
    run = "yarn install --frozen-lockfile --production",
    ft = { "javascript", "typescript", "css", "less", "scss", "json", "graphql", "markdown", "typescriptreact", "yaml" },
  }
}
