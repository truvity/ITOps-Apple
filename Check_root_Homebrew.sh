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
  sleep 1
  curl -F file=@/tmp/detail_log.txt \
       -F "initial_comment=${text_slack}" \
       -F channels=${channel} \
       -H "Authorization: Bearer ${SLACK_API_TOKEN}" \
       https://slack.com/api/files.upload
}


#Check Homebrew
source /etc/zprofile
cd /tmp/
Brew_file="/opt/homebrew/bin/brew"
#Check NOPASSWD for sudo
sudo grep -q '%admin ALL=(ALL) NOPASSWD:SETENV: /opt/homebrew/\*/\* \*, /usr/sbin/installer -pkg /opt/homebrew/\*, /bin/launchctl list \*' /etc/sudoers || echo '%admin ALL=(ALL) NOPASSWD:SETENV: /opt/homebrew/*/* *, /usr/sbin/installer -pkg /opt/homebrew/*, /bin/launchctl list *' | sudo tee -a /etc/sudoers > /dev/null

#check ownership and permissions
perm=$(ls -ld /opt/homebrew | awk '{print $1}')
group=$(ls -ld /opt/homebrew | awk '{print $4}')
if [ "$perm" != "drwxrwxr-x" ]; then chmod -R 775 /opt/homebrew; fi
if [ "$group" != "admin" ]; then chown -R :admin /opt/homebrew; fi


if ! command -v brew >/dev/null 2>&1; then
	{
	if [ -f "$Brew_file" ]; then
		#brew install option 1
		grep -q 'eval "\$(/opt/homebrew/bin/brew shellenv)"' /etc/zprofile || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' | sudo tee -a /etc/zprofile > /dev/null
  		source /etc/zprofile
    	chown -R :admin /opt/homebrew
		chmod -R 775 /opt/homebrew
        export message="payload={\"attachments\":[{\"text\":\"brew install option 1\",\"color\":\"$color\"}]}"
		curl -X POST --data-urlencode "$message" ${SLACK_WEBHOOK_URL}
	else
		#brew install option 2
	    json=$(curl -s https://api.github.com/repos/Homebrew/brew/releases/latest)
		download_url=$(echo "$json" | grep -o '"browser_download_url": "[^"]*"' | head -1 | cut -d '"' -f 4)
  		rm Homebrew-latest.pkg
		curl -L -o Homebrew-latest.pkg "$download_url"
		installer -pkg Homebrew-latest.pkg -target /
  		chown -R :admin /opt/homebrew
		chmod -R 775 /opt/homebrew
		grep -q 'eval "\$(/opt/homebrew/bin/brew shellenv)"' /etc/zprofile || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' | sudo tee -a /etc/zprofile > /dev/null
  		source /etc/zprofile
  		export message="payload={\"attachments\":[{\"text\":\"brew install option 2\",\"color\":\"$color\"}]}"
		curl -X POST --data-urlencode "$message" ${SLACK_WEBHOOK_URL}
	fi
	} > /tmp/detail_log.txt 2>&1
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

rm /tmp/detail_log.txt