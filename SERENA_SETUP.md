# Serena MCP Server Setup Guide

This guide explains how to install and configure Serena MCP Server alongside mcp-obsidian.

## What is Serena?

Serena is a powerful coding agent toolkit providing semantic retrieval and editing capabilities. It offers:

- Semantic code analysis using Language Server Protocol (LSP)
- Support for 30+ programming languages
- Advanced code querying and editing functionalities
- Integration with Claude Code and other AI assistants

## Prerequisites

- `uvx` (part of the uv package manager) must be installed
- Python 3.8 or higher

## Quick Start

### 1. Install uvx (if not already installed)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

After installation, restart your terminal or run:
```bash
source $HOME/.local/bin/env
```

### 2. Install Serena

Use the provided setup script:

```bash
./setup-serena.sh
```

Or manually install:

```bash
uvx --from git+https://github.com/oraios/serena serena --help
```

### 3. Configure MCP Server

#### Option A: Using Claude Code CLI

```bash
claude mcp add serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --project $(pwd)
```

#### Option B: Manual Configuration

Add to your Claude Code config file:

**macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
**Windows**: `%APPDATA%/Claude/claude_desktop_config.json`
**Linux**: `~/.config/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "serena": {
      "command": "uvx",
      "args": [
        "--from",
        "git+https://github.com/oraios/serena",
        "serena",
        "start-mcp-server",
        "--context",
        "ide-assistant",
        "--project",
        "/path/to/your/project"
      ]
    }
  }
}
```

## Configuration Options

### Context Types

- `desktop-app` (default): Optimized for desktop applications
- `ide-assistant`: Optimized for IDE-integrated workflows, disables redundant tools

### Modes

- `interactive` (default): Interactive mode for real-time assistance
- `editing`: Optimized for code editing tasks

### Example: Custom Configuration

```json
{
  "mcpServers": {
    "serena": {
      "command": "uvx",
      "args": [
        "--from",
        "git+https://github.com/oraios/serena",
        "serena",
        "start-mcp-server",
        "--context",
        "ide-assistant",
        "--project",
        "/home/user/mcp-obsidian",
        "--log-level",
        "INFO"
      ]
    }
  }
}
```

## Combined Setup with mcp-obsidian

See `mcp-config-example.json` for a complete configuration that includes both mcp-obsidian and Serena MCP servers.

## Verification

To verify Serena is working:

```bash
uvx --from git+https://github.com/oraios/serena serena start-mcp-server --project $(pwd)
```

Press Ctrl+C to stop the server.

## Supported Languages

Serena provides support for: AL, Bash, C#, C/C++, Clojure, Dart, Elixir, Elm, Erlang, Fortran, Go, Haskell, Java, Javascript, Julia, Kotlin, Lua, Markdown, Nix, Perl, PHP, Python, R, Ruby, Rust, Scala, Swift, TypeScript, Zig, and more.

## Troubleshooting

### uvx command not found

Make sure uv is properly installed and in your PATH:
```bash
which uvx
```

If not found, reinstall uv and restart your terminal.

### Serena installation fails

Try updating to the latest version:
```bash
uvx --from git+https://github.com/oraios/serena serena --help
```

The `uvx` command will automatically fetch and install the latest version from GitHub.

## Resources

- [Serena GitHub Repository](https://github.com/oraios/serena)
- [Serena Documentation](https://smartscope.blog/en/generative-ai/claude/serena-mcp-implementation-guide/)
- [MCP Protocol Documentation](https://modelcontextprotocol.io/)

## Updates

Serena is automatically updated when you run uvx commands, as it fetches the latest version from the GitHub repository.
