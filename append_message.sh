#!/bin/sh
# appends the message from the second file to the first file that has the array of messages.
#jq -r '.messages[.messages| length] |= input' $1 $2
#echo "${@:2}"
jq -r '.messages += [inputs]' "$1" ${@:2}

