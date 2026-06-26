#!/bin/bash

echo "Closing WebStorm..."
pkill -f WebStorm

echo "Removing application..."
sudo rm -rf "/Applications/WebStorm.app"

echo "Removing JetBrains settings..."
rm -rf ~/Library/Application\ Support/JetBrains/WebStorm*
rm -rf ~/Library/Caches/JetBrains/WebStorm*
rm -rf ~/Library/Logs/JetBrains/WebStorm*
rm -rf ~/Library/Preferences/WebStorm*
rm -rf ~/Library/Preferences/com.jetbrains.WebStorm.plist
rm -rf ~/Library/Saved\ Application\ State/com.jetbrains.WebStorm.savedState

echo "Removing plugins..."
rm -rf ~/Library/Application\ Support/JetBrains/*/plugins

echo "Removing Toolbox metadata (if installed via Toolbox)..."
rm -rf ~/Library/Application\ Support/JetBrains/Toolbox/apps/WebStorm
rm -rf ~/Library/Application\ Support/JetBrains/Toolbox/.settings.json

echo "Removing configuration directories..."
rm -rf ~/.WebStorm*
rm -rf ~/.cache/JetBrains/WebStorm*
rm -rf ~/.config/JetBrains/WebStorm*
rm -rf ~/.local/share/JetBrains/WebStorm*

echo "Done."