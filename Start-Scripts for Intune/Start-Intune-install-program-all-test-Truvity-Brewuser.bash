#!/bin/zsh

su - brewuser  << 'EOF'
#Change company
export Company="Truvity"

#Change group
export Group="All"

#Change webhook
export SLACK_WEBHOOK_URL=""

#Change Api Token
export SLACK_API_TOKEN=""

#channel Slack
export channel=""

#tree github
export tree_github="test"

cd /tmp/
curl -sL https://github.com/truvity/ITOps-Apple/archive/refs/heads/${tree_github}.zip |  tar xz
chmod -R a+x  ITOps-Apple-${tree_github}/
cd ITOps-Apple-${tree_github}
source List-Program.sh
source Install-Program-Homebrew-brewuser.sh
sleep 5
rm -rf /tmp/ITOps-Apple-${tree_github}
EOF