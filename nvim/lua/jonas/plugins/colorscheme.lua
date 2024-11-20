return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      -- Store the default TokyoNight configuration
      require("tokyonight").setup({
        transparent = false,
        styles = {
          sidebars = "dark",
          floats = "dark",
        },
      })

      -- Create a command to switch to black version
      local function set_black_theme()
        local bg = "#000000" -- Pure black background
        local bg_dark = "#000000"
        local bg_highlight = "#1a1a1a"
        local bg_search = "#2a2a2a"
        local bg_visual = "#202020"
        local fg = "#cdd6f4"
        local fg_dark = "#bac2de"
        local fg_gutter = "#45475a"
        local border = "#313244"

        require("tokyonight").setup({
          transparent = false,
          styles = {
            sidebars = "dark",
            floats = "dark",
          },
          on_colors = function(colors)
            colors.bg = bg
            colors.bg_dark = bg_dark
            colors.bg_float = bg_dark
            colors.bg_highlight = bg_highlight
            colors.bg_popup = bg_dark
            colors.bg_search = bg_search
            colors.bg_sidebar = bg_dark
            colors.bg_statusline = bg_dark
            colors.bg_visual = bg_visual
            colors.border = border
            colors.fg = fg
            colors.fg_dark = fg_dark
            colors.fg_float = fg
            colors.fg_gutter = fg_gutter
            colors.fg_sidebar = fg_dark
          end,
        })
        vim.cmd([[colorscheme tokyonight]])
      end

      -- Create commands to switch between themes
      vim.api.nvim_create_user_command('TokyoNightBlack', function()
        set_black_theme()
      end, {})

      vim.api.nvim_create_user_command('TokyoNightDefault', function()
        require("tokyonight").setup({
          transparent = false,
          styles = {
            sidebars = "dark",
            floats = "dark",
          },
        })
        vim.cmd([[colorscheme tokyonight]])
      end, {})

      -- Optional: Set up keybindings
      vim.keymap.set('n', '<leader>tb', ':TokyoNightBlack<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>td', ':TokyoNightDefault<CR>', { noremap = true, silent = true })
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
     config = function()
      require("gruvbox").setup({
        -- Add any Gruvbox-specific configuration here
      })
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        -- Add any Rose Pine-specific configuration here
      })
    end,
  },
  {
    "sainnhe/everforest",
    priority = 1000,
    config = function()
      vim.g.everforest_background = 'soft'
      vim.g.everforest_better_performance = 1
    end,
  },
}
