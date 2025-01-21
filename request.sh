#!/bin/sh
set -eo pipefail
curl -s -X POST http://localhost:11434/api/chat -d "$1"
