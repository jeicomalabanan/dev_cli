#!/bin/bash

echo "🧹 Uninstalling Android Studio and cleaning up related files..."

# Remove Android Studio app (if exists)
echo "➡ Removing Android Studio app..."
rm -rf /Applications/Android\ Studio.app

# Remove preferences, caches, logs, and support files
echo "➡ Removing config, cache, and log files..."
rm -rf ~/Library/Application\ Support/Google/AndroidStudio*
rm -rf ~/Library/Application\ Support/AndroidStudio*
rm -rf ~/Library/Preferences/Google/AndroidStudio*
rm -rf ~/Library/Preferences/AndroidStudio*
rm -rf ~/Library/Caches/Google/AndroidStudio*
rm -rf ~/Library/Caches/AndroidStudio*
rm -rf ~/Library/Logs/Google/AndroidStudio*
rm -rf ~/Library/Logs/AndroidStudio*

# Remove Android emulator files
echo "➡ Removing emulator files..."
rm -rf ~/.android
rm -rf ~/Library/Android

# Remove SDK (if exists)
echo "➡ Removing Android SDK..."
rm -rf ~/Android/Sdk

# Remove Gradle cache
echo "➡ Removing Gradle cache..."
rm -rf ~/.gradle

# Remove JetBrains / IntelliJ configs (if used for Android)
echo "➡ Removing JetBrains / IntelliJ configs..."
rm -rf ~/Library/Preferences/IntelliJIdea*
rm -rf ~/Library/Application\ Support/JetBrains/IntelliJIdea*
rm -rf ~/Library/Caches/IntelliJIdea*
rm -rf ~/Library/Logs/IntelliJIdea*

# Remove JetBrains Toolbox (if installed)
echo "➡ Removing JetBrains Toolbox config..."
rm -rf ~/Library/Application\ Support/JetBrains/Toolbox

echo "✅ Cleanup completed! You may want to empty your Trash."

