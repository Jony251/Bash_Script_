#!/bin/bash

# Creating the main directoris and passes
username=$(whoami)
diary_dir="${username}/diary"
backup_dir="backups_diary"
log_file="diary.log"
backup_file="${backup_dir}/${username}_diary_backup.tar.gz"
diary_file="${diary_dir}/backup.txt"


mkdir -p "$diary_dir"
mkdir -p "$backup_dir"

# Function for adding new logs
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $username | $1" >> "$log_file"
}


#Function for creating Title + content 
create_entry() {
    read -p "Enter a title:" title
    echo "Enter the content (at the end press CTRL+D):"
    echo "----- $title -----" >> "$diary_file"
    cat >> "$diary_file"
    echo >> "$diary_file"
    log_action "New content entered"
}


# Search function to search fom input
search_entry() {
    read -p "Enter string for searching: " query
    echo "The result of search '$query':"
    if grep -n "$query" "$diary_file"; then
        echo "File: $diary_file"
        echo "Date: $(date '+%Y-%m-%d')"
    else
        echo "Nothing found"
    fi
    log_action "Seanch in diary"
    
    read -p "Do you want to backup (y/n): " answer
    if [[ "$answer" == "y" ]]; then
        backup_diary
    fi
}


# Backup creation function
backup_diary() {
    tar -czf "$backup_file" "$username"
    echo "The backup created $backup_file"
    log_action "Creation of backup"
}


# The main part of the system, for inputing the choice 
while true; do
    echo "Choose the option"
    echo "1. Creating the daily content"
    echo "2. Search in dairy"
    echo "3. Exit"
    read -p ">> " choice

    case $choice in
        1) create_entry ;;
        2) search_entry ;;
        3) log_action "Exit from the system"; exit 0 ;;
        *) echo "The option is not valid" ;;
    esac
done
