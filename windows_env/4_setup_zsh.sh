#!/usr/bin/env sh

set -e

# Detect script directory (portable)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Detect Windows username
WIN_USER="$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')"

if [ -z "$WIN_USER" ]; then
  echo "ERROR: Could not detect Windows username."
  exit 1
fi

SRC_ZSHRC="$SCRIPT_DIR/zsh/.zshrc"
WIN_ZSHRC="/mnt/c/Users/$WIN_USER/.zshrc"
LINUX_ZSHRC="$HOME/.zshrc"

echo "Detected Windows user: $WIN_USER"

# Ensure source .zshrc exists
if [ ! -f "$SRC_ZSHRC" ]; then
  echo "ERROR: .zshrc not found in zsh/ directory."
  echo "Expected: $SRC_ZSHRC"
  exit 1
fi

echo "Installing zsh..."
sudo apt update
sudo apt install -y zsh git

echo "Setting zsh as default shell..."
chsh -s "$(which zsh)"

echo "Installing zsh plugins..."

ZSH_PLUGIN_DIR="$HOME/.zsh"

mkdir -p "$ZSH_PLUGIN_DIR"

# zsh-syntax-highlighting
if [ ! -d "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting"
fi

# zsh-autosuggestions
if [ ! -d "$ZSH_PLUGIN_DIR/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_PLUGIN_DIR/zsh-autosuggestions"
fi

echo "Copying .zshrc to Windows home..."
cp "$SRC_ZSHRC" "$WIN_ZSHRC"

echo "Setting up .zshrc symlink..."

# Backup existing ~/.zshrc if it exists and is not a symlink
if [ -f "$LINUX_ZSHRC" ] && [ ! -L "$LINUX_ZSHRC" ]; then
  echo "Backing up existing ~/.zshrc to ~/.zshrc.backup"
  mv "$LINUX_ZSHRC" "$LINUX_ZSHRC.backup"
fi

# Create symlink if needed
if [ ! -L "$LINUX_ZSHRC" ]; then
  ln -s "$WIN_ZSHRC" "$LINUX_ZSHRC"
  echo "Symlink created:"
  echo "  ~/.zshrc -> $WIN_ZSHRC"
else
  echo "Symlink already exists."
fi

echo ""
echo "✅ zsh installed."
echo "✅ zsh plugins installed."
echo "✅ .zshrc copied to Windows home."
echo "✅ .zshrc symlinked into WSL."
echo ""
echo "Close and reopen your WSL terminal to start using zsh."