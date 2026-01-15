#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_status() {
    echo -e "\033[1;34m==> $1\033[0m"
}

save_settings() {
    print_status "Saving macOS settings..."

    # Dock
    defaults export com.apple.dock "$SCRIPT_DIR/dock.plist"
    print_status "Saved Dock settings"

    # Finder
    defaults export com.apple.finder "$SCRIPT_DIR/finder.plist"
    print_status "Saved Finder settings"

    # Keyboard
    defaults export NSGlobalDomain "$SCRIPT_DIR/global.plist"
    print_status "Saved Global settings (keyboard, locale, etc.)"

    # Trackpad
    defaults export com.apple.AppleMultitouchTrackpad "$SCRIPT_DIR/trackpad.plist" 2>/dev/null || true
    defaults export com.apple.driver.AppleBluetoothMultitouch.trackpad "$SCRIPT_DIR/trackpad-bt.plist" 2>/dev/null || true
    print_status "Saved Trackpad settings"

    print_status "Settings saved to $SCRIPT_DIR"
}

apply_settings() {
    print_status "Applying macOS settings..."

    # Dock
    if [ -f "$SCRIPT_DIR/dock.plist" ]; then
        defaults import com.apple.dock "$SCRIPT_DIR/dock.plist"
        print_status "Applied Dock settings"
    fi

    # Finder
    if [ -f "$SCRIPT_DIR/finder.plist" ]; then
        defaults import com.apple.finder "$SCRIPT_DIR/finder.plist"
        print_status "Applied Finder settings"
    fi

    # Global
    if [ -f "$SCRIPT_DIR/global.plist" ]; then
        defaults import NSGlobalDomain "$SCRIPT_DIR/global.plist"
        print_status "Applied Global settings"
    fi

    # Trackpad
    if [ -f "$SCRIPT_DIR/trackpad.plist" ]; then
        defaults import com.apple.AppleMultitouchTrackpad "$SCRIPT_DIR/trackpad.plist"
        print_status "Applied Trackpad settings"
    fi
    if [ -f "$SCRIPT_DIR/trackpad-bt.plist" ]; then
        defaults import com.apple.driver.AppleBluetoothMultitouch.trackpad "$SCRIPT_DIR/trackpad-bt.plist"
        print_status "Applied Bluetooth Trackpad settings"
    fi

    # Restart affected apps
    print_status "Restarting Dock and Finder..."
    killall Dock
    killall Finder

    print_status "Settings applied!"
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
        echo "  save  - Save current macOS settings to dotfiles"
        echo "  apply - Apply saved settings to this Mac"
        exit 1
        ;;
esac
