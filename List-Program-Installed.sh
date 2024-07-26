#!/bin/zsh


set -x

#File log
filelog="/tmp/list_programs.txt"

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

{
uname -a
system_profiler SPHardwareDataType | grep "Serial Number (system)"
dscl . list /Users | grep -v '^_'
mdfind "kMDItemContentType == 'com.apple.application-bundle'" | grep -v "^/System/"
curl ipinfo.io
speedtest-cli
}  > ${filelog} 2>&1

set +x

text_slack="List programs in $Company $(hostname)." 
Slack_notification