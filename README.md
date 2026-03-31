# 🎵 HarmonyCode

AI 编程助手 CLI，支持接入任意兼容 Anthropic API 的服务（Kimi、DeepSeek、Anthropic 等）。

## 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/mathieu0905/harmonycode/main/install.sh | bash
```

### 前置要求

- macOS (Apple Silicon / Intel) 或 Linux
- [Bun](https://bun.sh) 运行时（安装脚本会自动安装）

## 使用

### 配置 API

```bash
harmonycode setup
```

支持预设：**Anthropic**、**Kimi**、**DeepSeek**，或任意自定义端点。

### 开始使用

```bash
harmonycode                              # 交互模式
harmonycode -p "你的提问"                # 单次问答
harmonycode -p "写一个函数" --bare       # 极简模式
harmonycode --help                       # 查看所有选项
```

## 手动配置

编辑 `~/.harmonycode/settings.json`：

```json
{
  "env": {
    "ANTHROPIC_API_KEY": "your-api-key",
    "ANTHROPIC_BASE_URL": "https://api.kimi.com/coding/"
  }
}
```

## 支持的 API

只要兼容 Anthropic Messages API 格式即可：

| 提供商 | Base URL | 状态 |
|--------|----------|------|
| Anthropic | `https://api.anthropic.com` | ✅ |
| Kimi | `https://api.kimi.com/coding/` | ✅ |
| 其他兼容服务 | 自定义 | ✅ |
| OpenAI / DeepSeek | 通过 [LiteLLM](https://github.com/BerriAI/litellm) 代理 | ✅ |

## 卸载

```bash
rm -rf ~/.harmonycode-cli ~/.local/bin/harmonycode
```

## License

MIT
