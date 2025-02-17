#!/bin/bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

print_status() {
    echo -e "\033[1;34m==> $1\033[0m"
}

backup_if_exists() {
    if [ -e "$1" ]; then
        print_status "Backing up existing $1 to $1.backup"
        mv "$1" "$1.backup"
    fi
}

print_status "Setting up dotfiles..."

if [ ! -d "$DOTFILES_DIR" ]; then
    print_status "Cloning dotfiles repository..."
    git clone https://github.com/josephgoksu/.dotfiles.git "$DOTFILES_DIR"
else
    print_status "Dotfiles directory already exists, pulling latest changes..."
    cd "$DOTFILES_DIR"
    git pull
fi

mkdir -p "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR/ghostty"

print_status "Creating symlinks..."
backup_if_exists "$HOME/.zshrc"
backup_if_exists "$CONFIG_DIR/starship.toml"
backup_if_exists "$HOME/.gitconfig"
backup_if_exists "$CONFIG_DIR/ghostty/config.toml"

ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.config/starship.toml" "$CONFIG_DIR/starship.toml"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/.config/ghostty/config.toml" "$CONFIG_DIR/ghostty/config.toml"

if ! command -v brew &>/dev/null; then
    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    print_status "Homebrew already installed, updating..."
    brew update
fi

print_status "Installing dependencies..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

print_status "Setup complete! Please restart your shell."
