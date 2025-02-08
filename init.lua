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

-- LLM configuration
-- All the config below assumes there is a command available in path called `llm`
-- that receives strings through the standard input and outputs results through
-- the standard output.

function RunCommandOnSelectionDisplayMd(cmd)
  -- Get the visually selected text
  local _, ls, _ = unpack(vim.fn.getpos("'<"))
  local _, le, _ = unpack(vim.fn.getpos("'>"))

  local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
  if #lines == 0 then return end

  ---- Convert to a string and send to command
  local text = table.concat(lines, "\n")

  -- This line already passes the text as stdin
  local output = vim.fn.systemlist(cmd, text)

  -- Determine window dimensions
  local width = vim.api.nvim_win_get_width(0)
  local height = vim.api.nvim_win_get_height(0)

  -- Open a new buffer: vertical split if the window is wide, otherwise horizontal
  if width > height then
    vim.cmd("vnew") -- Vertical split if the window is wide
  else
    vim.cmd("new")  -- Horizontal split if the window is taller
  end

  -- Get the buffer ID of the new buffer
  local buf = vim.api.nvim_get_current_buf()

  -- Insert the command output into the new buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

  -- Set the buffer as a Markdown file
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].buftype = "nofile"   -- Prevents it from being associated with a file
  vim.bo[buf].bufhidden = "hide"   -- Keeps buffer hidden when closed
  vim.bo[buf].swapfile = false     -- No swap file for this buffer
end

-- Mapping to call it easily in visual mode
vim.api.nvim_set_keymap('v', '<leader>llm',
  [[:<C-u>lua RunCommandOnSelectionDisplayMd("llm")<CR>]], { noremap = true, silent = true })

require("lazy").setup("plugins")
