return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = { "c", "lua", "javascript", "vimdoc", "python", "cpp", "rust", "html" },
      sync_install = false,
      highlight = {
        enable = true,
        disable = { "qml" }
      },
      indent = { enable = true },
    })
  end
}
