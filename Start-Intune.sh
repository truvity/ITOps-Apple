#!/bin/sh
export SLACK_WEBHOOK_URL=""
cd /tmp/
curl -sL https://github.com/truvity/ITOps-Apple/archive/refs/heads/master.zip |  tar xz
chmod -R a+x  ITOps-Apple-master/
cd ITOps-Apple-master
/bin/sh Listprogramuser.sh