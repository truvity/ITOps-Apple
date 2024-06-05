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



#Check Homebrew
cd /tmp/
Brew_file="/opt/homebrew/bin/brew"
if ! command -v brew >/dev/null 2>&1; then
	if [ -f "$Brew_file" ]; then
		grep -q 'eval "\$(/opt/homebrew/bin/brew shellenv)"' /etc/zprofile || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' | sudo tee -a /etc/zprofile > /dev/null
  		source /etc/zprofile
	else
	    json=$(curl -s https://api.github.com/repos/Homebrew/brew/releases/latest)
		download_url=$(echo "$json" | grep -o '"browser_download_url": "[^"]*"' | head -1 | cut -d '"' -f 4)
		curl -L -o Homebrew-latest.pkg "$download_url"
		installer -pkg Homebrew-latest.pkg -target /
		grep -q 'eval "\$(/opt/homebrew/bin/brew shellenv)"' /etc/zprofile || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' | sudo tee -a /etc/zprofile > /dev/null
		source /etc/zprofile
	fi
	# Check install
	if [ -f "$Brew_file" ]; then
		text_slack="Brew is installed in $Company $(hostname)." 
		color='good'
		Slack_notification		
    else
		text_slack="Error installing Brew in $Company $(hostname)." 
		color='danger'
		Slack_notification	
	fi
	
	source /etc/zprofile

fi
