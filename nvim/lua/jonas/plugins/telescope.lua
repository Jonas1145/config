return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
    "nvim-telescope/telescope-file-browser.nvim", -- File browser extension
    "nvim-telescope/telescope-ui-select.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    -- local trouble = require("trouble")
    -- local trouble_telescope = require("trouble.sources.telescope")

    -- or create your custom action
    -- local custom_actions = transform_mod({
    --   open_trouble_qflist = function(prompt_bufnr)
    --     trouble.toggle("quickfix")
    --   end,
    -- })

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "dist/",
          "build/",
        },
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
        },
        -- Better sorting
        -- Show previews for files
        preview = {
          filesize_limit = 0.5, -- MB
          timeout = 150,        -- ms
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next,     -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<CR>"] = function(bufnr)
              actions.select_default(bufnr)
              pcall(require('nvim-tree.api').tree.close)
            end,
            ["<C-u>"] = false, -- Clear previous mapping to use for preview scroll
            ["<C-d>"] = false,
            ["<C-b>"] = actions.preview_scrolling_up,
            ["<C-f>"] = actions.preview_scrolling_down,
            ["<C-space>"] = actions.toggle_selection,
            -- ["<C-t>"] = trouble_telescope.open,
          },
          n = {
            ["<CR>"] = function(bufnr)
              actions.select_default(bufnr)
              pcall(require('nvim-tree.api').tree.close)
            end,
            ["q"] = actions.close,
          },
        },
      },
      extensions = {
        file_browser = {
          -- Theme
          theme = "dropdown",
          -- Disable netrw and use telescope-file-browser
          hijack_netrw = true,
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("file_browser")
    telescope.load_extension("ui-select")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<C-p>", builtin.git_files, { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Find string under cursor in cwd" })

    keymap.set("n", "<leader>fb", "<cmd>Telescope file_browser<cr>", { desc = "Browse files" })
    keymap.set("n", "<leader>ff", function()
      builtin.find_files({
        hidden = true,
        no_ignore = true, -- This will show gitignored files
        find_command = {
          "rg",
          "--files",
          "--hidden",
          "--no-ignore",
        },
      })
    end, { desc = "Find all files" })
  end,
}
