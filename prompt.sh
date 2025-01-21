#!/bin/sh
# Turns argument $1 into a user prompt for the next ai iteration.

echo "{\"role\": \"user\", \"content\": \"$1\" }" > /tmp/user_request.json
