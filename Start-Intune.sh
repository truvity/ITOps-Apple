#!/bin/sh

cd /tmp/
curl -sL https://github.com/truvity/ITOps-Apple/archive/refs/heads/serenko.zip |  tar xz
chmod -R a+x  ITOps-Apple-serenko/
cd ITOps-Apple-serenko
/bin/sh 
/bin/sh Listprogramuser.sh Test