return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      -- REQUIRED
      harpoon:setup()
      -- REQUIRED

      vim.keymap.set("n", "öl", function() harpoon:list():add() end)
      vim.keymap.set("n", "öm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

      vim.keymap.set("n", "öa", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "ös", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "öd", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "öf", function() harpoon:list():select(4) end)
      vim.keymap.set("n", "ög", function() harpoon:list():select(5) end)

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "öp", function() harpoon:list():prev() end)
      vim.keymap.set("n", "ön", function() harpoon:list():next() end)
    end,
  },
}
