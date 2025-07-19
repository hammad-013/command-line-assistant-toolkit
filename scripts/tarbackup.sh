#!/bin/bash

#Author: github/hammad-013
#Purpose: backup folders with compression, logs, and excludes
#Modification Date: 18-07-25

#default values
exclude_flag=false
src="."
output_archive=$(date "+%d-%m-%y")
log=false
ex_items_str="0"
while [[ "$#" -gt 0 ]]; do
	case "$1" in
		-s)
			src="$2"
			src=$(realpath "$src")
			output_archive=$(echo "$src-$output_archive" | cut -c2-)
			output_archive=${output_archive//\//-}
			if [[ ! -d "$src" ]]; then
				echo "Source directory is not valid"
				exit 1
			fi
			shift 2
			;;
		-o)
			output_archive="$2"
			shift 2
			;;
		--exclude)
			exclude_flag=true
			ex_items_str="$2"
			IFS=',' read -ra exclude_items <<< "$2"
			shift 2
			;;
		--log)
			log=true
			shift
			;;
		*)
			echo "unknown argument or option"
			exit 1
			;;
	esac
done
command="tar -czf $output_archive.tar.gz"
	if [[ "$exclude_flag" = "true" ]]; then
		for i in "${exclude_items[@]}"; do
			if [[ "$i" = "--log" || "$i" = "-o" || "$i" = "-s" ]]; then
				echo "Invalid argument passing"
				exit 1
			fi
			command+=" --exclude='$i'"
		done
	fi
command+=" -C $src ."
echo "$command"
eval "$command"
success="$?"
	if [[ "$success" = 0 ]]; then
		echo "Directory is archived successfully."
		success="Yes"
	else
		success="No"
	fi
	if [[ "$log" = "true" ]]; then
		log_output=("Time: $(date "+%H:%M")" "Date: $(date "+%d-%m-%y")" "Source directory: $src" "Archive Name: $output_archive" "Excluded: $ex_items_str" "Archive size: $(du -h "$output_archive.tar.gz" | awk '{ print $1 }')" "Success: $success")
		echo "---------------------" >> "backup.log"
		for i in "${log_output[@]}"; do
			echo "$i" >> "backup.log"
		done
		echo "---------------------" >> "backup.log"
	fi
exit 0




