#!/bin/sh
i=0
tools=$(jq -c -r 'try .message.tool_calls[] catch empty' /tmp/ai_output.json) # | while read -r tool; do
if [ -z "$tools" ]; then
    exit 0
fi

while read -r tool; do
    echo "Tool request: $tool"

    # here you would determine the tool and execute. for now, mock the output.
    #[{"function":{"name":"get_current_weather","arguments":{"city":"new york"}}}]
    tool_name="$(echo "$tool" | jq -r '.function.name')"
    case "$tool_name" in
        "get_current_weather")
            city=$(echo "$tool" | jq -r '.function.arguments.city')
            read -p "Will run: wttr.in/$city. Press Enter to continue." </dev/tty
            #curl -s "wttr.in/$city?format=j1" > /tmp/weather_output.json
            #output="$(curl -s "wttr.in/$city?format=j1")" #json
            output="$(curl -s "wttr.in/$city?T")"
            #output="$(cat /tmp/weather_output.json)"
            #echo "Immediate output = $output"
            ;;
        "run_terminal")
            cmd=$(echo "$tool" | jq -r '.function.arguments.command')
            read -p "Will run: $cmd. Press Enter to continue." </dev/tty
            output="$(bash -c "$cmd")"
            ;;
        *)
            echo "Unknown tool requested."
            output="Error: Failed to find tool. Report this to the user."
            ;;
    esac

    #echo "Raw command output: $output"
    escaped_output="$(echo -n "$output" | jq -Rsar .)"
    echo "{\"role\": \"tool\", \"content\": $escaped_output }" > /tmp/tool_response_$i.json
    i=$((i + 1))
    rm /tmp/user_request.json
done <<< "$tools"
