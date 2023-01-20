-- packer
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'
  
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)


-- setup telescope

-- basic ettings
vim.cmd([[
syntax on
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching brackets.
set ignorecase              " case insensitive matching
set hlsearch                " highlight search results
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
filetype plugin indent on   " allows auto-indenting depending on file type
set tabstop=2               " number of columns occupied by a tab character
set expandtab               " convert tabs to white space
set shiftwidth=2            " width for autoindents
set softtabstop=2           " see multiple spaces as tabstops so <BS> does the right thing
]])


-- setup leader
vim.g.mapleader = " "

-- more familiar window commands under leader
vim.api.nvim_set_keymap("n", "<leader>wv", "<C-w>v", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>ws", "<C-w>s", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>wd", "<C-w>c", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>wh", "<C-w>h", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>wl", "<C-w>l", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>wj", "<C-w>j", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>wk", "<C-w>k", {noremap=true})

-- buffer bindings
vim.api.nvim_set_keymap("n", "<leader>bd", ":bd<CR>" , {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>bD", ":bd!<CR>", {noremap=true})

-- map ,d :e <C-R>=expand("%:p:h") . "/" <CR>


