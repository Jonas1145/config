return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim",                   opts = {} },
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import mason_lspconfig plugin
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness


    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration


        opts.desc = "Show LSP type definitions"
        keymap.set('n', 'fd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file


        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "<leader>d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    mason_lspconfig.setup_handlers({
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,
      ["lua_ls"] = function()
        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              -- make the language server recognize "vim" global
              diagnostics = {
                globals = { "vim" },
              },
              completion = {
                callSnippet = "Replace",
              },
            },


          },
        })
      end,
      ["ts_ls"] = function()
        lspconfig["ts_ls"].setup({
          capabilities = capabilities,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        })
      end,
      ["gopls"] = function()
        -- configure golang server (with special settings)
        lspconfig["gopls"].setup({
          capabilities = capabilities,
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
              gofumpt = true,
            },
          },
        })
      end,
    })

    -- Add the autocmd for formatting Go files
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.go", "*.lua" },
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })



    -- Function to remove unused imports
    local function remove_unused_imports(callback)
      vim.lsp.buf.code_action({
        context = { only = { 'source.removeUnusedImports' } },
        apply = true,
        callback = function(err, res)
          if err then
            callback(err)
          elseif not res or #res == 0 then
            callback()
          else
            callback()
          end
        end
      })
    end

    -- Function to add missing imports
    local function add_missing_imports(callback)
      vim.lsp.buf.code_action({
        context = { only = { 'source.addMissingImports' } },
        apply = true,
        callback = function(err, res)
          if err then
            callback(err)
          elseif not res or #res == 0 then
            callback()
          else
            callback()
          end
        end
      })
    end

    -- Function to organize imports
    local function organize_imports(callback)
      vim.lsp.buf.execute_command({
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) }
      })
    end

    -- Main function to execute all import-related actions
    local function execute_import_actions()
      local function execute_next(actions, index)
        if index > #actions then
          vim.notify("Imports organized and formatted successfully", vim.log.levels.INFO)
          return
        end
        local action = actions[index]
        action(function(err)
          if err then
            vim.notify("Error in import organization: " .. tostring(err), vim.log.levels.ERROR)
            return
          end
          execute_next(actions, index + 1)
        end)
      end

      local actions = {
        remove_unused_imports,
        add_missing_imports,
        organize_imports
      }

      execute_next(actions, 1)
    end

    -- Set up the keymapping
    vim.keymap.set("n", "<leader>li", execute_import_actions, { desc = "Organize Imports and Format" })
    vim.keymap.set("n", "<leader>la", add_missing_imports, { desc = "add missing imports" })

    -- Optionally, create a command for this function
    vim.api.nvim_create_user_command('OrganizeImports', execute_import_actions, {})
  end,
}
