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


#Check jq
cd /tmp/
if ! command -v jq >/dev/null 2>&1; then
    ARCH=$(uname -m)
	if [[ "$ARCH" == "x86_64" ]]; then
    # Check Intel
		if sysctl -n sysctl.proc_translated &> /dev/null; then
			# Apple Silicon
			URL="https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-macos-arm64"
		else
			# Native Intel
			URL="https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-amd64"
		fi
	elif [[ "$ARCH" == "arm64" ]]; then
		#Apple Silicon
		URL="https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-macos-arm64"
	fi
    
	curl -Lo jq "$URL"
	if [ $? -gt 0 ]; then text_slack="Error install jq in $Company $(hostname)."; color='danger'; Slack_notification; exit 1; fi;
	chmod +x jq
	mv jq /usr/local/bin/
	Jq_file="/usr/local/bin/jq"
	# Check install
	if [ -f "$Jq_file" ]; then
		text_slack="Jq is installed in $Company $(hostname)." 
		color='good'
		Slack_notification		
    else
		text_slack="Error installing jq in $Company $(hostname)." 
		color='danger'
		Slack_notification	
	fi
fi


#Check Homebrew
cd /tmp/
Brew_file="/opt/homebrew/bin/brew"
if ! command -v brew >/dev/null 2>&1; then
	if [ -f "$Brew_file" ]; then
		grep -q 'eval "\$(/opt/homebrew/bin/brew shellenv)"' /etc/zprofile || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' | sudo tee -a /etc/zprofile > /dev/null
	else
		curl -L -o Homebrew-latest.pkg "$(curl -s https://api.github.com/repos/Homebrew/brew/releases/latest | jq -r '.assets[0].browser_download_url')"
		installer -pkg Homebrew-latest.pkg -target /
		grep -q 'eval "\$(/opt/homebrew/bin/brew shellenv)"' /etc/zprofile || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' | sudo tee -a /etc/zprofile > /dev/null
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