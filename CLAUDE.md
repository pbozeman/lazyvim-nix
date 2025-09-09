# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Nix-based LazyVim configuration that packages a complete Neovim setup with all dependencies. The project provides a standalone Neovim distribution that can be run via Nix without requiring manual dependency installation.

## Commands

### Running LazyVim
```bash
# Run the packaged LazyVim
nix run --extra-experimental-features "nix-command flakes" github:pbozeman/lazyvim-nix

# Or if running locally
nix run
```

### Building and Testing
```bash
# Build the flake
nix build

# Check flake validity
nix flake check

# Update flake inputs
nix flake update
```

### Code Formatting
The project uses Stylua for Lua formatting. Configuration is in `config/stylua.toml`.

## Architecture

### Core Structure

**Nix Infrastructure** (`flake.nix`, `plugins.nix`, `runtime.nix`):
- `flake.nix`: Main entry point that orchestrates the Neovim wrapper with custom init, plugins, and runtime dependencies
- `plugins.nix`: Defines all Vim plugins to be included, mapping between Nix packages and LazyVim plugin names
- `runtime.nix`: Specifies runtime dependencies (LSPs, formatters, linters, debuggers) that are lazy-loaded via `nix shell` commands

**LazyVim Configuration** (`config/`):
- `config/init.lua`: LazyVim initialization with Nix-specific paths and plugin management setup
- `config/lua/config/`: Core LazyVim configuration (keymaps, options, autocmds)
- `config/lua/plugins/`: Custom plugin configurations that extend or override LazyVim defaults

### Key Design Patterns

1. **Nix Package Management**: All dependencies (plugins, LSPs, tools) are managed through Nix rather than Mason or other package managers. Mason is explicitly disabled.

2. **Lazy Loading of Runtime Tools**: Most LSPs and tools use wrapper scripts in `runtime.nix` that invoke `nix shell` on-demand, reducing initial startup time.

3. **Path Injection**: The flake injects critical paths as Vim globals:
   - `g:config_path`: Configuration directory
   - `g:plugin_path`: Linked plugins directory
   - `g:runtime_path`: Runtime dependencies
   - `g:treesitter_path`: Treesitter grammars

4. **Plugin Organization**: Plugins are loaded via LazyVim's module system with both LazyVim extras and custom configurations in `config/lua/plugins/`.

### Language Support

Configured language servers and tools:
- **C/C++**: clangd, cmake-tools, gtest integration, clang-format
- **Nix**: nil_ls, nixpkgs-fmt, nix-develop integration
- **Rust**: rust-analyzer, rustfmt via LazyVim extras
- **Lua**: lua-language-server, stylua
- **Markdown**: marksman, markdownlint, prettier
- **Others**: YAML, JSON, TOML support

### Notable Customizations

- Custom CMake integration with Overseer for build tasks
- Tmux navigator integration
- Neorg note-taking system
- Tint plugin for dimming inactive windows
- Special handling for Vector's clangd if available