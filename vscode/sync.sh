#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"

print_status() {
    echo -e "\033[1;34m==> $1\033[0m"
}

save_settings() {
    print_status "Saving VS Code settings..."

    if ! command -v code &>/dev/null; then
        echo "Error: VS Code not installed"
        exit 1
    fi

    # Settings
    if [ -f "$VSCODE_USER_DIR/settings.json" ]; then
        cp "$VSCODE_USER_DIR/settings.json" "$SCRIPT_DIR/settings.json"
        print_status "Saved settings.json"
    fi

    # Keybindings
    if [ -f "$VSCODE_USER_DIR/keybindings.json" ]; then
        cp "$VSCODE_USER_DIR/keybindings.json" "$SCRIPT_DIR/keybindings.json"
        print_status "Saved keybindings.json"
    fi

    # Extensions
    code --list-extensions > "$SCRIPT_DIR/extensions.txt"
    print_status "Saved extensions list ($(wc -l < "$SCRIPT_DIR/extensions.txt" | tr -d ' ') extensions)"

    # Snippets
    if [ -d "$VSCODE_USER_DIR/snippets" ] && [ "$(ls -A "$VSCODE_USER_DIR/snippets")" ]; then
        mkdir -p "$SCRIPT_DIR/snippets"
        cp -r "$VSCODE_USER_DIR/snippets/"* "$SCRIPT_DIR/snippets/"
        print_status "Saved snippets"
    fi

    print_status "VS Code settings saved to $SCRIPT_DIR"
}

apply_settings() {
    print_status "Applying VS Code settings..."

    if ! command -v code &>/dev/null; then
        echo "Error: VS Code not installed"
        exit 1
    fi

    # Create VS Code User directory if needed
    mkdir -p "$VSCODE_USER_DIR"

    # Settings
    if [ -f "$SCRIPT_DIR/settings.json" ]; then
        cp "$SCRIPT_DIR/settings.json" "$VSCODE_USER_DIR/settings.json"
        print_status "Applied settings.json"
    fi

    # Keybindings
    if [ -f "$SCRIPT_DIR/keybindings.json" ]; then
        cp "$SCRIPT_DIR/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
        print_status "Applied keybindings.json"
    fi

    # Snippets
    if [ -d "$SCRIPT_DIR/snippets" ] && [ "$(ls -A "$SCRIPT_DIR/snippets" 2>/dev/null)" ]; then
        mkdir -p "$VSCODE_USER_DIR/snippets"
        cp -r "$SCRIPT_DIR/snippets/"* "$VSCODE_USER_DIR/snippets/"
        print_status "Applied snippets"
    fi

    # Extensions
    if [ -f "$SCRIPT_DIR/extensions.txt" ]; then
        print_status "Installing extensions..."
        while IFS= read -r extension; do
            code --install-extension "$extension" --force 2>/dev/null || true
        done < "$SCRIPT_DIR/extensions.txt"
        print_status "Extensions installed"
    fi

    print_status "VS Code settings applied!"
}

case "${1:-}" in
    save)
        save_settings
        ;;
    apply)
        apply_settings
        ;;
    *)
        echo "Usage: $0 {save|apply}"
        echo "  save  - Save current VS Code settings to dotfiles"
        echo "  apply - Apply saved settings to VS Code"
        exit 1
        ;;
esac
