#File log
filelog="/tmp/detail3_log.txt"

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
set -x
# Check if xcode-select
if ! xcode-select -p &>/dev/null; then
	{
	xcode-select -r
    xcode-select --install
	xcode-select --install
	sleep 15
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
	fi
fi

set +x
