--[[
  Linting configuration
  This file configures nvim-lint with language-specific linters.
  It also defines custom linter configurations for specialized tools.
--]]

local lint = require "lint"

-- Configure which linters to use for each file type
lint.linters_by_ft = {
   lua = { "luacheck" },
   yaml = { "kubeconform", "kubescape" },
   helm = { "helm" },
   dockerfile = { "hadolint" },
}

-- Custom linter configurations
lint.linters.luacheck.args = {
   "--globals", "love", "vim",
   "--formatter", "plain",
   "--codes", "--ranges", "-"
}

-- Kubernetes linters
lint.linters.kubescape = {
   cmd = "kubescape",
   args = {
      "scan",
      "--format", "json",
      "--file", "$FILENAME"
   },
   stream = "stdout",
   ignore_exitcode = true,
   parser = require("lint.parser").from_errorformat(
      [[%f:%l:%c: %m]],
      { source = "kubescape" }
   ),
}

lint.linters.kubeconform = {
   cmd = "kubeconform",
   args = {
      "-strict",
      "-summary",
      "-output", "pretty",
      "$FILENAME"
   },
   stream = "stdout",
   ignore_exitcode = true,
   parser = require("lint.parser").from_errorformat(
      [[%f:%l:%c %m]],
      { source = "kubeconform" }
   ),
}

-- Run linters automatically
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
   pattern = "*.yaml",
   callback = function()
      -- Wait for formatter to finish
      vim.defer_fn(lint.try_lint, 500)
   end,
})
