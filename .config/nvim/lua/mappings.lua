--[[
  Custom key mappings
  These mappings extend or override the default NvChad mappings.
  Focused on productivity and efficient navigation.
--]]

-- Load default NvChad mappings
require "nvchad.mappings"

local map = vim.keymap.set

-- Convenience mappings
map("n", ";", ":", { desc = "Command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Navigate left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Navigate down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Navigate up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Navigate right window" })

-- Window resize with arrows
map("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize window up", silent = true })
map("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize window down", silent = true })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize window left", silent = true })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize window right", silent = true })

-- Stay in visual mode while indenting
map("v", "<", "<gv", { desc = "Indent left and stay in visual mode" })
map("v", ">", ">gv", { desc = "Indent right and stay in visual mode" })

-- Move text up and down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down", silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up", silent = true })

-- Easy save
map("n", "<C-s>", ":w<CR>", { desc = "Save file", silent = true })
map("i", "<C-s>", "<ESC>:w<CR>", { desc = "Save file", silent = true })

-- Easy buffer navigation
map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer", silent = true })
map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer", silent = true })

-- Clear search highlights with ESC
map("n", "<ESC>", ":noh<CR>", { desc = "Clear search highlights", silent = true })

-- Toggle NvimTree
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer", silent = true })

-- LSP keymaps (supplement the defaults)
map("n", "gD", function() vim.lsp.buf.declaration() end, { desc = "Go to declaration" })
map("n", "gd", function() vim.lsp.buf.definition() end, { desc = "Go to definition" })
map("n", "K", function() vim.lsp.buf.hover() end, { desc = "Hover documentation" })
map("n", "<leader>ca", function() vim.lsp.buf.code_action() end, { desc = "Code action" })
map("n", "<leader>rn", function() vim.lsp.buf.rename() end, { desc = "Rename symbol" })
map("n", "<leader>f", function() vim.lsp.buf.format() end, { desc = "Format document" })
