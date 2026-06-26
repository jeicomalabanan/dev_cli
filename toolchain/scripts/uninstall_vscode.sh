#!/bin/bash
# Fully uninstall VS Code on macOS

echo "Quitting VS Code..."
osascript -e 'quit app "Visual Studio Code"'

echo "Removing VS Code application..."
sudo rm -rf /Applications/Visual\ Studio\ Code.app

echo "Removing VS Code settings, caches, and extensions..."
rm -rf ~/Library/Application\ Support/Code \
       ~/Library/Caches/com.microsoft.VSCode \
       ~/Library/Caches/com.microsoft.VSCode.ShipIt \
       ~/Library/Preferences/com.microsoft.VSCode.plist \
       ~/Library/Saved\ Application\ State/com.microsoft.VSCode.savedState \
       ~/.vscode

echo "Removing 'code' command if exists..."
sudo rm -f /usr/local/bin/code

echo "VS Code has been completely removed!"
