#!/bin/sh

function Slack_notification() {
# Send notification messages to a Slack channel by using Slack webhook
# 
# input parameters:
#   color = good; warning; danger
#   $text_slack - main text
######
  local message="payload={\"attachments\":[{\"text\":\"$text_slack\",\"color\":\"$color\"}]}"
  curl -X POST --data-urlencode "$message" ${SLACK_WEBHOOK_URL}
}

app_path="/Applications/Grammarly Desktop.app/Contents/Info.plist"

# Check install
if [ ! -f "$app_path" ]; then
	cd /tmp/
	# Download grammarly
	curl -O https://download-mac.grammarly.com/Grammarly.dmg > Grammarly.dmg
	if [ $? -gt 0 ]; then text_slack="Error downloading Grammarly in $(hostname)."; color='danger'; Slack_notification; exit 1; fi;
	# Install Grammarly
	hdiutil attach Grammarly.dmg
	open /Volumes/Grammarly/Grammarly\ Installer.app
	sleep 20
	hdiutil detach /Volumes/Grammarly
	# Remove temp files
	rm /tmp/Grammarly.dmg
	# Check install
	if [ -f "$app_path" ]; then
		text_slack="Grammarly is installed in $(hostname)." 
		color='good'
		Slack_notification		
    else
		text_slack="Error installing Grammarly in $(hostname)." 
		color='danger'
		Slack_notification	
	fi
fi


