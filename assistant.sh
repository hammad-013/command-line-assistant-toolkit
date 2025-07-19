#!/bin/bash

#Author: github.com/hammad-013
#Purpose: Interactive Tool Runner with Prompts 
#Modification Date: 19-07-25

chmod 777 scripts/*.sh

while true; do
  clear
  cat <<'EOF'
  ,--,  .---.                    .--.  .-. .-. ,'|"\\            ,-.    ,-..-. .-.,---.
.' .') / .-. ) |\    /||\    /| / /\ \ |  \| | | |\ \           | |    |(||  \| || .-'
|  |(_)| | |(_)|(\  / ||(\  / |/ /__\ \|   | | | | \ \ ____.___ | |    (_)|   | || `-.
\  \   | | | | (_)\/  |(_)\/  ||  __  || |\  | | |  \ \`----==='| |    | || |\  || .-'
 \  `-.\ `-' / | \  / || \  / || |  |)|| | |)| /(|`-' /         | `--. | || | |)||  `--.
  \____\)---'  | |\/| || |\/| ||_|  (_)/(  (_)(__)`--'          |( __.'`-'/(  (_)/( __.'
       (_)     '-'  '-''-'  '-'       (__)                      (_)      (__)   (__)
  .--.     .---.   .---. ,-.   .---.  _______  .--.  .-. .-. _______
 / /\ \   ( .-._) ( .-._)|(|  ( .-._)|__   __|/ /\ \ |  \| ||__   __|
/ /__\ \ (_) \   (_) \   (_) (_) \     )| |  / /__\ \|   | |  )| |
|  __  | _  \ \  _  \ \  | | _  \ \   (_) |  |  __  || |\  | (_) |
| |  |)|( `-'  )( `-'  ) | |( `-'  )    | |  | |  |)|| | |)|   | |
|_|  (_) `----'  `----'  `-' `----'     `-'  |_|  (_)/(  (_)   `-'
                                                    (__)
EOF

  echo "=========================="
  echo "1. Quick File Finder"
  echo "2. Environment Dumper"
  echo "3. Tar Backup"
  echo "4. Permission Fixer"
  echo "5. Process Cleaner"
  echo "6. Exit"
  echo "=========================="
  read -p "Choose a tool [1-6]: " choice

  case "$choice" in
    1)
      echo ">> Quick File Finder"
      read -p "Pattern (-p) [e.g., *.sh]: " pattern
      read -p "Type (-t) [f/d]: " type
      read -p "Directory (-d): " directory
      read -p "Count only? (--count) [y/N]: " count
      read -p "Open file after search? (--open) [y/N]: " open
      read -p "Delete found files? (--delete) [y/N]: " del
      read -p "Size filter (--size) [e.g., +1M or leave empty]: " size

      args=(-p "$pattern" -t "$type" -d "$directory")
      [[ "$count" == [yY] ]] && args+=(--count)
      [[ "$open" == [yY] ]] && args+=(--open)
      [[ "$del" == [yY] ]] && args+=(--delete)
      [[ -n "$size" ]] && args+=(--size "$size")

      bash scripts/./quickfind.sh "${args[@]}"
      ;;

    2)
      echo ">> Environment Variable Dumper"
      read -p "Filter pattern (--filter) [e.g., PATH or leave blank]: " filter
      read -p "Save output to file (--save) [filename or leave blank]: " save
      read -p "Output as JSON (--json)? [y/N]: " json

      args=()
      [[ -n "$filter" ]] && args+=(--filter "$filter")
      [[ -n "$save" ]] && args+=(--save "$save")
      [[ "$json" == [yY] ]] && args+=(--json)

      bash scripts/./envdump.sh "${args[@]}"
      ;;

    3)
      echo ">> Tar Backup"
      read -p "Source directory (-s): " src
      read -p "Output file (-o) [leave empty for auto-named]: " out
      read -p "Exclude dirs (--exclude, comma-separated): " exclude
      read -p "Log backup? (--log) [y/N]: " log

      args=(-s "$src")
      [[ -n "$out" ]] && args+=(-o "$out")
      [[ -n "$exclude" ]] && args+=(--exclude "$exclude")
      [[ "$log" == [yY] ]] && args+=(--log)

      bash scripts/./tarbackup.sh "${args[@]}"
      ;;

    4)
      echo ">> Permission Fixer"
      read -p "Directory: " dir
      read -p "File mode (--file-mode) [default: 644]: " fmode
      read -p "Dir mode (--dir-mode) [default: 755]: " dmode
      read -p "Dry run? (--dry-run) [y/N]: " dry
      read -p "Require confirm? (--confirm) [y/N]: " confirm

      args=("$dir")
      [[ -n "$fmode" ]] && args+=(--file-mode "$fmode")
      [[ -n "$dmode" ]] && args+=(--dir-mode "$dmode")
      [[ "$dry" == [yY] ]] && args+=(--dry-run)
      [[ "$confirm" == [yY] ]] && args+=(--confirm)

      bash scripts/./permfix.sh "${args[@]}"
      ;;

    5)
      echo ">> Process Cleaner"
      read -p "Name pattern (--name): " name
      read -p "Sort by top usage (--top)? [y/N]: " top
      read -p "Safe mode? (--safe) [y/N]: " safe
      read -p "Kill all without confirmation? (--kill-all) [y/N]: " all

      args=(--name "$name")
      [[ "$top" == [yY] ]] && args+=(--top)
      [[ "$safe" == [yY] ]] && args+=(--safe)
      [[ "$all" == [yY] ]] && args+=(--kill-all)

      bash scripts/./psclean.sh "${args[@]}"
      ;;

    6)
	    echo ""
	cat <<'EOF'
    (\_/)  
   ( •_•)  
  / >🌸   Here's a flower!
EOF
	echo ""
      echo "Exiting...Sayonaraaa"
      exit 0
      ;;

    *)
      echo "Invalid choice. Press enter to try again."
      read
      ;;
  esac

  echo
  read -p "Press Enter to return to main menu..."
done
