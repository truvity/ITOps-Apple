#!/bin/zsh
set +e

# Function Slack notification
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


# Function to install programs via Homebrew
install_programs() {
    local programs=("$@")

    for program_name in "${programs[@]}"; do
        if ! brew list --cask "$program_name" &>/dev/null; then
            echo "Installing $program_name..."
            brew install --cask "$program_name" --force
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
		# List of programs to install via Homebrew
		programs=(
			google-chrome
			slack
			1password
		# Add other programs here
		)
		#Install Programs
		install_programs "${programs[@]}"
	fi	
	
fi




set -e
