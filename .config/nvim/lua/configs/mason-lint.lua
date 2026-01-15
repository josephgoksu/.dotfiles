--[[
  Mason-Lint Integration
  This file configures mason.nvim to automatically install linters.
  It builds a list of linters from lint.linters_by_ft, excluding those in ignore_install.
--]]

local lint = package.loaded["lint"]

-- Linters to exclude from automatic installation
local ignore_install = {
   "kubeconform",
   "kubescape",
   "helm"
}

-- Helper function to find if value is in table
local function table_contains(table, value)
   for _, v in ipairs(table) do
      if v == value then
         return true
      end
   end
   return false
end

-- Build a list of linters to install, excluding those in ignore_install
local all_linters = {}
for _, v in pairs(lint.linters_by_ft) do
   for _, linter in ipairs(v) do
      if not table_contains(ignore_install, linter) and not table_contains(all_linters, linter) then
         table.insert(all_linters, linter)
      end
   end
end

-- Configure mason-nvim-lint
require("mason-nvim-lint").setup {
   ensure_installed = all_linters,
   automatic_installation = false,
}
