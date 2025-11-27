#!/bin/bash
# Setup script for Serena MCP Server

set -e

echo "Setting up Serena MCP Server..."

# Check if uv/uvx is installed
if ! command -v uvx &> /dev/null; then
    echo "uvx not found. Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    echo "Please restart your terminal and run this script again."
    exit 1
fi

echo "uvx is installed: $(which uvx)"

# Test Serena installation
echo "Installing/updating Serena from GitHub..."
uvx --from git+https://github.com/oraios/serena serena --help

echo ""
echo "✓ Serena is installed successfully!"
echo ""
echo "To add Serena to Claude Code, run:"
echo "  claude mcp add serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --project \$(pwd)"
echo ""
echo "Or manually add to your Claude Code config:"
echo "  See mcp-config-example.json for configuration details"
echo ""
