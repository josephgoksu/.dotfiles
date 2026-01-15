--[[
  Mason-LSPConfig Integration
  This file configures mason.nvim to automatically install language servers.
  It builds a list of servers from lspconfig.servers, excluding any in ignore_install.
--]]

local lspconfig = package.loaded["lspconfig"]

-- List of servers to ignore during installation (e.g., manually installed servers)
local ignore_install = {}

-- Helper function to check if a value exists in a table
local function table_contains(table, value)
   for _, v in ipairs(table) do
      if v == value then
         return true
      end
   end
   return false
end

-- Build a list of LSP servers to install, excluding any in ignore_install
local all_servers = {}
for _, server in ipairs(lspconfig.servers) do
   if not table_contains(ignore_install, server) then
      table.insert(all_servers, server)
   end
end

-- Configure mason-lspconfig to install the servers
require("mason-lspconfig").setup {
   ensure_installed = all_servers,
   automatic_installation = false,
}
