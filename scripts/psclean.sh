#!/bin/bash

#Author: github/hammad-013
#Purpose: search and kill processes interactively
#Modification Date: 19-07-25

#default
proc_name=""
confirm=false
top=false
kill_all=false

while [[ "$#" -gt 0 ]]; do
	case "$1" in
		--name)
			proc_name="$2"
			if [[ -z "$proc_name" ]]; then
				echo "Error: Please provide --name <pattern>."
				exit 1
			fi
			shift 2
			;;
		--safe)
			confirm=true
			shift
			;;
		--top)
			top=true
			shift
			;;
		--kill-all)
			kill_all=true
			shift
			;;
		*)
			echo "unknown argument passed"
			exit 1
			;;
	esac
done
this_pid=$$
script_name=$(basename "$0")
	if [[ "$top" = "true" ]]; then
		processes=$(ps -eo user,pid,%cpu,time,stat,comm --sort=%cpu | grep -i "[${proc_name:0:1}]${proc_name:1}" | grep -v "$script_name" | grep -v "$this_pid")
	else
		processes=$(ps -eo user,pid,%cpu,time,stat,comm | grep -i "[${proc_name:0:1}]${proc_name:1}" | grep -v "$script_name" | grep -v "$this_pid")
	fi
	if [[ -z "$processes" ]]; then
		echo "No matching process found for \"$proc_name\""
		exit 1
	fi
	echo "Matching processes: [USER PID CPU-USAGE STATUS COMM]"
	echo "$processes" | nl
	while read -r line; do
		pid=$(echo "$line" | awk '{ print $2 }')
		comm=$(echo "$line" | awk '{ print $6 }')
		if [[ "$kill_all" = "true" ]]; then
			echo "killing PID [$pid : $comm]"
			kill -9 "$pid"
		elif [[ "$confirm" = "true" ]]; then
			echo "kill PID [$pid : $comm]"
			read -r confirm_flag < /dev/tty
			if [[ "$confirm_flag" = "y" || "$confirm_flag" = "Y" ]]; then
				kill -9 "$pid"
				echo "killed [$pid : $comm]"
			else
				echo "skipped [$pid : $comm]"
			fi
		fi
	done <<< "$processes"

exit 0
