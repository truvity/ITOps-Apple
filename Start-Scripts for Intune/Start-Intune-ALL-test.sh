#!/bin/zsh

#Change company
export Company="Truvity"
#Change group
export Group="All"
#Change webhook
export SLACK_WEBHOOK_URL=""

cd /tmp/
curl -sL https://github.com/truvity/ITOps-Apple/archive/refs/heads/test.zip |  tar xz
chmod -R a+x  ITOps-Apple-test/
cd ITOps-Apple-test
/bin/sh Install-Program-Homebrew.sh
sleep 20
rm -rf /tmp/ITOps-Apple-test