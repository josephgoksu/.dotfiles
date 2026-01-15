--[[
  Treesitter Configuration
  Configures syntax highlighting, indentation, folding, and text objects.
  Performance optimizations included for better handling of large files.
--]]

local options = {
   -- Languages to install parsers for
   ensure_installed = {
      -- Shell languages
      "bash", "fish",

      -- Config languages
      "lua", "luadoc", "vim", "vimdoc", "toml", "yaml", "hcl", "dockerfile",

      -- Documentation/markup
      "markdown", "printf",

      -- Web languages
      "html", "css", "scss", "typescript", "javascript", "json", "jsonc",

      -- Go ecosystem
      "go", "gomod", "gosum", "gotmpl", "gowork",

      -- Other languages
      "python", "helm",
   },

   -- Syntax highlighting
   highlight = {
      enable = true,
      use_languagetree = true,
      additional_vim_regex_highlighting = { "markdown" },

      -- Disable highlighting for very large files
      disable = function(_, buf)
         local max_filesize = 100 * 1024 -- 100 KB
         local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
         if ok and stats and stats.size > max_filesize then
            return true
         end
      end,
   },

   -- Indentation based on treesitter
   indent = {
      enable = true,
   },

   -- Enhanced code folding
   fold = {
      enable = true,
   },

   -- Language aware commenting
   context_commentstring = {
      enable = true,
      enable_autocmd = false,
   },

   -- Incremental selection based on syntax nodes
   incremental_selection = {
      enable = true,
      keymaps = {
         init_selection = "<C-space>",
         node_incremental = "<C-space>",
         scope_incremental = "<C-s>",
         node_decremental = "<C-backspace>",
      },
   },

   -- Treesitter text objects
   textobjects = {
      select = {
         enable = true,
         lookahead = true,
         keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
         },
      },
      move = {
         enable = true,
         set_jumps = true,
         goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
         },
         goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
         },
         goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
         },
         goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
         },
      },
   },
}

require("nvim-treesitter.configs").setup(options)
