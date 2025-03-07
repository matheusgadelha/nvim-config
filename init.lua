---@diagnostic disable: undefined-global
--
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

if vim.fn.has("termguicolors") then
  vim.opt.termguicolors = true
end

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Enable true color support
vim.opt.termguicolors = true

-- Prevent terminal clearing on exit
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    vim.opt.guicursor = "a:ver25"
  end,
})

require("lazy").setup("plugins")
