#!/bin/zsh

#Change company
export Company="Finerbase"


#Change webhook
export SLACK_WEBHOOK_URL=""

#Change Api Token
export SLACK_API_TOKEN=""

#channel Slack
export channel=""

#tree github
export tree_github="master"

cd /tmp/
curl -sL https://github.com/truvity/ITOps-Apple/archive/refs/heads/${tree_github}.zip |  tar xz
chmod -R a+x  ITOps-Apple-${tree_github}/
cd ITOps-Apple-${tree_github}
/bin/zsh Check_root_Homebrew.sh
sleep 20
rm -rf /tmp/ITOps-Apple-${tree_github}