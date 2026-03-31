#!/bin/bash
# HarmonyCode installer
# Usage: curl -fsSL https://raw.githubusercontent.com/mathieu0905/harmonycode/main/install.sh | bash
set -e

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
  echo "[1/4] Installing Bun runtime..."
  curl -fsSL https://bun.sh/install | bash
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
else
  echo "[1/4] Bun $(bun --version) ✓"
fi

# 2. Download release
echo "[2/4] Downloading HarmonyCode v$VERSION..."
mkdir -p "$INSTALL_DIR"
curl -fSL "$RELEASE_URL" | tar xz -C "$INSTALL_DIR"
chmod +x "$INSTALL_DIR/cli.js"

# 3. Install runtime dependencies
echo "[3/4] Installing dependencies..."
cd "$INSTALL_DIR"
bun install 2>&1 | tail -1

# 4. Create launcher
echo "[4/4] Installing CLI command..."
mkdir -p "$BIN_DIR"
cat > "$BIN_DIR/harmonycode" << 'EOF'
#!/bin/bash
export NODE_ENV="${NODE_ENV:-production}"
export CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.harmonycode}"
exec bun run "$HOME/.harmonycode-cli/cli.js" "$@"
EOF
chmod +x "$BIN_DIR/harmonycode"

# Add to PATH if needed
NEED_PATH=false
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$BIN_DIR"; then
  NEED_PATH=true
  export PATH="$BIN_DIR:$PATH"
fi

echo ""
echo "  ✅ HarmonyCode v$VERSION installed!"
echo ""

if [ "$NEED_PATH" = true ]; then
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
  echo ""
fi

echo "  Quick start:"
echo "    harmonycode setup          # 配置 API"
echo "    harmonycode                # 交互模式"
echo "    harmonycode -p '你好'      # 单次问答"
echo ""
