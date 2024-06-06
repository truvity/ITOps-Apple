#!/bin/zsh

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
	#Install Grammarly
	brew install --cask grammarly-desktop --force
	if [ $? -gt 0 ]; then text_slack="Error of brew installing Grammarly in $Company $(hostname)."; color='danger'; Slack_notification; exit 1; fi;
	
	# Check install
	if [ -f "$app_path" ]; then
		text_slack="Grammarly is installed in $Company $(hostname)." 
		color='good'
		Slack_notification		
    else
		text_slack="Error installing Grammarly in $Company $(hostname)." 
		color='danger'
		Slack_notification	
	fi
fi


