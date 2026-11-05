
export PATH=/opt/homebrew/bin:$PATH

export ZSH="$HOME/.oh-my-zsh/"
export LANG=en_US.UTF-8
export EDITOR="nvim"

ZSH_THEME="spaceship"
plugins=(
  git
  vi-mode
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

if [ "$TMUX" = "" ]; then tmux; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:/usr/local/bin

function mktouch () {
  for p in $@; do
    mkdir -p $(dirname "$p")
  done

  touch $@
}

function png2webp () {
  for file in *.png; do
      cwebp -q 100 "$file" -o "${file%.png}.webp"
  done
}

function clean-swap(){
  rm -rf ~/.local/state/nvim/swap/**/*.swp
}

function clean-branches(){
  git branch --format='%(refname:short)' | grep -vxE "main|$(git branch --show-current)" | xargs git branch -D
}

function kill-ports() {
  for port in "$@"; do
    lsof -ti:$port | xargs kill -9 2>/dev/null
  done
}

function commit-sync() {
  git add .
  git commit -m "*"
  git push
}

function commit-changelog() {
  prefix=$( [ -n "$1" ] && echo "docs($1):" || echo "docs:" )
  git commit -m "$prefix updated CHANGELOG.md"
}

function ssh-vps() {
  local host="${1:-vps}"
  if [ -n "$TMUX" ]; then
    tmux set-option -g prefix C-a
    tmux bind-key C-a send-prefix
    trap 'tmux set-option -g prefix C-d; tmux bind-key C-d send-prefix' EXIT INT
  fi
  ssh "$host"
  if [ -n "$TMUX" ]; then
    tmux set-option -g prefix C-d
    tmux bind-key C-d send-prefix
    trap - EXIT INT
  fi
}

function tmux-revert-prefix() {
  tmux set-option -g prefix C-d
  tmux bind-key C-d send-prefix
  echo "Prefix revertido para C-d"
}

alias vim="nvim"

alias claudio="claude --model fable"
# alias claude="claude --model sonnet"
alias claudin="claude --model haiku"

# pnpm
export PNPM_HOME="/Users/iagolaguna/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Machine-local settings and secrets (API keys). Lives outside the repo.
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# bun completions
[ -s "/Users/iagolaguna/.bun/_bun" ] && source "/Users/iagolaguna/.bun/_bun"
