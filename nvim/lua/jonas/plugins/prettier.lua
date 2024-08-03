return {
    "prettier/vim-prettier",
    run = 'yarn install --frozen-lockfile --production',
    config = function()
        -- Set the Prettier autoformat configuration
        vim.g['prettier#autoformat_config_present'] = 1

        -- Define the auto-command for formatting on save
        vim.cmd([[
            augroup FormatAutogroup
              autocmd!
              autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.svelte,*.yaml,*.html Prettier
            augroup END
        ]])
    end
}

