#!/bin/bash

### INSERT YOUR CODE BELOW ###

# Set participant as a variable, setting this to variable 1 means that it can be entered as the first argument
# when calling the script. For example, executing "/bind/scripts/convert.sh IBRAIN002" will set IBRAIN002 as
# the participant.
Participant=$1

dcm2bids \
-d /bind/raw/$Participant \
-p $Participant \
-c /bind/scripts/dcm2bids.json \
-o /bind/bids

### DO NOT MODIFY THE LINES BELOW ###
uname -a > info_host.txt
/usr/bin/env > info_env.txt
ls / > info_fs.txt
mount |grep ^/dev/ | grep -v /etc > info_volumes.txt
