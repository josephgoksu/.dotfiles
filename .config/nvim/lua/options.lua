--[[
  Neovim Options
  This file extends NvChad's default options and sets custom UI/UX preferences.
  It includes performance optimizations and editor behavior settings.
--]]

-- Load NvChad default options
require "nvchad.options"

-- Performance optimizations
vim.opt.shadafile = "NONE"          -- Don't create shada file on startup
vim.opt.lazyredraw = true           -- Don't redraw screen while executing macros
vim.opt.updatetime = 250            -- Faster completion and highlights
vim.opt.timeoutlen = 400            -- Faster timeout for mappings
vim.opt.ttimeoutlen = 10            -- Faster timeout for key codes
vim.opt.synmaxcol = 240             -- Only highlight up to 240 columns

-- Editor display
vim.opt.number = true               -- Show line numbers
vim.opt.signcolumn = "yes"          -- Always show sign column
vim.opt.cursorline = true           -- Highlight current line
vim.opt.guicursor = "n-v-i-c-r:block" -- Use block cursor in all modes
vim.opt.linebreak = true            -- Break lines at word boundaries
vim.opt.showbreak = "↪ "            -- Show line breaks
vim.opt.shortmess:append "sI"       -- Reduce intro message and search messages

-- Indentation
vim.opt.shiftwidth = 4              -- 4 spaces for indentation
vim.opt.tabstop = 4                 -- 4 spaces for tab
vim.opt.softtabstop = 4             -- 4 spaces when tab is pressed
vim.opt.expandtab = true            -- Use spaces instead of tabs
vim.opt.smartindent = true          -- Smart autoindentation on new line

-- Search
vim.opt.ignorecase = true           -- Ignore case in search patterns
vim.opt.smartcase = true            -- Override ignorecase if search contains uppercase
vim.opt.hlsearch = true             -- Highlight search matches

-- Configure nvim-tree with only non-default settings
require("nvim-tree").setup {
   view = {
      side = "right",
      width = 30,
   },
   renderer = {
      indent_markers = {
         enable = true,
      },
   },
   update_focused_file = {
      enable = true,
      update_root = {
         enable = true,
      },
   },
   git = {
      enable = true,
   },
   filters = {
      enable = true,
      git_ignored = true,
   },
   actions = {
      use_system_clipboard = true,
      open_file = {
         quit_on_open = false,
         resize_window = true,
      },
   },
}

-- Telescope configuration
require("telescope").setup {
   defaults = {
      file_ignore_patterns = { "node_modules", ".git", "build", "dist" },
      path_display = { "truncate" },  -- Shorter paths for better readability
      set_env = { ["COLORTERM"] = "truecolor" },  -- Enable true color
      cache_picker = {
         num_pickers = 5,  -- Remember last 5 pickers
      },
   },
   pickers = {
      find_files = {
         hidden = true,  -- Include hidden files
      },
   },
}
