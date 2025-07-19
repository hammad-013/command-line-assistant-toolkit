#!/bin/bash

#Author: github/hammad-013
#Purpose: Fix file/dir permissions safely
#Modification Date: 18-07-25

#default values
file_perm_mode="644"
dir_perm_mode="755"
dry_run=false
confirm=false
directory="."

while [[ "$#" -gt 0 ]]; do
	case "$1" in
		--dir)
			directory="$2"
			if [[ ! -d "$directory" ]]; then
				echo "No such directory exists."
				exit 1
			fi
			shift 2
			;;
		--file-mode)
			file_perm_mode="$2"
			if [[ "${#file_perm_mode}" != 3 ]]; then
				echo "invalid permission mode selected"
				exit 1
			fi
			shift 2
			;;
		--dir-mode)
			dir_perm_mode="$2"
			if [[ "${#dir_perm_mode}" != 3 ]]; then
				echo "invalid permission mode selected"
				exit 1
			fi
			shift 2
			;;
		--dry-run)
			dry_run=true
			shift
			;;
		--confirm)
			confirm=true
			shift
			;;
		*)
			echo "unknown argument passed"
			exit 1
			;;
	esac
done

files=( )
while IFS=$'\n' read -r file; do
	files+=("$file")
done < <(find "$directory" -mindepth 1 -type f -name "*")

dirs=( )
while IFS=$'\n' read -r dir; do
	dirs+=("$dir")
done < <(find "$directory" -mindepth 1 -type d -name "*")
	if [[ "${#files}" = 0 ]]; then
		echo "There are no files in the directory."
		echo ""
	fi
	if [[ "${#dirs}" = 0 ]]; then
		echo "There are no sub-directories in the directory."
		echo ""
	fi
	if [[ "$dry_run" = "true" ]]; then
		if [[ "${#files}" != 0 ]]; then
			echo "File permissions to be changed to $file_perm_mode:"
			for f in "${files[@]}"; do
				old_perm=$(stat -c "%a" "$f")
				printf "[chmod %-3s]  %-50s  # old: %3s\n" "$file_perm_mode" "$f" "$old_perm"
			done
			echo ""
		fi
		if [[ "${#dirs}" != 0 ]]; then
			echo "Directory permissions to be changed to $dir_perm_mode:"
			for d in "${dirs[@]}"; do
				old_perm=$(stat -c "%a" "$d")
				printf "[chmod %-3s]  %-50s  # old: %3s\n" "$dir_perm_mode" "$d" "$old_perm"
			done
			echo ""
		fi
		echo "No changes were made. use without --dry-run to apply."
	else
		if [[ "$confirm" = "true" ]]; then
			echo "Do you want to apply changes? (y/n)"
			read confirm_flag
		fi
		if [[ "$confirm_flag" = "y" || "$confirm_flag" = "Y" ]]; then
			if [[ "${#files}" != 0 ]]; then
				echo "File permissions changed to $file_perm_mode"
				for f in "${files[@]}"; do
					chmod "$file_perm_mode" "$f"
				done
			fi
			if [[ "${#dirs}" != 0 ]]; then
				echo "Directory permissions changed to $dir_perm_mode"
				for d in "${dirs[@]}"; do
					chmod "$dir_perm_mode" "$d"
				done
			fi
			echo "[Changes were made successfully]"
		else
			echo "Aborted."
			exit 1
		fi
	fi
exit 0

