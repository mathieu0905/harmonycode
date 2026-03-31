#!/bin/bash
# HarmonyCode installer
# Usage: curl -fsSL https://raw.githubusercontent.com/mathieu0905/harmonycode/main/install.sh | bash
set -e
umask 022

VERSION="0.0.1"
REPO="mathieu0905/harmonycode"
INSTALL_DIR="$HOME/.harmonycode-cli"
BIN_DIR="$HOME/.local/bin"
RELEASE_URL="https://github.com/$REPO/releases/download/v$VERSION/harmonycode-$VERSION.tar.gz"

echo ""
echo "  🎵 HarmonyCode v$VERSION Installer"
echo "  ==================================="
echo ""

# 1. Install Bun if needed
if ! command -v bun &> /dev/null; then
  echo "[1/3] Installing Bun runtime..."
  curl -fsSL https://bun.sh/install | bash
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
else
  echo "[1/3] Bun $(bun --version) ✓"
fi

# 2. Download & extract (includes node_modules, no bun install needed)
echo "[2/3] Downloading HarmonyCode v$VERSION..."
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
TMP_FILE="$(mktemp /tmp/harmonycode-XXXXXX.tar.gz)"
curl -fSL -o "$TMP_FILE" "$RELEASE_URL"
tar xzf "$TMP_FILE" -C "$INSTALL_DIR"
rm -f "$TMP_FILE"
chmod +x "$INSTALL_DIR/cli.js" 2>/dev/null || true

# 3. Create launcher
echo "[3/3] Installing CLI command..."
mkdir -p "$BIN_DIR"
cat > "$BIN_DIR/harmonycode" << 'EOF'
#!/bin/bash
export NODE_ENV="${NODE_ENV:-production}"
export CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.harmonycode}"
export _HARMONYCODE_ARGS="$*"
exec bun -e "process.argv = ['bun', 'harmonycode', ...process.env._HARMONYCODE_ARGS.split(/\s+/).filter(Boolean)]; await import('file://' + process.env.HOME + '/.harmonycode-cli/cli.js')"
EOF
chmod +x "$BIN_DIR/harmonycode"

# Add to PATH if needed
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$BIN_DIR"; then
  export PATH="$BIN_DIR:$PATH"
  SHELL_NAME="$(basename "$SHELL")"
  case "$SHELL_NAME" in
    zsh)  SHELL_RC="$HOME/.zshrc" ;;
    bash) SHELL_RC="$HOME/.bashrc" ;;
    *)    SHELL_RC="$HOME/.profile" ;;
  esac
  if ! grep -q '.local/bin' "$SHELL_RC" 2>/dev/null; then
    echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_RC"
    echo "  ✓ Added ~/.local/bin to PATH in $(basename $SHELL_RC)"
    echo "  Run: source $SHELL_RC"
  fi
fi

echo ""
echo "  ✅ HarmonyCode v$VERSION installed!"
echo ""
echo "  Quick start:"
echo "    harmonycode setup          # 配置 API"
echo "    harmonycode                # 交互模式"
echo "    harmonycode -p '你好'      # 单次问答"
echo ""
