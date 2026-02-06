#!/usr/bin/env sh

set -e

# Detect script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Detect Windows username
WIN_USER="$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')"

if [ -z "$WIN_USER" ]; then
  echo "ERROR: Could not detect Windows username."
  exit 1
fi

SRC_STARSHIP="$SCRIPT_DIR/starship/starship.toml"

WIN_STARSHIP="/mnt/c/Users/$WIN_USER/starship.toml"
LINUX_CONFIG_DIR="$HOME/.config"
LINUX_STARSHIP="$LINUX_CONFIG_DIR/starship.toml"

# Ensure source starship.toml exists
if [ ! -f "$SRC_STARSHIP" ]; then
  echo "ERROR: starship.toml not found next to the script."
  echo "Expected: $SRC_STARSHIP"
  exit 1
fi

echo "Installing Starship..."
curl -sS https://starship.rs/install.sh | sh

echo "Copying starship.toml to Windows user directory..."
cp "$SRC_STARSHIP" "$WIN_STARSHIP"

echo "Setting up starship.toml symlink..."

mkdir -p "$LINUX_CONFIG_DIR"

# Backup existing config if it exists and is not a symlink
if [ -f "$LINUX_STARSHIP" ] && [ ! -L "$LINUX_STARSHIP" ]; then
  echo "Backing up existing ~/.config/starship.toml"
  mv "$LINUX_STARSHIP" "$LINUX_STARSHIP.backup"
fi

# Create symlink if needed
if [ ! -L "$LINUX_STARSHIP" ]; then
  ln -s "$WIN_STARSHIP" "$LINUX_STARSHIP"
  echo "Symlink created:"
  echo "  ~/.config/starship.toml -> $WIN_STARSHIP"
else
  echo "Symlink already exists."
fi

echo ""
echo "✅ Starship installed."
echo "✅ starship.toml copied to Windows home."
echo "✅ starship.toml symlinked into WSL."