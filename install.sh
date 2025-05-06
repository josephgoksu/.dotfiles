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

if [ ! -d "$ZSH_CUSTOM/plugins/alias-tips" ]; then
    git clone https://github.com/djui/alias-tips.git "$ZSH_CUSTOM/plugins/alias-tips"
fi

# Create symlinks
print_status "Creating symlinks..."
backup_if_exists "$HOME/.zshrc"
backup_if_exists "$CONFIG_DIR/starship.toml"
backup_if_exists "$HOME/.gitconfig"
backup_if_exists "$CONFIG_DIR/ghostty/config.toml"

ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.config/starship.toml" "$CONFIG_DIR/starship.toml"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/.config/ghostty/config.toml" "$CONFIG_DIR/ghostty/config.toml"

# Install remaining dependencies
print_status "Installing remaining dependencies..."
if ! brew bundle --file="$DOTFILES_DIR/Brewfile"; then
    print_warning "Some Brewfile dependencies failed to install."
    print_warning "This is normal for some packages or if they are no longer available."
    print_warning "You can try installing failed packages manually."
fi

print_status "Setup complete! Please restart your shell."
