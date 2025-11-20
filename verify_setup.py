#!/usr/bin/env python3
"""
Verify the Obsidian MCP Server setup.
This script checks if all requirements are met and the server can connect to Obsidian.
"""

import os
import sys
import requests
from dotenv import load_dotenv

# Colors for terminal output
GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
RESET = '\033[0m'

def print_status(message, status):
    """Print a status message with color."""
    if status == "success":
        print(f"{GREEN}✓{RESET} {message}")
    elif status == "error":
        print(f"{RED}✗{RESET} {message}")
    elif status == "warning":
        print(f"{YELLOW}⚠{RESET} {message}")
    else:
        print(f"{BLUE}ℹ{RESET} {message}")

def main():
    print(f"\n{BLUE}{'='*60}{RESET}")
    print(f"{BLUE}Obsidian MCP Server Setup Verification{RESET}")
    print(f"{BLUE}{'='*60}{RESET}\n")

    # Check 1: .env file exists
    env_file = os.path.join(os.path.dirname(__file__), '.env')
    if os.path.exists(env_file):
        print_status(".env file exists", "success")
    else:
        print_status(".env file not found", "error")
        print(f"  Create a .env file with OBSIDIAN_API_KEY and OBSIDIAN_HOST")
        return False

    # Check 2: Load environment variables
    load_dotenv()
    api_key = os.getenv("OBSIDIAN_API_KEY")
    host = os.getenv("OBSIDIAN_HOST", "http://localhost:27123")

    if api_key and api_key != "your_api_key_here":
        print_status("OBSIDIAN_API_KEY is configured", "success")
    else:
        print_status("OBSIDIAN_API_KEY not configured or using placeholder", "error")
        print(f"  Edit .env and add your actual API key from Obsidian")
        return False

    print_status(f"OBSIDIAN_HOST set to: {host}", "info")

    # Check 3: Test connection to Obsidian
    print(f"\n{BLUE}Testing connection to Obsidian...{RESET}")
    try:
        response = requests.get(f"{host}/", timeout=5)
        if response.status_code == 200:
            print_status(f"Successfully connected to Obsidian at {host}", "success")
        else:
            print_status(f"Connected but received status code: {response.status_code}", "warning")
    except requests.exceptions.ConnectionError:
        print_status(f"Cannot connect to Obsidian at {host}", "error")
        print(f"  Make sure:")
        print(f"  1. Obsidian is running")
        print(f"  2. Local REST API plugin is installed and enabled")
        print(f"  3. The port matches your plugin settings")
        return False
    except requests.exceptions.Timeout:
        print_status("Connection timeout", "error")
        return False
    except Exception as e:
        print_status(f"Error testing connection: {e}", "error")
        return False

    # Check 4: Test API authentication
    print(f"\n{BLUE}Testing API authentication...{RESET}")
    try:
        headers = {"Authorization": f"Bearer {api_key}"}
        response = requests.get(f"{host}/vault/", headers=headers, timeout=5)
        if response.status_code == 200:
            print_status("API authentication successful", "success")
            data = response.json()
            if 'files' in data:
                print_status(f"Found {len(data['files'])} files in vault", "success")
        elif response.status_code == 401:
            print_status("API authentication failed - invalid API key", "error")
            print(f"  Check that your API key matches the one in Obsidian settings")
            return False
        else:
            print_status(f"API returned status code: {response.status_code}", "warning")
    except Exception as e:
        print_status(f"Error testing API: {e}", "error")
        return False

    # All checks passed
    print(f"\n{GREEN}{'='*60}{RESET}")
    print(f"{GREEN}✓ All checks passed! Your setup is ready.{RESET}")
    print(f"{GREEN}{'='*60}{RESET}\n")
    print(f"You can now:")
    print(f"  1. Run the server: uv run mcp-obsidian")
    print(f"  2. Configure Claude Desktop (see SETUP.md)")
    print(f"  3. Use the MCP Inspector for testing")
    print()
    return True

if __name__ == "__main__":
    try:
        success = main()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print(f"\n{YELLOW}Verification cancelled{RESET}")
        sys.exit(1)
