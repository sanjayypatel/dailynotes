#!/bin/zsh

DAILYNOTEPATH=~/dailies/$( date +%m-%d-%Y ).txt

note(){
    echo "$(date +%H:%M ) $*" >> $DAILYNOTEPATH
}
todo(){
    todocount=$( cat $DAILYNOTEPATH | grep -c '^TODO\|^XTODO' )
    echo "TODO${todocount}: $(date +%H:%M ) $*" >> $DAILYNOTEPATH
    echo "TODO ADDED: $*"
}
readnotes(){
    echo $DAILYNOTEPATH
    echo "===== ALL NOTES: ====="
    cat $DAILYNOTEPATH
    echo "===== ===== ===== ====="
}
readtodos(){
    echo $DAILYNOTEPATH
    echo "===== TODOS: ====="
    cat $DAILYNOTEPATH | grep '^TODO\|^XTODO'
    echo "===== ===== ===== ====="
}
completetodo(){
    echo "todo is ${1}"
    linenumber=$( cat $DAILYNOTEPATH | grep -n "^TODO${1}" | cut -d: -f1 )
    echo "line number is ${linenumber}"
    if [ ! -z $linenumber ]
        then
        sed -i "" "${linenumber}s/^/X/" $DAILYNOTEPATH
        echo "Completed TODO${1}"
    else
        echo "TODO${1} not found or already complete."
    fi
}
newdaily(){
    touch $DAILYNOTEPATH 
    yesterdaysnotepath=~/dailies/$( date -v -1d +%m-%d-%Y ).txt
    echo "$( date +%m-%d-%Y ) daily notes" >> $DAILYNOTEPATH 
    if [ -f $yesterdaysnotepath ]
        then
        cat $yesterdaysnotepath | grep '^TODO' | awk -F': ' '{print $NF}' > ~/dailies/todotemp.txt
        declare -i num=0
        while read todo; do
            echo "TODO${num}: $todo" >> $DAILYNOTEPATH
            num+=1
        done<~/dailies/todotemp.txt
        numcarriedtodos=$( cat $yesterdaysnotepath | grep -c '^TODO' )
        echo "Carried over ${numcarriedtodos} TODO(s)"
    fi
    echo "${DAILYNOTEPATH} created."
}
dailieshelp(){
    echo "Dailies Functions:"
    echo "newdaily - make new notes labelled todays date. Will carry over uncompleted TODOs from yesterday."
    echo "note - will take all args, wrap in "" and echo into today's daily."
    echo "todo - takes all args, wraps in "" and prefixes with 'TODO: '"
    echo "completetodo (todo number) - Marks a TODO as complete by prepending an X."
    echo "readnotes - will cat today's daily."
    echo "readtodos - cat today's daily and grep for 'TODO'"
    echo "copytodos (path to notes file) - read supplied  notes file and copy incomplete TODOs to todays notes file."
}

copytodos(){
    if [ -f $1 ]
        then
        cat $1 | grep '^TODO' | awk -F': ' '{print $NF}' > ~/dailies/todotemp.txt
        todocount=$( cat $DAILYNOTEPATH | grep -c '^TODO\|^XTODO' )
        declare -i num=$todocount
        while read todo; do
            echo "TODO${num}: $todo" >> $DAILYNOTEPATH
            num+=1
        done<~/dailies/todotemp.txt
        numcarriedtodos=$( cat $1 | grep -c '^TODO' )
        echo "Carried over ${numcarriedtodos} TODO(s)"
    fi
}
