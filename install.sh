#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { printf '\n\033[1;34m==>\033[0m %s\n' "$*"; }

# -- Homebrew --------------------------------
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

log "Updating Homebrew"
brew update
brew upgrade

log "Installing formulae"
brew install \
  wget \
  curl \
  tmux \
  gh \
  pidof \
  jq \
  lazygit \
  bun \
  neovim \
  pnpm \
  terminal-notifier \
  webp

log "Installing NeoVim dependencies"
brew install \
  tree-sitter-cli \
  fd \
  ripgrep

# -- Fonts -----------------------------------
log "Installing fonts"
brew install --cask \
  font-space-mono \
  font-symbols-only-nerd-font \
  font-jetbrains-mono-nerd-font

# -- git -------------------------------------
log "Linking git config"
ln -sfn "$DOTFILES/env/.gitconfig" ~/.gitconfig

# -- oh-my-zsh + zsh -------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "Installing oh-my-zsh"
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  git -C "$ZSH_CUSTOM/plugins/zsh-autosuggestions" pull --ff-only || true
fi

if [ ! -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]; then
  log "Installing spaceship prompt"
  git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git \
    "$ZSH_CUSTOM/themes/spaceship-prompt"
else
  git -C "$ZSH_CUSTOM/themes/spaceship-prompt" pull --ff-only || true
fi
ln -sfn "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" \
  "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

ln -sfn "$DOTFILES/env/.zshrc" ~/.zshrc

# -- kitty -----------------------------------
log "Linking kitty config"
mkdir -p ~/.config/kitty
ln -sfn "$DOTFILES/kitty/kitty.conf" ~/.config/kitty/kitty.conf
ln -sfn "$DOTFILES/kitty/yugen.conf" ~/.config/kitty/yugen.conf

# -- neovim ----------------------------------
log "Linking neovim config"
mkdir -p ~/.config
ln -sfn "$DOTFILES/nvim" ~/.config/nvim

# -- tmux ------------------------------------
log "Setting up tmux"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  git -C ~/.tmux/plugins/tpm pull --ff-only || true
fi
ln -sfn "$DOTFILES/tmux/.tmux.conf" ~/.tmux.conf

# -- better-tmux -----------------------------
# Installed before the tpm plugins because .tmux.conf runs its binary.
log "Setting up better-tmux"
mkdir -p ~/.config
ln -sfn "$DOTFILES/better-tmux" ~/.config/better-tmux
pnpm install --dir "$DOTFILES/better-tmux"

# The npm package is only the library; the CLI is a release binary.
# Downloaded directly instead of the upstream install script, which needs sudo
# and sends analytics.
if [ ! -x ~/.local/bin/better-tmux ]; then
  log "Installing better-tmux CLI"
  mkdir -p ~/.local/bin
  case "$(uname -m)" in
    arm64) btmux_asset=better-tmux-darwin-arm64 ;;
    *) btmux_asset=better-tmux-darwin-x64 ;;
  esac
  curl -fsSL -o ~/.local/bin/better-tmux \
    "https://github.com/bettervim/better-tmux/releases/latest/download/$btmux_asset"
  chmod +x ~/.local/bin/better-tmux
fi

log "Installing tmux plugins"
~/.tmux/plugins/tpm/bin/install_plugins

# -- agents (shared across AI tools) ---------
log "Linking shared agents"
ln -sfn "$DOTFILES/agents" ~/.agents

# -- claude code -----------------------------
log "Linking Claude Code config"
mkdir -p ~/.claude
rm -rf ~/.claude/skills ~/.claude/rules
# agents/ and commands/ were dropped from this repo; clear the old links.
for stale in ~/.claude/agents ~/.claude/commands; do
  [ -L "$stale" ] && rm "$stale"
done
ln -sfn "$DOTFILES/agents/AGENTS.md" ~/.claude/CLAUDE.md
ln -sfn "$DOTFILES/claude/settings.json" ~/.claude/settings.json
ln -sfn "$DOTFILES/agents/skills" ~/.claude/skills
# Rules are not linked into ~/.claude/rules: Claude would load them in full every
# session on top of the index in AGENTS.md. Agents read them on demand instead.

# User-scope MCP servers live in ~/.claude.json, which also holds session state,
# so they are registered with the CLI instead of symlinked.
# API keys live in ~/.zshrc.local, outside the repo.
# shellcheck disable=SC1091
[ -f "$HOME/.zshrc.local" ] && . "$HOME/.zshrc.local"

if command -v claude >/dev/null 2>&1; then
  log "Registering Claude Code MCP servers"
  claude mcp remove --scope user context7 >/dev/null 2>&1 || true
  context7_args=(--transport http --scope user context7 https://mcp.context7.com/mcp)
  # Works without a key at lower rate limits.
  [ -n "${CONTEXT7_API_KEY:-}" ] && context7_args+=(--header "CONTEXT7_API_KEY: $CONTEXT7_API_KEY")
  claude mcp add "${context7_args[@]}"
fi

# -- codex -----------------------------------
# Codex reads skills from ~/.agents/skills (linked above); only the global
# instructions need a link.
log "Linking Codex instructions"
mkdir -p ~/.codex
ln -sfn "$DOTFILES/agents/AGENTS.md" ~/.codex/AGENTS.md

# -- cursor ----------------------------------
# Skills come from ~/.agents/skills and ~/.claude/skills; MCP is only read here.
log "Linking Cursor MCP config"
mkdir -p ~/.cursor
ln -sfn "$DOTFILES/cursor/mcp.json" ~/.cursor/mcp.json

# -- opencode --------------------------------
# Only the config and global rules are linked. Plugins, tui.json and
# node_modules in ~/.config/opencode are managed by opencode and Orca.
log "Linking opencode config"
mkdir -p ~/.config/opencode
ln -sfn "$DOTFILES/opencode/opencode.json" ~/.config/opencode/opencode.json
ln -sfn "$DOTFILES/agents/AGENTS.md" ~/.config/opencode/AGENTS.md
[ -L ~/.opencode/plugins ] && rm ~/.opencode/plugins

# -- global scripts (bin) --------------------
log "Linking bin scripts"
mkdir -p ~/bin
for script in "$DOTFILES"/bin/*; do
  ln -sfn "$script" ~/bin/"$(basename "$script")"
done

# -- nvm + node ------------------------------
log "Installing nvm + node"
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default 'lts/*'

# -- global npm CLIs -------------------------
log "Installing Todoist CLI (td)"
npm install -g @doist/todoist-cli

log "Done. Restart your shell (or run 'exec zsh') to pick up the new config."
