#!/bin/bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

print_status() {
    echo -e "\033[1;34m==> $1\033[0m"
}

print_error() {
    echo -e "\033[1;31m==> ERROR: $1\033[0m"
}

print_warning() {
    echo -e "\033[1;33m==> WARNING: $1\033[0m"
}

backup_if_exists() {
    if [ -e "$1" ]; then
        print_status "Backing up existing $1 to $1.backup"
        mv "$1" "$1.backup"
    fi
}

print_status "Setting up dotfiles..."

# Install Homebrew first as it's needed for everything else
if ! command -v brew &>/dev/null; then
    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    print_status "Homebrew already installed, updating..."
    brew update
fi

# Clone dotfiles if needed
if [ ! -d "$DOTFILES_DIR" ]; then
    print_status "Cloning dotfiles repository..."
    git clone https://github.com/josephgoksu/.dotfiles.git "$DOTFILES_DIR"
else
    print_status "Dotfiles directory already exists, pulling latest changes..."
    cd "$DOTFILES_DIR"
    git pull
fi

# Create necessary directories
mkdir -p "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR/ghostty"
mkdir -p "$HOME/.nvm"

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install essential packages first
print_status "Installing essential packages..."
ESSENTIAL_PACKAGES=(
    "git"
    "zsh"
    "starship"
    "neovim"
    "fzf"
    "ripgrep"
)

for package in "${ESSENTIAL_PACKAGES[@]}"; do
    if brew list "$package" &>/dev/null; then
        print_status "$package already installed, skipping..."
    else
        print_status "Installing $package..."
        if ! brew install "$package"; then
            print_error "Failed to install $package"
        fi
    fi
done

# Install Zsh plugins
print_status "Installing Zsh plugins..."

# Create custom plugins directory
mkdir -p "$ZSH_CUSTOM/plugins"

# Install external plugins
print_status "Installing external Zsh plugins..."
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ]; then
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
    git clone https://github.com/zsh-users/zsh-completions.git "$ZSH_CUSTOM/plugins/zsh-completions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/history-substring-search" ]; then
    git clone https://github.com/zsh-users/zsh-history-substring-search.git "$ZSH_CUSTOM/plugins/history-substring-search"
fi

# Create symlinks (only backup real files, not existing symlinks)
print_status "Creating symlinks..."
for file in "$HOME/.zshrc" "$CONFIG_DIR/starship.toml" "$HOME/.gitconfig" "$CONFIG_DIR/ghostty/config"; do
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        backup_if_exists "$file"
    fi
done

ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.config/starship.toml" "$CONFIG_DIR/starship.toml"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/.config/ghostty/config" "$CONFIG_DIR/ghostty/config"

# Install remaining dependencies
print_status "Installing remaining dependencies..."
if ! brew bundle --file="$DOTFILES_DIR/Brewfile"; then
    print_warning "Some Brewfile dependencies failed to install."
    print_warning "This is normal for some packages or if they are no longer available."
    print_warning "You can try installing failed packages manually."
fi

# Optionally apply macOS settings
if [ -f "$DOTFILES_DIR/macos/settings.sh" ]; then
    read -p "Apply saved macOS settings (Dock, Finder, keyboard, trackpad)? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        "$DOTFILES_DIR/macos/settings.sh" apply
    fi
fi

# Optionally apply VS Code settings
if [ -f "$DOTFILES_DIR/vscode/sync.sh" ] && command -v code &>/dev/null; then
    read -p "Apply saved VS Code settings and extensions? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        "$DOTFILES_DIR/vscode/sync.sh" apply
    fi
fi

print_status "Setup complete! Please restart your shell."
