#!/bin/zsh

set -x

source /etc/zprofile

#File log
filelog="/tmp/detail_program_log.txt"


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
            brew install --cask "$program_name" --force
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
            brew install "$program_name" --force
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
        else
            echo "$program_name is already installed."
        fi
    done
}

#Set name Company
Company=$Company

#Set group
Group=$Group


#check brew
if ! command -v brew &>/dev/null; then
    source /etc/zprofile
	if ! command -v brew &>/dev/null; then
	text_slack="Brew didn't install in $Company $(hostname)."; color='danger'; Slack_notification; exit 1;
	fi
fi

#check Company and group and install program

if [ "$Company" = "Truvity" ]; then

	if [ "$Group" = "All" ]; then
	
		# List of programs-gui to install via Homebrew
		programs_gui=(
			google-chrome
			slack
			1password
			telegram-desktop
			zoom
			google-drive
			anydesk
		# Add other programs here
		)
		#Install Programs gui
		install_programs_gui "${programs_gui[@]}"
		
		
		# List of programs-cli to install via Homebrew
		programs_cli=(
			speedtest-cli
		# Add other programs here
		)
		#Install Programs cli
		install_programs_cli "${programs_cli[@]}"
	fi	
	
fi


if [ "$Company" = "Finerbase" ]; then

	if [ "$Group" = "All" ]; then
	
		# List of programs-gui to install via Homebrew
		programs_gui=(
			google-chrome
			slack
			1password
			telegram-desktop
			zoom
			google-drive
			anydesk
		# Add other programs here
		)
		#Install Programs gui
		install_programs_gui "${programs_gui[@]}"
		
		
		# List of programs-cli to install via Homebrew
		programs_cli=(
			speedtest-cli
		# Add other programs here
		)
		#Install Programs cli
		install_programs_cli "${programs_cli[@]}"
	fi	
	
fi

if [ "$Company" = "Datagrid" ]; then

	if [ "$Group" = "All" ]; then
	
		# List of programs-gui to install via Homebrew
		programs_gui=(
			google-chrome
			slack
			1password
			telegram-desktop
			zoom
			google-drive
			anydesk
		# Add other programs here
		)
		#Install Programs gui
		install_programs_gui "${programs_gui[@]}"
		
		
		# List of programs-cli to install via Homebrew
		programs_cli=(
			speedtest-cli
		# Add other programs here
		)
		#Install Programs cli
		install_programs_cli "${programs_cli[@]}"
	fi	
	
fi

set +x
