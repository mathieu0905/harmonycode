# 🎵 HarmonyCode

AI 编程助手 CLI，支持接入 Kimi、DeepSeek、Anthropic 等兼容 API。

## 安装

```bash
curl -fsSL https://raw.githubusercontent.com/mathieu0905/harmonycode/main/install.sh | bash
```

安装完成后重新打开终端，或执行：

```bash
source ~/.bashrc   # Linux
source ~/.zshrc    # macOS
```

> **注意：** Linux 上如果之前通过 snap 安装过 Bun，需要先确保 `~/.bun/bin` 在 PATH 最前面：
> ```bash
> export PATH="$HOME/.bun/bin:$PATH"
> ```

## 配置

```bash
harmonycode setup
```

选择 API 提供商，输入 Key 即可。也可以手动编辑 `~/.harmonycode/settings.json`：

```json
{
  "env": {
    "ANTHROPIC_API_KEY": "your-api-key",
    "ANTHROPIC_BASE_URL": "https://api.kimi.com/coding/"
  }
}
```

## 使用

```bash
harmonycode                       # 交互模式
harmonycode -p "你的提问"          # 单次问答
harmonycode -p "写个函数" --bare   # 极简模式
harmonycode --help                # 查看所有选项
```

## 支持的 API

| 提供商 | Base URL |
|--------|----------|
| Anthropic | `https://api.anthropic.com` |
| Kimi | `https://api.kimi.com/coding/` |
| 其他兼容 Anthropic Messages API 的服务 | 自定义 |
| OpenAI / DeepSeek 等 | 通过 [LiteLLM](https://github.com/BerriAI/litellm) 代理 |

## 卸载

```bash
rm -rf ~/.harmonycode-cli ~/.harmonycode ~/.local/bin/harmonycode
```
