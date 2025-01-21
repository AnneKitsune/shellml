#!/bin/sh

set -eo pipefail

./reset.sh 2> /dev/null
should_prompt=1
while true; do
    if [[ $should_prompt == 1 ]]; then
        echo "Your request, Mistress?"
        read -r user_prompt
        ./prompt.sh "$user_prompt"
    fi
    ./one_iter.sh
    #jq . /tmp/ai_output.json
    if [ -e /tmp/tool_response_0.json ]; then
        should_prompt=0
    else
        jq '.message.content' /tmp/ai_output.json
        should_prompt=1
    fi
done
