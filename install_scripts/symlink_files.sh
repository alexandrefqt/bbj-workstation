#!/usr/bin/env bash
set -euo pipefail

# Define constants
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config.backup/$(date +"%Y%m%d_%H-%M-%S")"
mkdir -p "$BACKUP_DIR"

# Define config source paths
STARSHIP_CONFIG="$HOME/.local/share/dotfiles/config/starship.toml"
ZSH_CONFIG="$HOME/.local/share/dotfiles/zshrc"
BASH_CONFIG="$HOME/.local/share/dotfiles/bashrc"
VIM_CONFIG="$HOME/.local/share/dotfiles/vimrc"
TMUX_CONFIG="$HOME/.local/share/dotfiles/tmux.conf"

# Read the list of config files to install
mapfile -t CONFIG_FILES < config_files.txt

for file in "${CONFIG_FILES[@]}"; do
  case "$file" in
    "starship.toml")
      target="$CONFIG_DIR/$file"
      source="$STARSHIP_CONFIG"
      ;;
    ".zshrc")
      target="$HOME/$file"
      source="$ZSH_CONFIG"
      ;;
    ".bashrc")
      target="$HOME/$file"
      source="$BASH_CONFIG"
      ;;
    ".vimrc")
      target="$HOME/$file"
      source="$VIM_CONFIG"
      ;;
    ".tmux.conf")
      target="$HOME/$file"
      source="$TMUX_CONFIG"
      ;;
    *)
      echo "⚠️  Invalid config entry: $file"
      continue
      ;;
  esac

  echo "▶ Processing $file"

  if [[ -L "$target" ]]; then
    echo "🔗 Removing existing symlink: $target"
    rm "$target"
  elif [[ -e "$target" ]]; then
    echo "📦 Backing up: $target → $BACKUP_DIR/"
    mv "$target" "$BACKUP_DIR/"
  else
    echo "ℹ️  No existing file at $target"
  fi

  echo "🔗 Linking $source → $target"
  ln -sfn "$source" "$target"
  echo "✅ Done: $file"
  echo
done
