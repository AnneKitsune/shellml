#!/bin/sh
# Removes all temp files / context
rm /tmp/ai_output.json
rm /tmp/ai_input.json
rm /tmp/user_request.json
rm /tmp/tool_response_*.json
rm /tmp/ai_last_output.json
exit 0
