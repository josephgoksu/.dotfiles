--[[
  Plugin Configuration
  This file defines all plugins and their configuration.
  Plugins are organized by category for better maintainability.
--]]

local formatting = require "configs.formatting"

return {
   ----------------------------------------------------------
   -- Core IDE Features
   ----------------------------------------------------------

   -- Formatting engine
   {
      "stevearc/conform.nvim",
      event = "BufWritePre",
      cmd = { "ConformInfo" },
      opts = {
         formatters_by_ft = formatting.conform.formatters_by_ft,
         formatters = formatting.conform.formatters,
         format_on_save = formatting.conform.format_on_save,
      },
   },

   -- Treesitter for better syntax handling
   {
      "nvim-treesitter/nvim-treesitter",
      event = { "BufReadPost", "BufNewFile" },
      build = ":TSUpdate",
      config = function()
         require "configs.treesitter"
      end,
      dependencies = {
         -- Show code context at the top of the window
         {
            "nvim-treesitter/nvim-treesitter-context",
            event = "BufReadPost",
            opts = {
               enable = true,
               max_lines = 3,
               min_window_height = 0,
               line_numbers = true,
               multiline_threshold = 20,
               trim_scope = "outer",
               mode = "cursor",
               separator = nil,
               zindex = 20,
            },
         },

         -- Syntax aware text-objects
         {
            "nvim-treesitter/nvim-treesitter-textobjects",
            event = "BufReadPost",
         },
      },
   },

   -- LSP configuration
   {
      "neovim/nvim-lspconfig",
      event = { "BufReadPost", "BufNewFile" },
      cmd = { "LspInfo", "LspInstall", "LspUninstall" },
      config = function()
         require("nvchad.configs.lspconfig").defaults()
         require "configs.lspconfig"
      end,
   },

   -- Linting engine
   {
      "mfussenegger/nvim-lint",
      event = { "BufReadPost", "BufWritePost" },
      config = function()
         require "configs.lint"

         -- Auto-lint on read and write
         vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
            callback = function()
               require("lint").try_lint()
            end,
         })
      end,
   },

   ----------------------------------------------------------
   -- Mason Package Management
   ----------------------------------------------------------

   -- Formatter installation
   {
      "zapling/mason-conform.nvim",
      event = "VeryLazy",
      dependencies = { "stevearc/conform.nvim" },
      config = function()
         require "configs.mason-conform"
      end,
   },

   -- LSP server installation
   {
      "williamboman/mason-lspconfig.nvim",
      event = "VeryLazy",
      dependencies = { "neovim/nvim-lspconfig" },
      config = function()
         require "configs.mason-lspconfig"
      end,
   },

   -- Linter installation
   {
      "rshkarin/mason-nvim-lint",
      event = "VeryLazy",
      dependencies = { "mfussenegger/nvim-lint" },
      config = function()
         require "configs.mason-lint"
      end,
   },

   ----------------------------------------------------------
   -- UI Enhancements
   ----------------------------------------------------------

   -- Key binding helper
   {
      "folke/which-key.nvim",
      keys = { "<leader>", "<localleader>", "g", "z", "[", "]" },
      cmd = "WhichKey",
      opts = {
         plugins = {
            spelling = { enabled = true },
            presets = { operators = true, motions = true, text_objects = true },
         },
         window = {
            border = "rounded",
            padding = { 1, 1, 1, 1 },
         },
      },
      init = function()
         vim.o.timeout = true
         vim.o.timeoutlen = 300
      end,
   },

   -- Improved UI components
   {
      "stevearc/dressing.nvim",
      lazy = true,
      init = function()
         ---@diagnostic disable-next-line: duplicate-set-field
         vim.ui.select = function(...)
            require("lazy").load({ plugins = { "dressing.nvim" } })
            return vim.ui.select(...)
         end
         ---@diagnostic disable-next-line: duplicate-set-field
         vim.ui.input = function(...)
            require("lazy").load({ plugins = { "dressing.nvim" } })
            return vim.ui.input(...)
         end
      end,
      opts = function()
         return require "configs.dressing"
      end,
   },

   -- Indentation guides
   {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      event = "BufReadPost",
      opts = {
         indent = {
            char = "│",
            tab_char = "│",
         },
         scope = {
            enabled = true,
            show_start = true,
            show_end = true,
            injected_languages = true,
            highlight = { "Function", "Label" },
            priority = 500,
         },
         exclude = {
            filetypes = {
               "help",
               "dashboard",
               "lazy",
               "neogitstatus",
               "NvimTree",
               "Trouble",
               "text",
            },
         },
      },
   },

   -- Rainbow parentheses
   {
      "HiPhish/rainbow-delimiters.nvim",
      event = "BufReadPost",
      config = function()
         local rainbow_delimiters = require "rainbow-delimiters"

         vim.g.rainbow_delimiters = {
            strategy = {
               [""] = rainbow_delimiters.strategy["global"],
               commonlisp = rainbow_delimiters.strategy["local"],
            },
            query = {
               [""] = "rainbow-delimiters",
               lua = "rainbow-blocks",
            },
            highlight = {
               "RainbowDelimiterRed",
               "RainbowDelimiterYellow",
               "RainbowDelimiterBlue",
               "RainbowDelimiterOrange",
               "RainbowDelimiterGreen",
               "RainbowDelimiterViolet",
               "RainbowDelimiterCyan",
            },
            blacklist = { "c", "cpp" },
         }
      end,
   },

   -- Enhanced diagnostics display
   {
      "folke/trouble.nvim",
      cmd = { "TroubleToggle", "Trouble" },
      opts = {
         position = "bottom",
         height = 10,
         width = 50,
         icons = true,
         mode = "workspace_diagnostics",
         fold_open = "",
         fold_closed = "",
         group = true,
         padding = true,
         cycle_results = true,
         action_keys = {
            close = "q",
            cancel = "<esc>",
            refresh = "r",
            jump = { "<cr>", "<tab>" },
            open_split = { "<c-x>" },
            open_vsplit = { "<c-v>" },
            open_tab = { "<c-t>" },
            jump_close = { "o" },
            toggle_mode = "m",
            switch_severity = "s",
            toggle_preview = "P",
            hover = "K",
            preview = "p",
            close_folds = { "zM", "zm" },
            open_folds = { "zR", "zr" },
            toggle_fold = { "zA", "za" },
            previous = "k",
            next = "j",
         },
         multiline = true,
         indent_lines = true,
         win_config = { border = "single" },
         auto_preview = true,
         use_diagnostic_signs = true,
      },
      keys = {
         { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
         { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
         { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List" },
         { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List" },
      },
   },

   ----------------------------------------------------------
   -- Git Integration
   ----------------------------------------------------------

   {
      "tpope/vim-fugitive",
      cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gwrite", "Gread" },
   },

   ----------------------------------------------------------
   -- Debugging
   ----------------------------------------------------------

   -- Debug Adapter Protocol
   {
      "mfussenegger/nvim-dap",
      cmd = { "DapContinue", "DapToggleBreakpoint" },
      dependencies = {
         -- UI for DAP
         {
            "rcarriga/nvim-dap-ui",
            dependencies = { "nvim-neotest/nvim-nio" },
            config = function()
               local dap = require "dap"
               local dapui = require "dapui"
               dapui.setup()

               -- Auto open/close DAP UI
               dap.listeners.after.event_initialized["dapui_config"] = function()
                  dapui.open()
               end
               dap.listeners.before.event_terminated["dapui_config"] = function()
                  dapui.close()
               end
            end,
         },

         -- Go debugging
         {
            "leoluz/nvim-dap-go",
            ft = "go",
            config = function(_, opts)
               require("dap-go").setup(opts)

               -- Add keymaps
               vim.keymap.set("n", "<F5>", require("dap").continue, { desc = "Continue" })
               vim.keymap.set("n", "<F10>", require("dap").step_over, { desc = "Step Over" })
               vim.keymap.set("n", "<F11>", require("dap").step_into, { desc = "Step Into" })
               vim.keymap.set("n", "<F12>", require("dap").step_out, { desc = "Step Out" })
               vim.keymap.set("n", "<leader>b", require("dap").toggle_breakpoint, { desc = "Toggle Breakpoint" })
            end,
         },
      },
   },

   ----------------------------------------------------------
   -- Language Support
   ----------------------------------------------------------

   -- Clojure
   {
      "Olical/conjure",
      ft = { "clojure", "edn" },
      init = function()
         local conjure = {
            ["conjure#filetype#rust"] = false,
            ["conjure#filetype#python"] = false,
            ["conjure#debug"] = false,
            ["conjure#highlight#enabled"] = true,
            ["conjure#mapping#doc_word"] = "gk",
            ["conjure#extract#tree_sitter#enabled"] = true,
            ["conjure#log#treesitter"] = false,
            ["conjure#client_on_load"] = false,
            ["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false,
            ["conjure#client#clojure#nrepl#refresh#backend"] = "clj-reload",
            ["conjure#log#wrap"] = true,
         }

         for key, value in pairs(conjure) do
            vim.g[key] = value
         end
      end,
   },

   -- Paredit for structured editing
   {
      "julienvincent/nvim-paredit",
      ft = { "clojure", "scheme", "lisp", "fennel" },
      config = function()
         local paredit = require "nvim-paredit"
         paredit.setup {
            keys = {
               ["<localleader>>"] = { paredit.api.slurp_forwards, "Slurp forwards" },
               ["<localleader>("] = { paredit.api.slurp_backwards, "Slurp backwards" },
               ["<localleader><"] = { paredit.api.barf_forwards, "Barf forwards" },
               ["<localleader>)"] = { paredit.api.barf_backwards, "Barf backwards" },
               [">e"] = { paredit.api.drag_element_forwards, "Drag element right" },
               ["<e"] = { paredit.api.drag_element_backwards, "Drag element left" },
               [">f"] = { paredit.api.drag_form_forwards, "Drag form right" },
               ["<f"] = { paredit.api.drag_form_backwards, "Drag form left" },
               ["<localleader>o"] = { paredit.api.raise_form, "Raise form" },
               ["<localleader>O"] = { paredit.api.raise_element, "Raise element" },
               ["E"] = {
                  paredit.api.move_to_next_element,
                  "Jump to next element tail",
                  repeatable = false,
                  mode = { "n", "x", "o", "v" },
               },
               ["B"] = {
                  paredit.api.move_to_prev_element,
                  "Jump to previous element head",
                  repeatable = false,
                  mode = { "n", "x", "o", "v" },
               },
            },
            indent = { enabled = true },
         }
      end,
   },

   -- Kubernetes plugins
   { import = "plugins.kubernetes" },
}
