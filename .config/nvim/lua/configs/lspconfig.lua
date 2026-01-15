local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- Global diagnostic keymaps
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- Define all servers to be managed by mason-lspconfig
lspconfig.servers = {
   -- Custom configured servers
   "lua_ls",
   "gopls",
   "ts_ls",
   "eslint",
   "yamlls",
   "helm_ls",
   "terraformls",
   "dockerls",
   "clojure_lsp",
   "prismals",

   -- Default configured servers
   "html",
   "cssls",
   "clangd",
   "pyright",
   "bashls",
   "awk_ls"
}

-- Unified LSP keybindings for all LSP servers
vim.api.nvim_create_autocmd("LspAttach", {
   group = vim.api.nvim_create_augroup("UserLspConfig", {}),
   callback = function(ev)
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

      local opts = { buffer = ev.buf }
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
      vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set("n", "<leader>wl", function()
         print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
      vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<leader>f", function()
         vim.lsp.buf.format { async = true }
      end, opts)
   end,
})

-- Setup servers with custom configurations

-- Lua LSP
lspconfig.lua_ls.setup {
   on_attach = on_attach,
   on_init = on_init,
   capabilities = capabilities,
   settings = {
      Lua = {
         diagnostics = {
            enable = false, -- Disable all diagnostics from lua_ls
         },
         workspace = {
            library = {
               vim.fn.expand "$VIMRUNTIME/lua",
               vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
               vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
               vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
               "${3rd}/love2d/library",
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
         },
      },
   },
}

-- Go LSP
lspconfig.gopls.setup {
   on_attach = function(client, bufnr)
      -- Explicitly disable formatting from gopls as we're using external formatters
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      on_attach(client, bufnr)
   end,
   on_init = on_init,
   capabilities = capabilities,
   cmd = { "gopls" },
   filetypes = { "go", "gomod", "gotmpl", "gowork" },
   root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
   settings = {
      gopls = {
         analyses = { unusedparams = true },
         completeUnimported = true,
         usePlaceholders = true,
         staticcheck = true,
      },
   },
}

-- TypeScript LSP
lspconfig.ts_ls.setup {
   on_attach = on_attach,
   on_init = on_init,
   capabilities = capabilities,
}

-- ESLint
lspconfig.eslint.setup {
   on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = true
      on_attach(client, bufnr)

      -- Run ESLint fix on save
      vim.api.nvim_create_autocmd("BufWritePre", {
         buffer = bufnr,
         command = "EslintFixAll",
      })
   end,
   on_init = on_init,
   capabilities = capabilities,
   settings = {
      workingDirectory = { mode = "auto" },
      format = { enable = true },
   },
}

-- YAML LSP with Kubernetes schemas
lspconfig.yamlls.setup {
   on_attach = on_attach,
   capabilities = capabilities,
   settings = {
      yaml = {
         validate = true,
         completion = true,
         hover = true,
         schemas = {
            kubernetes = {"*.yaml", "*.yml", "!kustomization*"},
            ["https://json.schemastore.org/kustomization.json"] = "kustomization.y*ml",
         },
         schemaDownload = {
            enable = true,
            url_map = {
               kubernetes = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.4-standalone-strict",
            }
         },
      }
   }
}

-- Helm LSP
lspconfig.helm_ls.setup {
   on_attach = on_attach,
   capabilities = capabilities,
   filetypes = { "helm" },
   settings = {
      helm = {
         enableLibraryKubernetes = true,
         lint = { enable = true }
      }
   }
}

-- Simple LSP setups
local simple_servers = {
   "terraformls", "dockerls", "clojure_lsp", "prismals", "html", "cssls",
   "clangd", "pyright", "bashls", "awk_ls"
}

for _, server in ipairs(simple_servers) do
   if not lspconfig[server].setup_called then
      lspconfig[server].setup {
         on_attach = on_attach,
         on_init = on_init,
         capabilities = capabilities,
      }
   end
end
