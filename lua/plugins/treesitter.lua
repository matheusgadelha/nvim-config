return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = {
        "zig",
        "c",
        "lua",
        "javascript",
        "typescript",
        "vimdoc",
        "python",
        "cpp",
        "rust",
        "html",
        "tsx"
      },
      sync_install = false,
      highlight = {
        enable = true,
        disable = { "qml" }
      },
      indent = { enable = true },
    })
  end
}
