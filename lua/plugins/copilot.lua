return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          gitcommit = true,
          typescript = true,
          javascript = true,
          c = true,
          cpp = true,
          help = true,
          yaml = true,
        }
      })
      vim.keymap.set('n', '<Leader>cp', ":Copilot panel<CR>", { noremap = true, silent = true })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  }
}
