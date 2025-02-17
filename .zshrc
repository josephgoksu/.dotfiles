# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Disable Oh My Zsh theme since using Starship
ZSH_THEME=""

# Enable case-insensitive tab completion
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"

# Auto-update settings for Oh My Zsh
zstyle ':omz:update' mode auto  # update automatically
zstyle ':omz:update' frequency 13

# Enable command auto-correction and completion waiting dots
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files as dirty (improves speed in large repos)
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Display command execution timestamps in history
HIST_STAMPS="yyyy-mm-dd"

# Plugins - keep lightweight to ensure fast startup
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  fast-syntax-highlighting
  zsh-completions
  fzf
  alias-tips
  history-substring-search
  docker
  docker-compose
  aws
  golang
  npm
  nvm
  kubectl
  terraform
  gh
  git-extras
)

source $ZSH/oh-my-zsh.sh

# Set language and editor preferences
export LANG=en_US.UTF-8
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Load NVM properly
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Ensure GPG_TTY is set correctly
export GPG_TTY=$(tty)

# Add Windsurf, Go, and additional binaries to PATH
export PATH="/Users/josephgoksu/.codeium/windsurf/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"  # Rust binaries
export PATH="$HOME/.krew/bin:$PATH"   # Krew for Kubernetes plugins

# Initialize Starship prompt
eval "$(starship init zsh)"

# Useful aliases
alias nv="nvim"
alias ll="ls -la"
alias gs="git status"
alias gp="git pull"
alias gb="git branch"
alias gc="git commit -m"
alias kctx="kubectl config use-context"
alias kns="kubectl config set-context --current --namespace"
alias tf="terraform"

# Faster directory navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
