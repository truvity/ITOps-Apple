#!/bin/zsh

#check processor_type
processor_type=$(uname -p)


if [ "$processor_type" = "i386" ] || [ "$processor_type" = "x86_64" ]; then
    exit 0;
fi

set -x
#File log
filelog="/tmp/detail_log.txt"

function Slack_notification() {
# Send notification messages to a Slack channel by using Slack webhook
# 
# input parameters:
#   color = good; warning; danger
#   $text_slack - main text
######
	local message="{
		\"channel\": \"${channel}\",
		\"attachments\": [
		{
		\"text\": \"$text_slack\",
		\"color\": \"$color\"
		}
	]
	}"
	# Send message
	curl -X POST \
     -H "Authorization: Bearer ${SLACK_API_TOKEN}" \
     -H 'Content-type: application/json' \
     --data "$message" \
     https://slack.com/api/chat.postMessage
	 
	 sleep 1
	 
	# Send file
	curl -F file=@${filelog} \
     -F channels=${channel} \
     -H "Authorization: Bearer ${SLACK_API_TOKEN}" \
     https://slack.com/api/files.upload
	 
	 sleep 1
}

# Check if xcode-select
if ! xcode-select -p &>/dev/null; then
	{
	uname -a
    xcode-select --install
	touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
	softwareupdate -l | grep "Command Line Tools" | awk NR==1 | cut -d ' ' -f 3-
	local name_program_xcode=$(softwareupdate -l | grep "Command Line Tools" | awk NR==1 | cut -d ' ' -f 3-)
	echo $name_program_xcode
	softwareupdate -i "$name_program_xcode"
	} > ${filelog} 2>&1
	if xcode-select -p &>/dev/null; then
		text_slack="Xcode-select is installed in $Company $(hostname)." 
		color='good'
		Slack_notification
    	else
		text_slack="Error installing Xcode-select in $Company $(hostname)." 
		color='danger'
		Slack_notification
		exit 0
	fi
fi


#Check Homebrew
source /etc/zprofile
cd /tmp/
Brew_file="/opt/homebrew/bin/brew"

#Check NOPASSWD for sudo
sudo grep -q '%admin ALL=(ALL) NOPASSWD:SETENV: /opt/homebrew/\*/\* \*, /usr/sbin/installer -pkg /opt/homebrew/\*, /bin/launchctl list \*' /etc/sudoers || echo '%admin ALL=(ALL) NOPASSWD:SETENV: /opt/homebrew/*/* *, /usr/sbin/installer -pkg /opt/homebrew/*, /bin/launchctl list *' | sudo tee -a /etc/sudoers > /dev/null
sudo grep -q '%admin ALL=(ALL) NOPASSWD:SETENV: /usr/sbin/installer -pkg /usr/local/Caskroom/\*' /etc/sudoers || echo '%admin ALL=(ALL) NOPASSWD:SETENV: /usr/sbin/installer -pkg /usr/local/Caskroom/*' | sudo tee -a /etc/sudoers > /dev/null

#check ownership and permissions
perm=$(ls -ld /opt/homebrew | awk '{print $1}')
group=$(ls -ld /opt/homebrew | awk '{print $4}')
if [ "$perm" != "drwxrwxr-x" ]; then chmod -R 775 /opt/homebrew; fi
if [ "$group" != "admin" ]; then chown -R :admin /opt/homebrew; fi


if ! command -v brew >/dev/null 2>&1; then
	{
	if [ -f "$Brew_file" ]; then
		#brew install option 1
		uname -a
		grep -q 'eval "\$(/opt/homebrew/bin/brew shellenv)"' /etc/zprofile || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' | sudo tee -a /etc/zprofile > /dev/null
  		source /etc/zprofile
    	chown -R :admin /opt/homebrew
		chmod -R 775 /opt/homebrew
		ls -ld /opt/homebrew | awk '{print $1}'
		ls -ld /opt/homebrew | awk '{print $4}'
		cat /etc/zprofile
        export message="payload={\"attachments\":[{\"text\":\"brew install option 1 in $Company $(hostname)\",\"color\":\"$color\"}]}"
		curl -X POST --data-urlencode "$message" ${SLACK_WEBHOOK_URL}
	else
		#brew install option 2
		uname -a
	    json=$(curl -s https://api.github.com/repos/Homebrew/brew/releases/latest)
		download_url=$(echo "$json" | grep -o '"browser_download_url": "[^"]*"' | head -1 | cut -d '"' -f 4)
  		rm Homebrew-latest.pkg
		curl -L -o Homebrew-latest.pkg "$download_url"
		installer -pkg Homebrew-latest.pkg -target /
  		chown -R :admin /opt/homebrew
		chmod -R 775 /opt/homebrew
		grep -q 'eval "\$(/opt/homebrew/bin/brew shellenv)"' /etc/zprofile || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' | sudo tee -a /etc/zprofile > /dev/null
  		source /etc/zprofile
		ls -ld /opt/homebrew | awk '{print $1}'
		ls -ld /opt/homebrew | awk '{print $4}'
		cat /etc/zprofile
  		export message="payload={\"attachments\":[{\"text\":\"brew install option 2 in $Company $(hostname)\",\"color\":\"$color\"}]}"
		curl -X POST --data-urlencode "$message" ${SLACK_WEBHOOK_URL}
	fi
	} > ${filelog} 2>&1
	
	# Check install
 	source /etc/zprofile
	if [ -f "$Brew_file" ] && command -v brew >/dev/null 2>&1; then
		text_slack="Brew is installed in $Company $(hostname)." 
		color='good'
		Slack_notification
    	else
		text_slack="Error installing Brew in $Company $(hostname)." 
		color='danger'
		Slack_notification	
	fi

fi

set +x