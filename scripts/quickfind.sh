#!/bin/bash

#Author: github/hammad-013
#Purpose: Search for files/directories using patterns
#Modification Date: 18-07-25

#default values
pattern="*"
type="f"
directory="."
count_only=false
open=false
delete=false
size_flag=false

#argument parsing
while [[ $# -gt 0 ]]; do
	case "$1" in
		-p)
			pattern="$2"
			shift 2
			;;
		-t)
			type="$2"
			if [[ "$type" != "f" && "$type" != "d" ]]; then
				echo "Error: -t must be 'f' for file or 'd' for directory"
				exit 1
			fi
			shift 2
			;;
		-d)
			directory="$2"
			if [[ ! -d "$directory" ]]; then
				echo "Error: $directory is not a valid directory"
				exit 1
			fi
			shift 2
			;;
		--count)
			count_only=true
			shift
			;;
		--open)
			open=true
			shift
			;;
		--delete)
			delete=true
			shift
			;;
		--size)
			size_flag=true
			size_action="$2"
			#echo "$size_action" | grep -iE '^[+-]?[0-9]+(M|m|G|g|K|k|B|b)$'
			if [[ ! "$size_action" =~ ^[+-]?[0-9]+[MmGgKkBb]$ ]]; then
				echo "Error: invalid size action"
				exit 1
			fi
			to_sub=("m" "g" "K" "B" "b")
			for i in "${to_sub[@]}"; do
				if [[ "$i" = "m" ]]; then
					sub="M"
				elif [[ "$i" = "g" ]]; then
					sub="G"
				elif [[ "$i" = "K" ]]; then
					sub="k"
				else
					sub="c"
				fi
				size_action="${size_action//${i}/${sub}}"
			done
			shift 2
			;;		
		*)
			echo "error"
			exit 1
			;;
	esac
done
	if [[ "$size_flag" = "true" ]]; then
		base_command="find \"$directory\" -type $type -size $size_action -name \"$pattern\""
	else
		base_command="find \"$directory\" -type $type -name \"$pattern\""
	fi
	if [[ "$delete" = "true" ]]; then
		count_only=false
		open=false
		files=$(eval "$base_command" | wc -l)
		if [[ "$files" = "0" ]]; then
			echo "No files found."
			exit 0
		fi
		echo "Are you sure you want to delete $files files? (y/n)"
		read confirm
		if [[ "$confirm" != "y" ]]; then
			echo "Aborted."
			exit 1
		fi
		eval "$base_command -exec rm -r '{}' ';'"
		echo "Deleted $files files"
		exit 0
	elif [[ "$count_only" = "true" ]]; then
		open=false
		output=$(eval "$base_command" | wc -l)
		echo "$output files found"
		exit 0
	else
		output=( )
	       while IFS= read -r line; do
	       		output+=("$line")
		done < <(eval "$base_command")
		if [[ "${#output[@]}" = "0" ]]; then
			echo "No files found."
			exit 0
		fi
		for i in "${!output[@]}"; do
			echo "[$((i+1))] ${output[$i]}"
		done
		if [[ "$open" = "true" ]]; then
			echo "Enter file number to open: "
			read choice
			if [[ $choice -gt 0 && $choice -le ${#output[@]} ]]; then
				index=$((choice-1))
				selected_file="${output[$index]}"
				echo ""
				echo "Opening file: ${output[$index]}"
				xdg-open "$selected_file"
				exit 0
			else
				echo "Invalid Choice!"
				exit 1
			fi
		else
			exit 0
		fi
	fi
