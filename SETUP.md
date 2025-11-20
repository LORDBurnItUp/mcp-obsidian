# Obsidian MCP Server Setup Guide

## Setup Status ✓

Your Obsidian MCP server has been initialized! Follow the steps below to complete the setup.

## What's Been Done

- ✅ Python dependencies installed (via `uv sync`)
- ✅ `.env` configuration file created
- ✅ Helper scripts created (`quick_setup.sh`, `verify_setup.py`)
- ✅ Project is ready to run

## Quick Setup (Recommended)

Run the interactive setup script:

```bash
./quick_setup.sh
```

This script will:
- Guide you through API key configuration
- Test the connection to Obsidian
- Verify everything is working

Then verify your setup:

```bash
python3 verify_setup.py
```

## Manual Setup

If you prefer to set up manually, follow these steps:

### Next Steps

### 1. Install Obsidian Local REST API Plugin

1. Open Obsidian
2. Go to **Settings** → **Community Plugins**
3. Click **Browse** and search for "Local REST API"
4. Install and **Enable** the plugin
5. Go to plugin settings and copy your **API Key**

### 2. Configure Your API Key

Edit the `.env` file in this directory and replace `your_api_key_here` with your actual API key:

```bash
OBSIDIAN_API_KEY=your_actual_api_key_from_obsidian
OBSIDIAN_HOST=http://localhost:27123  # Change if you modified the port
```

### 3. Test the Server

Run the following command to test if the server works:

```bash
uv run mcp-obsidian
```

The server should start without errors. Press Ctrl+C to stop it.

### 4. Configure Claude Desktop (Optional)

To use this MCP server with Claude Desktop, add the following to your Claude Desktop configuration:

**MacOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
**Windows:** `%APPDATA%/Claude/claude_desktop_config.json`

#### For Development (this local directory):

```json
{
  "mcpServers": {
    "mcp-obsidian": {
      "command": "uv",
      "args": [
        "--directory",
        "/home/user/mcp-obsidian",
        "run",
        "mcp-obsidian"
      ],
      "env": {
        "OBSIDIAN_API_KEY": "your_api_key_here",
        "OBSIDIAN_HOST": "http://localhost:27123"
      }
    }
  }
}
```

#### For Production (using published package):

```json
{
  "mcpServers": {
    "mcp-obsidian": {
      "command": "uvx",
      "args": [
        "mcp-obsidian"
      ],
      "env": {
        "OBSIDIAN_API_KEY": "your_api_key_here",
        "OBSIDIAN_HOST": "http://localhost:27123"
      }
    }
  }
}
```

**Note:** Replace `/home/user/mcp-obsidian` with the actual path to this repository on your system.

### 5. Restart Claude Desktop

After updating the configuration, restart Claude Desktop to load the MCP server.

## Available Tools

Once connected, Claude can use these tools to interact with your Obsidian vault:

- `list_files_in_vault` - List all files in your vault root
- `list_files_in_dir` - List files in a specific directory
- `get_file_contents` - Read a file's content
- `search` - Search across all vault files
- `patch_content` - Insert content relative to headings or blocks
- `append_content` - Append to existing or new files
- `delete_file` - Delete files or directories
- `complex_search` - Advanced search capabilities
- `batch_get_file_contents` - Get multiple files at once
- `periodic_notes` - Work with periodic notes
- `recent_periodic_notes` - Access recent periodic notes
- `recent_changes` - See recently modified files

## Example Prompts

Try these prompts in Claude Desktop:

- "List all the files in my Obsidian vault"
- "Search for notes mentioning 'project planning'"
- "Get the contents of my daily note"
- "Create a new note called 'Meeting Notes.md' with a summary"
- "What are my recent changes?"

## Debugging

To debug the MCP server using the MCP Inspector:

```bash
npx @modelcontextprotocol/inspector uv --directory /home/user/mcp-obsidian run mcp-obsidian
```

To watch server logs (macOS):

```bash
tail -n 20 -f ~/Library/Logs/Claude/mcp-server-mcp-obsidian.log
```

## Troubleshooting

### "OBSIDIAN_API_KEY environment variable required" error

- Make sure you've edited the `.env` file with your actual API key
- Or set the environment variable in your Claude Desktop config

### Connection errors

- Ensure Obsidian is running
- Verify the Local REST API plugin is enabled
- Check that the port (default 27123) matches your plugin settings
- Try accessing `http://localhost:27123` in your browser

### Plugin not found

- Make sure Community Plugins are enabled in Obsidian
- Search for "Local REST API" (not just "REST API")
- Repository: https://github.com/coddingtonbear/obsidian-local-rest-api

### Use the verification script

Run the verification script to diagnose issues:

```bash
python3 verify_setup.py
```

This will check:
- ✓ .env file exists
- ✓ API key is configured
- ✓ Connection to Obsidian works
- ✓ API authentication succeeds

## What's Automated vs Manual

### ✅ Automated (Already Done)
- Python environment setup
- Dependency installation
- Configuration file creation
- Helper scripts for verification

### ⚠️ Requires Manual Steps
- **Installing Obsidian** - Desktop application (your machine)
- **Installing Local REST API plugin** - In Obsidian settings
- **Getting API key** - From Obsidian plugin settings
- **Updating .env with API key** - Edit the file or run `quick_setup.sh`
- **Running Obsidian** - Must be running when using the server

## Need Help?

- Check the main README.md for more information
- Review the Obsidian Local REST API plugin documentation
- Open an issue on the project repository
