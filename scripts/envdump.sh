#!/bin/bash

#Author: github/hammad-013
#Purpose: Filter, format and save environment variables
#Modification Date: 18-07-25

#default values
filter=""
save=""
json=false

while [[ "$#" -gt 0 ]]; do
	case "$1" in
		--filter)
			filter="$2"
			shift 2
			;;
		--save)
			save="$2"
			if [[ -d "$save" ]]; then
				echo "Directory passed instead of filename"
				exit 1
			fi
			shift 2
			;;
		--json)
			json=true
			shift
			;;
		*)
			echo "Unknown argument: $1"
			exit 1
			;;
	esac
done

	if [[ -n "$filter" ]]; then
		variables=$(env | grep -i "$filter")
	else
		variables=$(env)
	fi

	if [[ "$json" = "true" ]]; then
		output="{"
		while IFS='=' read -r key val; do
			output+="\"$key\":\"$val\","
		done <<< "$variables"
		output="${output%,}}"
	else
		output="$variables"
	fi
	if [[ -n "$save" ]]; then
		echo "$output" > "$save"
		echo "Output saved to $save"
	else
		echo "$output"
	fi
	exit 0

