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

app_path="/Applications/1Password.app/Contents/Info.plist"

# Check install
if [ ! -f "$app_path" ]; then
	cd /tmp/
	# Download 1Password
	curl -sL https://downloads.1password.com/mac/1Password.zip | tar xz
	#if [ $? -gt 0 ]; then text_slack="Error downloading 1Password in $Company $(hostname)."; color='danger'; Slack_notification; exit 1; fi;
	# Install 1Password
	open /Volumes/1Password/1Password\ Installer.app
	sleep 20
	# Remove temp files
	rm /tmp/1Password.dmg
	# Check install
	if [ -f "$app_path" ]; then
		text_slack="1Password is installed in $Company $(hostname)." 
		color='good'
		Slack_notification		
    else
		text_slack="Error installing 1Password in $Company $(hostname)." 
		color='danger'
		Slack_notification	
	fi
fi


