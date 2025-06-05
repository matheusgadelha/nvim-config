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

-- in your init.lua or a sourced lua module
vim.api.nvim_create_user_command('DiffGitBranch', function(opts)
  local branch = opts.args
  -- get the path of the file in the current window
  local filepath = vim.fn.expand('%')
  if filepath == '' then
    vim.notify('No file in the current buffer!', vim.log.levels.ERROR)
    return
  end

  -- open a new empty vertical split
  vim.cmd('vnew')
  -- read the branch’s version of the same file
  vim.cmd(string.format('read !git show %s:./%s', branch, filepath))
  -- turn on diff mode in both windows
  vim.cmd('windo diffthis')
end, {
  nargs = 1,
  complete = function(ArgLead)
    -- use git’s branch completion
    return vim.fn.getcompletion(ArgLead, 'branch')
  end,
})

-- In terminal mode, let <Esc> jump to normal mode
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

require("lazy").setup("plugins")
