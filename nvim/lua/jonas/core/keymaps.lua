vim.g.mapleader = " "

local map = vim.keymap.set


map({ "i", "n" }, "<C-q>", "<cmd>q!<CR>", { desc = "Quit" })
map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
map("n", "<leader>q", ":q!<CR>", { desc = "Quit" })
map("n", "<leader>Q", ":qa!<CR>", { desc = "Quit without saving" })
map("n", "<leader>w", ":w<CR>", { desc = "Save" })
-- increment/decrement numbers
map("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })                   -- split window vertically
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })                 -- split window horizontally
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })                    -- make split windows equal width & height
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })               -- close current split window

map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })                     -- open new tab
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })              -- close current tab
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })                     --  go to next tab
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })                 --  go to previous tab
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
map("n", "<leader>a", "ggVG")
map({ "n", "v" }, "<C-v>", '"+p')
map({ "n", "v" }, "<leader>b", "<C-^>")

-- primagen
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- custom
map({ "n", "v" }, "<leader>y", [["+y]])
map({ "n", "v" }, "<leader>vy", [[V"+y]])
map({ "n", "v" }, "<leader>d", [["_d]])
map({ "n", "v" }, "x", [["_x]])
map("i", "<C-c>", "<Esc>")
map("n", "Q", "<nop>")
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])


vim.g.bg_state = 0
map("n", "<leader>tb", function()
  vim.g.bg_state = (vim.g.bg_state + 1) % 3
  if vim.g.bg_state == 0 then
    vim.cmd("colorscheme " .. vim.g.colors_name) -- Reset to default
  elseif vim.g.bg_state == 1 then
    vim.cmd([[
      highlight Normal guibg=black ctermbg=black
      highlight NormalFloat guibg=black ctermbg=black
      highlight NormalNC guibg=black ctermbg=black
      highlight StatusLine guibg=black ctermbg=black
      highlight StatusLineNC guibg=black ctermbg=black
      highlight TabLine guibg=black ctermbg=black
      highlight TabLineFill guibg=black ctermbg=black
      highlight TabLineSel guibg=black ctermbg=black
    ]])
  else
    vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
  end
end, { desc = "Toggle background (default/black/transparent)" })

map("n", "<C-h>", "<C-w>h")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map('i', '<C-w>', '<C-Right>', { noremap = true, desc = 'Move forward one word' })
map('i', '<C-b>', '<C-Left>', { noremap = true, desc = 'Move backward one word' })

-- Jump to line ends
map('i', '<C-e>', '<End>', { noremap = true, desc = 'Jump to line end' })
map('i', '<C-a>', '<Home>', { noremap = true, desc = 'Jump to line start' })


-- Open floating terminal
local terminal_bufnr = nil

map({ "n", "t" }, "<A-i>", function()
  if terminal_bufnr and vim.api.nvim_buf_is_valid(terminal_bufnr) then
    local wins = vim.api.nvim_list_wins()
    local term_win = nil

    for _, win in ipairs(wins) do
      if vim.api.nvim_win_get_buf(win) == terminal_bufnr then
        term_win = win
        break
      end
    end

    if term_win then
      vim.api.nvim_win_close(term_win, false)
    else
      vim.cmd("split")
      local win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(win, terminal_bufnr)

      vim.api.nvim_win_set_config(win, {
        relative = "editor",
        row = math.floor(vim.o.lines * 0.1),
        col = math.floor(vim.o.columns * 0.1),
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        style = "minimal",
        border = "rounded"
      })
      vim.cmd("startinsert")
    end
  else
    vim.cmd("split term://zsh")
    terminal_bufnr = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()

    vim.api.nvim_win_set_config(win, {
      relative = "editor",
      row = math.floor(vim.o.lines * 0.1),
      col = math.floor(vim.o.columns * 0.1),
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
      style = "minimal",
      border = "rounded"
    })

    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.cmd("startinsert")
  end
end, { desc = "Toggle floating terminal" })
