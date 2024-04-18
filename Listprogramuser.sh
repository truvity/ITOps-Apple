#!/bin/sh
set +e

#Set name Company
export Company="Truvity"

#Set group
Group="$1"

#Set program
Grammarly="On"
Grammarly_Group=("All")


if [ "$Grammarly" == "On" ]; then
	for val in "${Grammarly_Group[@]}"; do
    if [ "$val" == "$Group" ]; then
        /bin/sh Grammarly/Grammarly.sh

    fi
done
fi







set -e
