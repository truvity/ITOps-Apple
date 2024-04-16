#!/bin/sh
set +e

#Set group
Group="$1"

#Set program
Grammarly="On"



if [ "$Grammarly" == "On" ] && [ "$Group" == "Test" ]; then
    /bin/sh Grammarly/Grammarly.sh
fi




rm -rf /tmp/ITOps-Apple-serenko


set -e