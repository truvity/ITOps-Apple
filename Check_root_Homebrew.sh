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
source /etc/zprofile
cd /tmp/
Brew_file="/opt/homebrew/bin/brew"

if ! command -v brew >/dev/null 2>&1; then
	if [ -f "$Brew_file" ]; then
		grep -q 'eval "\$(/opt/homebrew/bin/brew shellenv)"' /etc/zprofile || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' | sudo tee -a /etc/zprofile > /dev/null
  		source /etc/zprofile
    		chown -R :admin /opt/homebrew
		chmod -R 775 /opt/homebrew
                export message="payload={\"attachments\":[{\"text\":\"test-serenko option 1\",\"color\":\"$color\"}]}"
		curl -X POST --data-urlencode "$message" ${SLACK_WEBHOOK_URL}
	else
	    json=$(curl -s https://api.github.com/repos/Homebrew/brew/releases/latest)
		download_url=$(echo "$json" | grep -o '"browser_download_url": "[^"]*"' | head -1 | cut -d '"' -f 4)
  		rm Homebrew-latest.pkg
		curl -L -o Homebrew-latest.pkg "$download_url"
		installer -pkg Homebrew-latest.pkg -target /
  		chown -R :admin /opt/homebrew
		chmod -R 775 /opt/homebrew
		grep -q 'eval "\$(/opt/homebrew/bin/brew shellenv)"' /etc/zprofile || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' | sudo tee -a /etc/zprofile > /dev/null
		source /etc/zprofile
  		export message="payload={\"attachments\":[{\"text\":\"test-serenko option 2\",\"color\":\"$color\"}]}"
		curl -X POST --data-urlencode "$message" ${SLACK_WEBHOOK_URL}
	fi
	# Check install
	if [ -f "$Brew_file" ] && command -v brew >/dev/null 2>&1; then
		text_slack="Brew is installed in $Company $(hostname) $(whoami)." 
		color='good'
		Slack_notification		
    	else
		text_slack="Error installing Brew in $Company $(hostname) $(whoami)." 
		color='danger'
		Slack_notification	
	fi

fi
