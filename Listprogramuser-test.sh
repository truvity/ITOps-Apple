#!/bin/sh
set +e

#Set group
Group="$1"

#Set program
Grammarly="On"



if [ "$Grammarly" == "On" ]; then
    /bin/sh Grammarly/Grammarly.sh
fi







set -e
rm -rf /tmp/ITOps-Apple-test