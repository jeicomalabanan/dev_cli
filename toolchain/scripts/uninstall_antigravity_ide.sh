#!/bin/bash

set -e

echo "========================================"
echo " Uninstalling Antigravity IDE"
echo "========================================"

# Stop running IDE
pkill -f "Antigravity IDE" || true
pkill -f "AntigravityIDE" || true
sleep 1

echo "Removing app..."
sudo rm -rf "/Applications/Antigravity IDE.app"

echo "Removing user data..."
rm -rf "$HOME/Library/Application Support/Antigravity IDE"
rm -rf "$HOME/Library/Caches/Antigravity IDE"
rm -rf "$HOME/Library/Logs/Antigravity IDE"
rm -rf "$HOME/Library/Saved Application State/com.antigravityide.*"
rm -rf "$HOME/Library/Preferences/com.antigravityide.*"

echo "Removing VS Code-style data..."
rm -rf "$HOME/.antigravity-ide"
rm -rf "$HOME/.config/Antigravity IDE"

echo "Removing workspace storage..."
rm -rf "$HOME/Library/Application Support/Antigravity IDE/User/workspaceStorage"
rm -rf "$HOME/Library/Application Support/Antigravity IDE/User/globalStorage"

echo "Removing CLI links..."
sudo rm -f /usr/local/bin/antigravityide
sudo rm -f /opt/homebrew/bin/antigravityide

echo "Done removing Antigravity IDE"