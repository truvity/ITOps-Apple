#!/bin/zsh
set +e


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


#Set name Company
export Company="Truvity"

#Set group
Group="$1"

#Set program
Grammarly="On";
Grammarly_Group=("All");
_1Password="On";
_1Password_Group=("All");


#check brew
if ! command -v brew &>/dev/null; then
    source /etc/zprofile
	if ! command -v brew &>/dev/null; then
	text_slack="Brew didn't install in $Company $(hostname)."; color='danger'; Slack_notification; exit 1;
	fi
fi

#check Grammarly
if [ "$Grammarly" == "On" ]; then
	for val in "${Grammarly_Group[@]}"; do
    if [ "$val" == "$Group" ]; then
        /bin/sh Grammarly/Grammarly.sh

    fi
done
fi

#check 1password
if [ "$_1Password" == "On" ]; then
	for val in "${_1Password_Group[@]}"; do
    if [ "$val" == "$Group" ]; then
        /bin/sh 1Password/1Password.sh

    fi
done
fi





set -e
