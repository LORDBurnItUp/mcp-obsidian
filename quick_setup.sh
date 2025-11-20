#!/bin/bash

# Quick Setup Script for Obsidian MCP Server
# This script helps you complete the setup interactively

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}Obsidian MCP Server - Quick Setup${NC}"
echo -e "${BLUE}============================================${NC}\n"

# Check if .env exists
if [ ! -f .env ]; then
    echo -e "${RED}✗ .env file not found${NC}"
    echo "Creating .env file..."
    cat > .env << 'EOF'
# Obsidian MCP Server Configuration
OBSIDIAN_API_KEY=your_api_key_here
OBSIDIAN_HOST=http://localhost:27123
EOF
    echo -e "${GREEN}✓ .env file created${NC}\n"
else
    echo -e "${GREEN}✓ .env file exists${NC}\n"
fi

# Check if API key is configured
source .env 2>/dev/null || true

if [ -z "$OBSIDIAN_API_KEY" ] || [ "$OBSIDIAN_API_KEY" = "your_api_key_here" ]; then
    echo -e "${YELLOW}⚠ API key not configured${NC}\n"

    echo "To get your API key:"
    echo "1. Open Obsidian"
    echo "2. Go to Settings → Community Plugins"
    echo "3. Search for 'Local REST API' and install it"
    echo "4. Enable the plugin"
    echo "5. Open the plugin settings"
    echo "6. Copy the API Key"
    echo ""

    read -p "Paste your Obsidian API key here (or press Enter to skip): " api_key

    if [ ! -z "$api_key" ]; then
        # Update .env file with the new API key
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/OBSIDIAN_API_KEY=.*/OBSIDIAN_API_KEY=$api_key/" .env
        else
            sed -i "s/OBSIDIAN_API_KEY=.*/OBSIDIAN_API_KEY=$api_key/" .env
        fi
        echo -e "${GREEN}✓ API key saved to .env${NC}\n"
        OBSIDIAN_API_KEY="$api_key"
    else
        echo -e "${YELLOW}⚠ Skipped API key configuration${NC}"
        echo -e "  You can edit .env manually later\n"
    fi
fi

# Ask about host/port
if [ ! -z "$OBSIDIAN_HOST" ] && [ "$OBSIDIAN_HOST" != "http://localhost:27123" ]; then
    echo -e "${BLUE}ℹ Current host: $OBSIDIAN_HOST${NC}"
else
    read -p "Is Obsidian running on a different host/port? (default: http://localhost:27123): " custom_host

    if [ ! -z "$custom_host" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s|OBSIDIAN_HOST=.*|OBSIDIAN_HOST=$custom_host|" .env
        else
            sed -i "s|OBSIDIAN_HOST=.*|OBSIDIAN_HOST=$custom_host|" .env
        fi
        echo -e "${GREEN}✓ Host updated to $custom_host${NC}\n"
    fi
fi

# Test the connection
echo -e "\n${BLUE}Testing connection...${NC}\n"

if [ ! -z "$OBSIDIAN_API_KEY" ] && [ "$OBSIDIAN_API_KEY" != "your_api_key_here" ]; then
    if command -v python3 &> /dev/null; then
        python3 verify_setup.py
    else
        echo -e "${YELLOW}⚠ Python 3 not found, skipping connection test${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Cannot test connection without API key${NC}"
fi

echo -e "\n${BLUE}============================================${NC}"
echo -e "${GREEN}Setup script completed!${NC}"
echo -e "${BLUE}============================================${NC}\n"

echo "Next steps:"
echo "1. Make sure Obsidian is running with the Local REST API plugin enabled"
echo "2. Run: uv run mcp-obsidian (to test the server)"
echo "3. Configure Claude Desktop (see SETUP.md for instructions)"
echo "4. Run: python3 verify_setup.py (to verify everything works)"
echo ""
echo "For detailed instructions, see SETUP.md"
echo ""
