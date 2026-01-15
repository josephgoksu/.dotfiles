--[[
  Kubernetes-related plugins
  This file contains plugins specific to Kubernetes, Helm, and related technologies.
--]]

return {
   -- Snippets for Kubernetes manifests
   {
      "rafamadriz/friendly-snippets",
      config = function()
         require("luasnip.loaders.from_vscode").lazy_load {
            paths = { "./snippets/kubernetes" }
         }
      end
   },

   -- Testing framework with Go adapter
   {
      "nvim-neotest/neotest",
      dependencies = {
         "nvim-neotest/neotest-go",
      },
      config = function()
         require("neotest").setup {
            adapters = {
               require("neotest-go")
            }
         }
      end
   },

   -- Helm support
   {
      "towolf/vim-helm",
      ft = { "helm" },
      init = function()
         -- Set filetype for Helm templates
         vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
            pattern = { "*/templates/*.yaml", "*/templates/*.tpl", "*.yaml.gotmpl" },
            callback = function()
               vim.bo.filetype = "helm"
            end,
         })
      end
   },

   -- JSON Schema support for YAML files
   {
      "b0o/schemastore.nvim",
      lazy = true,
      config = function()
         require("lspconfig").yamlls.setup {
            settings = {
               yaml = {
                  schemaStore = {
                     enable = true,
                     url = "https://www.schemastore.org/api/json/catalog.json",
                  },
               },
            },
         }
      end,
   },
}
