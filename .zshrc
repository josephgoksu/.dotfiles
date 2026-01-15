# Path to oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
ZSH_DISABLE_COMPFIX=true  # Skip compaudit (saves ~16ms)

# Completion settings
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"

# Minimal plugins - removed bloat (docker/aws/kubectl/etc are just aliases)
plugins=(
    git
    zsh-autosuggestions
    fast-syntax-highlighting
    zsh-completions
    fzf
    history-substring-search
)

source $ZSH/oh-my-zsh.sh

# Environment
export LANG=en_US.UTF-8
export EDITOR='nvim'
export DOCKER_BUILDKIT=1
export GPG_TTY=$(tty)

# PATH - set once, not multiple exports
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/go/bin:$HOME/.cargo/bin:$HOME/.krew/bin:$HOME/.codeium/windsurf/bin:/opt/homebrew/opt/openjdk/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

# Lazy-load NVM (saves ~200ms)
export NVM_DIR="$HOME/.nvm"
nvm() {
    unset -f nvm node npm npx
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    nvm "$@"
}
node() { nvm use default >/dev/null 2>&1; unset -f node; node "$@"; }
npm() { nvm use default >/dev/null 2>&1; unset -f npm; npm "$@"; }
npx() { nvm use default >/dev/null 2>&1; unset -f npx; npx "$@"; }

# Lazy-load pyenv (saves ~100ms)
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
pyenv() {
    unset -f pyenv python python3 pip pip3
    eval "$(command pyenv init - zsh)"
    pyenv "$@"
}
python() { eval "$(command pyenv init - zsh)"; unset -f python; python "$@"; }
python3() { eval "$(command pyenv init - zsh)"; unset -f python3; python3 "$@"; }
pip() { eval "$(command pyenv init - zsh)"; unset -f pip; pip "$@"; }
pip3() { eval "$(command pyenv init - zsh)"; unset -f pip3; pip3 "$@"; }

# Fast inits only
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"

# Aliases
alias nv="nvim"
alias ll="ls -la"
alias gs="git status"
alias gp="git pull"
alias gb="git branch"
alias gc="git commit -m"
alias kctx="kubectl config use-context"
alias kns="kubectl config set-context --current --namespace"
alias tf="tofu"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
