-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
   theme = "tokyodark",
   hl_override = {
      -- Rainbow colors customized for better TSX visibility
      RainbowDelimiterRed = { fg = "#E06C75" },
      RainbowDelimiterYellow = { fg = "#E5C07B" },
      RainbowDelimiterBlue = { fg = "#61AFEF" },
      RainbowDelimiterOrange = { fg = "#D19A66" },
      RainbowDelimiterGreen = { fg = "#98C379" },
      RainbowDelimiterViolet = { fg = "#C678DD" },
      RainbowDelimiterCyan = { fg = "#56B6C2" },

      -- Indent and scope highlights
      IblIndent = { fg = "#3B4048" },
      IblScope = { fg = "#61AFEF", nocombine = true },

      -- Context highlights
      TreesitterContext = { bg = "#2C313A" },
      TreesitterContextLineNumber = { fg = "#565C64" },
   },
}

return M
