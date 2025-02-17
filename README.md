# .dotfiles

Personal dotfiles configuration for macOS development environment.

## Features

- Zsh configuration with custom plugins and themes
- Homebrew packages and applications
- Git configuration
- Ghostty terminal configuration
- Starship prompt configuration

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/josephgoksu/.dotfiles/main/install.sh | bash
```

## Manual Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/josephgoksu/.dotfiles.git ~/.dotfiles
   ```

2. Run the install script:
   ```bash
   cd ~/.dotfiles
   ./install.sh
   ```

## What's Included

- `.zshrc`: Zsh shell configuration
- `Brewfile`: Homebrew packages and applications
- `.config/`: Configuration files for various tools
  - `starship.toml`: Starship prompt configuration
  - `ghostty/`: Ghostty terminal configuration
- `.gitconfig`: Git configuration

## Customization

Feel free to fork this repository and modify any configurations to match your preferences.

## Updating

To update the dotfiles, run:

```bash
cd ~/.dotfiles
git pull
./install.sh
```

## License

Apache 2.0 License
