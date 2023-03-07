#!/bin/zsh

dailies_dir=~/dailies
mkdir -p $dailies_dir

# All functions will work relative to "today"
todays_note=$dailies_dir/$( date +%m-%d-%Y ).txt
touch $todays_note

dailies_help(){
    echo "Dailies Functions:"
    echo "newdaily - make new notes labelled todays date. Will carry over uncompleted TODOs from yesterday."
    echo "note - will take all args, wrap in "" and echo into today's daily."
    echo "todo - takes all args, wraps in "" and prefixes with 'TODO: '"
    echo "completetodo (todo number) - Marks a TODO as complete by prepending an X."
    echo "readnotes - will cat today's daily."
    echo "readtodos - cat today's daily and grep for 'TODO'"
    echo "copytodos (path to notes file) - read supplied  notes file and copy incomplete TODOs to todays notes file."
}

# Write a time-stamped note to todays_note
new_note(){
    echo "$(date +%H:%M ) $*" >> $todays_note
}

# create a note pre-fixed with TODO## 
todo(){
    todocount=$( cat $todays_note | grep -c '^TODO\|^XTODO' )
    echo "TODO${todocount}: $(date +%H:%M ) $*" >> $todays_note
    echo "TODO ADDED: $*"
}

# Show all of the contents of todays_note
read_notes(){
    echo $todays_note
    echo "===== ALL NOTES: ====="
    cat $todays_note
    echo "===== ===== ===== ====="
}

# Show the contents of todays_note but filter for TODO lines
read_todos(){
    echo $todays_note
    echo "===== TODOS: ====="
    cat $todays_note | grep '^TODO\|^XTODO'
    echo "===== ===== ===== ====="
}

# Mark a todo complete so it will no longer flow into future days
completetodo(){
    echo "todo is ${1}"
    linenumber=$( cat $todays_note | grep -n "^TODO${1}" | cut -d: -f1 )
    echo "line number is ${linenumber}"
    if [ ! -z $linenumber ]
        then
        sed -i "" "${linenumber}s/^/X/" $todays_note
        echo "Completed TODO${1}"
    else
        echo "TODO${1} not found or already complete."
    fi
}

# Create today's note and populate with yesterday's incomplete TODOS
newdaily(){
    touch $todays_note 
    yesterdaysnotepath=~/dailies/$( date -v -1d +%m-%d-%Y ).txt
    echo "$( date +%m-%d-%Y ) daily notes" >> $todays_note 
    if [ -f $yesterdaysnotepath ]
        then
        cat $yesterdaysnotepath | grep '^TODO' | awk -F': ' '{print $NF}' > ~/dailies/todotemp.txt
        declare -i num=0
        while read todo; do
            echo "TODO${num}: $todo" >> $todays_note
            num+=1
        done<~/dailies/todotemp.txt
        numcarriedtodos=$( cat $yesterdaysnotepath | grep -c '^TODO' )
        echo "Carried over ${numcarriedtodos} TODO(s)"
    fi
    echo "${todays_note} created."
}

# Copy the todos from the file passed as argument
copytodos(){
	previous_note=$1
    if [ -f $previous_note ]
        then
        cat $previous_note | grep '^TODO' | awk -F': ' '{print $NF}' > ~/dailies/todotemp.txt
        todocount=$( cat $todays_note | grep -c '^TODO\|^XTODO' )
        declare -i num=$todocount
        while read todo; do
            echo "TODO${num}: $todo" >> $todays_note
            num+=1
        done<~/dailies/todotemp.txt
        numcarriedtodos=$( cat $previous_note | grep -c '^TODO' )
        echo "Carried over ${numcarriedtodos} TODO(s)"
    fi
}

while getopts "n:hr" option; do
    case $option in
        h) # display Help
            dailies_help
            exit;;
        n) # New Note
            new_note $OPTARG
            exit;;
        r) # Read Note
            read_notes
            exit;;
        \?) # incorrect option
            echo "Error: Invalid option"
            exit;;
    esac
done