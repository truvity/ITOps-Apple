#!/bin/sh
set +e

#Set name Company
export Company="Truvity"

#Set group
Group="$1"

#Set program
Grammarly="On"
Grammarly_Group=("All")
1Password="On"
1Password_Group=("All")


#check brew
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	if [ $? -gt 0 ]; then text_slack="Error install Brew in $Company $(hostname)."; color='danger'; Slack_notification; exit 1; fi;
fi


if [ "$Grammarly" == "On" ]; then
	for val in "${Grammarly_Group[@]}"; do
    if [ "$val" == "$Group" ]; then
        /bin/sh Grammarly/Grammarly.sh

    fi
done
fi

if [ "$1Password" == "On" ]; then
	for val in "${1Password_Group[@]}"; do
    if [ "$val" == "$Group" ]; then
        /bin/sh 1Password/1Password.sh

    fi
done
fi





set -e
