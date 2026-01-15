# My Nvim Configuration

This repository contains my custom configuration for NvChad. It uses the main NvChad repository as a plugin and extends its functionality with a simplified, maintainable structure and performance optimizations.

## Structure

### Core Files

- `init.lua` - Streamlined entry point with module caching for faster startup
- `lua/options.lua` - Performance-optimized Vim options and UI settings
- `lua/mappings.lua` - Productivity-focused key mappings with clear documentation
- `lua/chadrc.lua` - NvChad theme and highlight configurations

### Plugin Management

- `lua/plugins/init.lua` - Organized plugin declarations with optimized lazy-loading
- `lua/configs/lazy.lua` - Optimized lazy plugin manager settings

### LSP Configuration

- `lua/configs/lspconfig.lua` - Consolidated Language Server Protocol configurations
- `lua/configs/mason-lspconfig.lua` - Automatic LSP server installation management

### Code Quality Tools

- `lua/configs/formatting.lua` - Centralized formatting configurations
- `lua/configs/lint.lua` - Organized linting configurations with clear documentation
- `lua/configs/mason-lint.lua` - Streamlined linter installation management

### Syntax Highlighting

- `lua/configs/treesitter.lua` - Performance-optimized treesitter with syntax folding and text objects

## Key Features

1. **Performance Optimizations**

   - Module bytecode caching with `vim.loader.enable()`
   - Improved startup time with deferred loading
   - Optimized treesitter for large files
   - Better lazy-loading of plugins based on actual usage
   - Reduced UI redrawing with `lazyredraw` and other settings
   - Faster timeouts for improved responsiveness

2. **Simplified Configuration Structure**

   - Well-documented configuration files with clear headers
   - Removed redundant settings and defaults
   - Consolidated related settings for easier maintenance
   - Improved organization of language-specific configurations
   - Logically grouped plugins by functionality

3. **Enhanced Code Navigation**

   - Treesitter-based text objects for semantic code selection
   - Function and class navigation with `[f`, `]f`, `[c`, `]c`
   - Incremental selection based on syntax nodes
   - Better window and buffer navigation keymaps
   - NvimTree file explorer optimized for performance

4. **Productivity Improvements**

   - Intuitive keymaps for window resizing and navigation
   - Visual mode enhancements for indentation and moving lines
   - Faster buffer switching and file saving
   - Improved LSP integration and code action shortcuts
   - Automatic formatting and linting with minimal configuration

5. **Formatting and Linting**

   - Lua (stylua)
   - Go (gofumpt, goimports-reviser, golines)
   - JavaScript/TypeScript (prettier, eslint)
   - HTML/CSS (prettier)
   - JSON/YAML (prettier, jq)
   - Kubernetes (yamlfmt, kubeconform)
   - Terraform (terraform_fmt)
   - Docker (dockerfmt)
   - Helm templates (helmfmt)

6. **LSP Support**

   - Lua (lua_ls)
   - Go (gopls)
   - TypeScript (ts_ls)
   - Python (pyright)
   - C/C++ (clangd)
   - HTML/CSS
   - Bash (bashls)
   - YAML (yamlls with Kubernetes schemas)
   - Helm (helm_ls)
   - Terraform (terraformls)
   - Docker (dockerls)

7. **UI Enhancements**
   - Improved UI components with lazy-loaded dressing.nvim
   - Better diagnostic display with Trouble.nvim
   - Rainbow delimiters for nested structures
   - Code context display for current function/class
   - Indentation guides with scope highlighting

## Maintenance Benefits

This configuration has been streamlined for easier maintenance:

- **Clear Documentation**: Each file includes a header explaining its purpose
- **Reduced Redundancy**: Duplicate configurations removed
- **Consistent Style**: Uniform code organization across files
- **Modular Structure**: Related settings kept together
- **Performance Focused**: Optimizations for faster startup and response
- **Selective Defaults**: Only overriding necessary settings

## Installation

1. Ensure you have Neovim >= 0.9.0 installed
2. Clone this repository to your Neovim configuration directory:
   ```bash
   git clone https://github.com/yourusername/nvim-config ~/.config/nvim
   ```
3. Delete the .git directory or fork it for your own use:
   ```bash
   rm -rf ~/.config/nvim/.git
   ```
4. Start Neovim and let it install the plugins

## Requirements

- Neovim >= 0.9.0
- Git
- A C compiler for Treesitter
- Node.js for LSP servers
- Various language-specific tools (will be installed automatically by Mason)
- Kubernetes-specific tools:

  ```bash
  # Docker formatting
  go install github.com/jessfraz/dockfmt@latest

  # Kubescape
  brew install kubescape

  # Kubeconform
  brew install kubeconform

  # Helm (v3.8+ required for fmt command)
  brew install helm
  ```

## Credits

1. NvChad - Base configuration framework
2. LazyVim starter - Inspiration for configuration structure

## License

This project is released into the public domain. See the LICENSE file for details.

Note: This configuration requires NvChad as a base. Make sure you have NvChad properly installed.
