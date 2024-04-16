#!/bin/sh
export SLACK_WEBHOOK_URL=""
cd /tmp/
curl -sL https://github.com/truvity/ITOps-Apple/archive/refs/heads/test.zip |  tar xz
chmod -R a+x  ITOps-Apple-test/
cd ITOps-Apple-test
/bin/sh Listprogramuser-test.sh