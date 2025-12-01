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

## Using a different Git identity on a work machine

Keep the repo unchanged and override identity locally after running `./install.sh`:

1. Remove the symlink: `rm ~/.gitconfig`
2. Create `~/.gitconfig` that includes the repo defaults and overrides identity:
   ```ini
   [include]
       path = ~/.dotfiles/.gitconfig
   [user]
       name = Your Name
       email = your.work@email
       signingkey = <KEYID>
   [commit]
       gpgsign = true
   ```

## Quick GPG setup (signing commits)

1. Generate a key: `gpg --full-generate-key` (choose Ed25519 if offered).
2. Find the key ID: `gpg --list-secret-keys --keyid-format=long`
3. Set Git to use it: `git config --global user.signingkey <KEYID>`
4. Export public key to add to your Git host:  
   `gpg --armor --export your.work@email > ~/Desktop/work-gpg.pub`
5. Optional backup:  
   `gpg --armor --export-secret-keys your.work@email > ~/Desktop/work-gpg-private.asc`  
   Store securely; generate a revocation cert with `gpg --gen-revoke <KEYID>`.

## License

Apache 2.0 License
