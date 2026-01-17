#!/usr/bin/env bash
set -euo pipefail

APP_NAME="proton-mail"
SYSTEM_DESKTOP="/usr/share/applications/proton-mail.desktop"
USER_DESKTOP="$HOME/.local/share/applications/proton-mail.desktop"
ENV_FIX="ELECTRON_OZONE_PLATFORM_HINT=x11"

# Check if system desktop file exists
if [[ ! -f "$SYSTEM_DESKTOP" ]]; then
  echo "❌ System desktop file not found: $SYSTEM_DESKTOP"
  exit 1
fi

# Check if fix is already applied in user override
if [[ -f "$USER_DESKTOP" ]] && grep -q "$ENV_FIX" "$USER_DESKTOP"; then
  echo "✅ Proton Mail X11 fix already applied."
  exit 0
fi

echo "🔧 Applying Proton Mail X11 fix..."

# Ensure user applications directory exists
mkdir -p "$(dirname "$USER_DESKTOP")"

# Copy system desktop file if user override doesn't exist
if [[ ! -f "$USER_DESKTOP" ]]; then
  cp "$SYSTEM_DESKTOP" "$USER_DESKTOP"
fi

# Modify Exec line safely
sed -i \
  "s|^Exec=.*|Exec=env $ENV_FIX proton-mail|" \
  "$USER_DESKTOP"

# Update desktop database (non-fatal)
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$(dirname "$USER_DESKTOP")" || true
fi

echo "✅ Proton Mail will now always launch with X11 Electron backend."
echo "ℹ️ Log out and back in if your launcher doesn’t update immediately."
