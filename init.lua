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

-- In terminal mode, let <C-Esc> jump to normal mode
vim.api.nvim_set_keymap('t', '<Esc><Esc><Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

-- Reload function for editing lua configs
function _G.ReloadConfig()
  for name,_ in pairs(package.loaded) do
    if name:match('^user') then      -- replace "user" with your namespace
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
end

vim.api.nvim_set_keymap(
  'n', '<Leader>rv',
  '<Cmd>lua ReloadConfig()<CR>',
  { noremap = true, silent = true }
)
vim.cmd('command! ReloadConfig lua ReloadConfig()')



require("lazy").setup("plugins")

-- Viewing custom files in telescope

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local previewers = require("telescope.previewers").cat

function ViewFilesInTelescope(prompt_title, file_list)
  pickers.new({}, {
    prompt_title = "prompt_title",
    finder = finders.new_table {
      results = file_list,
    },
    previewer = previewers.new({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

function git_diff_files(base_branch)
  base_branch = base_branch or "main"
  local handle = io.popen("git diff --name-only " .. base_branch)
  if not handle then return {} end

  local result = {}
  for line in handle:lines() do
    if #line > 0 then
      table.insert(result, line)
    end
  end
  handle:close()
  return result
end

function changed_files_from(base_branch)
  base_branch = base_branch or "main"
  local files = git_diff_files(base_branch)
  if #files == 0 then
    vim.notify("No changed files found in branch: " .. base_branch, vim.log.levels.INFO)
    return
  end
  ViewFilesInTelescope("Changed Files", files)
end

-- Create user command for changed_files_from
vim.api.nvim_create_user_command('ChangedFilesFromBranch', function(opts)
  changed_files_from(opts.args)
end, {
  nargs = '?', -- Optional argument
  complete = function(ArgLead)
    -- Use git's branch completion
    return vim.fn.getcompletion(ArgLead, 'branch')
  end,
})

-- Show diagnostics in a floating window
vim.keymap.set('n', '<leader>e', function()
  vim.diagnostic.open_float()
end, { noremap = true, silent = true })
