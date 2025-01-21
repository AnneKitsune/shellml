#!/bin/sh
# Runs one iteration of the ai.
# If /tmp/ai_input.json does not exist, copies template to that file.
# Uses the input from /tmp/user_request.json, which gets appended to /tmp/ai_input.json.
# Executes ai with new /tmp/ai_input.json
# Writes ai output to /tmp/ai_output.json

set -eo pipefail

[ -e /tmp/ai_input.json ] || cp ./request_template.json /tmp/ai_input.json
#[ -e /tmp/user_request.json ] || { echo "No user request in /tmp/user_request.json!"; exit 1; }

shopt -s nullglob
./append_message.sh /tmp/ai_input.json /tmp/ai_last_output.json* /tmp/tool_response_*.json /tmp/user_request.json* > /tmp/ai_input2.json
shopt -u nullglob

mv /tmp/ai_input2.json /tmp/ai_input.json

./request.sh "$(cat /tmp/ai_input.json)" > /tmp/ai_output.json

[ -e /tmp/tool_response_0.json ] && rm /tmp/tool_response_*.json
jq -r '.message' /tmp/ai_output.json > /tmp/ai_last_output.json

./handle_output.sh
