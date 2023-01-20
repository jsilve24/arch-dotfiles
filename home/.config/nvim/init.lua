local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}

  if opts then options = vim.tbl_extend('force', options, opts) end

  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- change some defaults

-- # Set global options
opt.autoread = true
opt.expandtab = true                -- spaces instead of tabs
opt.hidden = true                   -- enable background buffers
opt.ignorecase = true               -- ignore case in search
opt.joinspaces = false              -- no double spaces with join
opt.list = true                     -- show some invisible characters
-- opt.mouse = "nv"                    -- Enable mouse in normal and visual modes
opt.number = true                   -- show line numbers
opt.relativenumber = true           -- number relative to current line
opt.scrolloff = 4                   -- lines of context
opt.shiftround = true               -- round indent
opt.shiftwidth = 2                  -- size of indent
opt.sidescrolloff = 8               -- columns of context
opt.smartcase = true                -- do not ignore case with capitals
opt.smartindent = true              -- insert indents automatically
opt.splitbelow = true               -- put new windows below current
opt.splitright = true               -- put new vertical splits to right
-- opt.termguicolors = true            -- truecolor support
opt.wildmode = {'list', 'longest'}  -- command-line completion mode
opt.wrap = true                    -- disable line wrap
opt.background = 'dark'


-- packer bootsrap
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git',
    'clone',
    '--depth', '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  })
end


-- load plugins via packer
require('packer').startup(function(use)
  use "wbthomason/packer.nvim"

  -- ==> Load plugins.
  --
  -- # Load telescope.nvim
  use { "nvim-telescope/telescope.nvim",
    requires = { {"nvim-lua/plenary.nvim"} },
  }

  use({
    "neanias/telescope-lines.nvim",
    requires = "nvim-telescope/telescope.nvim",
  })

  use({
    "jvgrootveld/telescope-zoxide", 
    requires = { 'nvim-lua/popup.nvim' }
  })

  use "EdenEast/nightfox.nvim"

  -- # Load lualine
  use { 'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup({
        options = {
          theme = "duskfox",
        }
      })
    end,
  }

  -- # Load which-key.nvim
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {}
    end
  }

  use {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  -- git integration
  use { 'TimUntersberger/neogit', 
         requires = 'nvim-lua/plenary.nvim' }


  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end, 
    keymaps = {
      insert = "<C-g>s",
      insert_line = "<C-g>S",
      normal = "ys",
      normal_cur = "yss",
      normal_line = "yS",
      normal_cur_line = "ySS",
      visual = "s",
      visual_line = "gS",
      delete = "ds",
      change = "cs",
    }
  })

  use {
	"windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }

  use { 'aymericbeaumet/vim-symlink', requires = { 'moll/vim-bbye' } }


  -- automatically set up your configuration after cloning packer.nvim
  -- put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)


-- # Set colorscheme
cmd[[colorscheme nightfox]]

-- setup leader and start bindings
g.mapleader = ' '

-- # Add global bindings for telescope.nvim
require("telescope").load_extension("lines")
map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<leader>fr", "<cmd>lua require('telescope.builtin').oldfiles()<cr>")
map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
map("n", "<leader><leader>", "<cmd>lua require('telescope.builtin').buffers()<cr>")
map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>")
map("n", "<A-x>", "<cmd>lua require('telescope.builtin').commands()<cr>")
vim.keymap.set("n", "gs", function() require("telescope").extensions.lines.lines() end)

-- Add commands for hop
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('n', 'gw', function() hop.hint_words() end)
vim.keymap.set('n', 'g/', function() hop.hint_patterns() end)
vim.keymap.set('n', 'gj', function() hop.hint_vertical({direction=directions.AFTER_CURSOR}) end)
vim.keymap.set('n', 'gk', function() hop.hint_vertical({direction=directions.BEFORE_CURSOR}) end)
vim.keymap.set('v', 'gw', function() hop.hint_words() end)
vim.keymap.set('v', 'g/', function() hop.hint_patterns() end)
vim.keymap.set('v', 'gj', function() hop.hint_vertical() end)
vim.keymap.set('v', 'gk', function() hop.hint_vertical() end)

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

-- file bindings
map("n", "<leader>fs", "<cmd>w<CR>")
map("n", "<leader>fS", "<cmd>wa<CR>")

-- setup zoxide
local t = require("telescope")
local z_utils = require("telescope._extensions.zoxide.utils")

-- Configure the extension
t.setup({
  extensions = {
    zoxide = {
      prompt_title = "[ Zoxide List ]",

      -- Zoxide list command with score
      list_command = "zoxide query -ls",
      mappings = {
        default = {
          action = function(selection)
            vim.cmd("cd " .. selection.path)
          end,
          after_action = function(selection)
            print("Directory changed to " .. selection.path)
          end
        },
        ["<c-s>"] = { action = z_utils.create_basic_command("split") },
        ["<C-v>"] = { action = z_utils.create_basic_command("vsplit") },
        ["<C-e>"] = { action = z_utils.create_basic_command("edit") },
      --  ["<C-b>"] = {
      --    keepinsert = true,
      --    action = function(selection)
      --      telescope.builtin.file_browser({ cwd = selection.path })
      --    end
      --  },
      --  ["<C-f>"] = {
      --    keepinsert = true,
      --    action = function(selection)
      --      telescope.builtin.find_files({ cwd = selection.path })
      --    end
      --  }
      }
    },
  },
})

-- Load the extension
t.load_extension('zoxide')

-- Add a mapping
vim.keymap.set("n", ",z", t.extensions.zoxide.list)


-- configure git
local neogit = require("neogit")

neogit.setup {
  disable_signs = false,
  disable_hint = false,
  disable_context_highlighting = false,
  disable_commit_confirmation = false,
  -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
  -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
  auto_refresh = true,
  disable_builtin_notifications = false,
  use_magit_keybindings = false,
  -- Change the default way of opening neogit
  kind = "tab",
  -- The time after which an output console is shown for slow running commands
  console_timeout = 2000,
  -- Automatically show console if a command takes more than console_timeout milliseconds
  auto_show_console = true,
  -- Change the default way of opening the commit popup
  commit_popup = {
    kind = "split",
  },
  -- Change the default way of opening popups
  popup = {
    kind = "split",
  },
  -- customize displayed signs
  signs = {
    -- { CLOSED, OPENED }
    section = { ">", "v" },
    item = { ">", "v" },
    hunk = { "", "" },
  },
  integrations = {
    -- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `sindrets/diffview.nvim`.
    -- The diffview integration enables the diff popup, which is a wrapper around `sindrets/diffview.nvim`.
    --
    -- Requires you to have `sindrets/diffview.nvim` installed.
    -- use {
    --   'TimUntersberger/neogit',
    --   requires = {
    --     'nvim-lua/plenary.nvim',
    --     'sindrets/diffview.nvim'
    --   }
    -- }
    --
    diffview = false
  },
  -- Setting any section to `false` will make the section not render at all
  sections = {
    untracked = {
      folded = false
    },
    unstaged = {
      folded = false
    },
    staged = {
      folded = false
    },
    stashes = {
      folded = true
    },
    unpulled = {
      folded = true
    },
    unmerged = {
      folded = false
    },
    recent = {
      folded = true
    },
  },
  -- override/add mappings
  mappings = {
    -- modify status buffer mappings
    status = {
      -- Adds a mapping with "B" as key that does the "BranchPopup" command
      ["B"] = "BranchPopup",
      -- Removes the default mapping of "s"
      -- ["s"] = "",
    }
  }
}

vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>")

-- setup surround
cmd([[
:vmap s <Nop>
:vmap s S
]])
