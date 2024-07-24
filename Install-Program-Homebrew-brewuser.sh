#!/bin/zsh

#check processor_type
processor_type=$(uname -p)


if [ "$processor_type" = "i386" ] || [ "$processor_type" = "x86_64" ]; then
    exit 0;
fi

sudo chmod -R 775 /opt/homebrew
sudo chown -R :admin /opt/homebrew

set -x

source /etc/zprofile

sudo git config --global --add safe.directory /opt/homebrew
sudo git config --global --add safe.directory /opt/homebrew/Library/Taps/homebrew/homebrew-bundle


#File log
filelog="/tmp/detail_program_log.txt"

sudo rm ${filelog}


echo "Programs to install: ${programs_gui[@]} ${programs_cli[@]} "
# Function Slack notification
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
	 
	# Send file
	curl -F file=@${filelog} \
     -F channels=${channel} \
     -H "Authorization: Bearer ${SLACK_API_TOKEN}" \
     https://slack.com/api/files.upload
	 
	 sleep 1
}


# Function to install gui-programs via Homebrew
install_programs_gui() {
    local programs_gui=("$@")

    for program_name in "${programs_gui[@]}"; do
        if ! brew list --cask "$program_name" &>/dev/null; then
			{
			cd /tmp/
            echo "Installing $program_name..."
            brew install --cask "$program_name" --force --debug
			}  > ${filelog} 2>&1
				if [ $? -gt 0 ]; then 
					text_slack="Error of brew installing $program_name in $Company $(hostname)."
					color='danger'
					Slack_notification
				else
					text_slack="Successfully installed $program_name in $Company $(hostname)."
					color='good'
					Slack_notification
				fi
		elif [ $(date +%u) -ge 2 ] && [ $(date +%u) -le 4 ] && [ -z "$(pmset -g assertions | grep -i 'display is on')" ]; then
			{
			cd /tmp/
            echo "Update $program_name..."
			brew update
            brew upgrade --cask "$program_name" --debug
			}  > ${filelog} 2>&1
				if [ $? -gt 0 ]; then 
					text_slack="Error of brew updating $program_name in $Company $(hostname)."
					color='danger'
					Slack_notification
     			elif ! grep -q "the latest version is already installed" "${filelog}"; then
					text_slack="Successfully updated $program_name in $Company $(hostname)."
					color='good'
					Slack_notification
				fi
        else
            echo "$program_name is already installed."
        fi
    done
}

# Function to install cli-programs via Homebrew
install_programs_cli() {
    local programs_cli=("$@")

    for program_name in "${programs_cli[@]}"; do
        if ! brew list "$program_name" &>/dev/null; then
			{
			cd /tmp/
            echo "Installing $program_name..."
            brew install "$program_name" --force --debug
			}  > ${filelog} 2>&1
				if [ $? -gt 0 ]; then 
					text_slack="Error of brew installing $program_name in $Company $(hostname)."
					color='danger'
					Slack_notification
				else
					text_slack="Successfully installed $program_name in $Company $(hostname)."
					color='good'
					Slack_notification
				fi
		elif [ $(date +%u) -ge 2 ] && [ $(date +%u) -le 4 ] && [ -z "$(pmset -g assertions | grep -i 'display is on')" ]; then
			{
			cd /tmp/
            echo "Update $program_name..."
			brew update
            brew upgrade "$program_name" --debug
			}  > ${filelog} 2>&1
				if [ $? -gt 0 ]; then 
					text_slack="Error of brew updating $program_name in $Company $(hostname)."
					color='danger'
					Slack_notification
				elif ! grep -q "already installed" "${filelog}"; then
					text_slack="Successfully updated $program_name in $Company $(hostname)."
					color='good'
					Slack_notification
				fi
        else
            echo "$program_name is already installed."
        fi
    done
}




#check brew
if ! command -v brew &>/dev/null; then
    source /etc/zprofile
	if ! command -v brew &>/dev/null; then
	text_slack="Brew didn't install in $Company $(hostname)."; color='danger'; Slack_notification; exit 0;
	fi
fi

#check Company and group and install program
cd /tmp/
brew update
# Check if programs_gui array is empty
if [ ${#programs_gui[@]} -eq 0 ]; then
  echo "No GUI programs to install."
else
  install_programs_gui "${programs_gui[@]}"
fi

# Check if programs_cli array is empty
if [ ${#programs_cli[@]} -eq 0 ]; then
  echo "No CLI programs to install."
else
  install_programs_cli "${programs_cli[@]}"
fi



set +x
