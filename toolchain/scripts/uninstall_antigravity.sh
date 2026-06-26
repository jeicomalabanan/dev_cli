#!/bin/bash

set -e

echo "========================================"
echo " Uninstalling Antigravity"
echo "========================================"

# Stop running app
pkill -f "Antigravity" || true
sleep 1

echo "Removing app..."
sudo rm -rf "/Applications/Antigravity.app"

echo "Removing user data..."
rm -rf "$HOME/Library/Application Support/Antigravity"
rm -rf "$HOME/Library/Caches/Antigravity"
rm -rf "$HOME/Library/Logs/Antigravity"
rm -rf "$HOME/Library/Saved Application State/com.antigravity.*"
rm -rf "$HOME/Library/Preferences/com.antigravity.*"

echo "Removing configs..."
rm -rf "$HOME/.antigravity"

echo "Removing workspace storage..."
rm -rf "$HOME/Library/Application Support/Antigravity/User/workspaceStorage"
rm -rf "$HOME/Library/Application Support/Antigravity/User/globalStorage"

echo "Removing CLI links..."
sudo rm -f /usr/local/bin/antigravity
sudo rm -f /opt/homebrew/bin/antigravity

echo "Done removing Antigravity"