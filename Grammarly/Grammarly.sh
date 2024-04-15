#!/bin/sh


app_path="/Applications/Grammarly Desktop.app/Contents/Info.plist"

# Check install
if [ ! -f "$app_path" ]; then
echo "Файл не существует."
cat /Applications/Grammarly\ Desktop.app/Contents/Info.plist
cat $app_path
cd /tmp/
curl -O https://download-mac.grammarly.com/Grammarly.dmg > Grammarly.dmg
hdiutil attach Grammarly.dmg
open /Volumes/Grammarly/Grammarly\ Installer.app
sleep 20
hdiutil detach /Volumes/Grammarly
else
    echo "Файл существует."
fi


