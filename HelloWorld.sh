#!/bin/bash

# variables
username=$(whoami)
diary_dir="~/diary/${username}"
backup_dir="~/diary_backups"
log_file="diary.log"
diary_file="${diary_dir}/backup.txt"

backup_file="${backup_dir}/${username}_diary_backup.tar.gz"

# directory
mkdir -p "$diary_dir"
mkdir -p "$backup_dir"

# log func
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $username | $1" >> "$log_file"
}

# diary append
create_entry() {
    read -p "Pleace input the title: " title
    echo "Input the text of the record (for end press ->  CTRL+D):"
    echo "----- $title -----" >> "$diary_file"
    cat >> "$diary_file"
    echo >> "$diary_file"
    log_action "Diary appended"
}

# diary search
search_entry() {
    read -p "Input string for search: " query
    echo "The scores: '$query':"
    if grep -n "$query" "$diary_file"; then
        echo "File: $diary_file"
        echo "Date: $(date '+%Y-%m-%d')"
    else
        echo "Nothing found"
    fi
    log_action "Diary search"
    
    read -p "Do you want to upload backup now? (y/n): " answer
    if [[ "$answer" == "y" ]]; then
        backup_diary
    fi
}

# dairy backup
backup_diary() {
    tar -czf "$backup_file" "$username"
    echo "Backup was created: $backup_file"
    log_action "Created backup"
}

# Main
while true; do
  echo "Choose the option:"
    echo "1. Adding to the diary"
    echo "2. Search in dairy"
    echo "3. Exit"
    read -p ">> " choice

    case $choice in
        1) create_entry ;;
        2) search_entry ;;
        3) log_action "Exiting the system"; exit 0 ;;
        *) echo "The choise is'n valid" ;;
    esac
done
