# dailynotes
Shell library for maintaining daily notes and todos at command line.

Source dailynotes.sh in your zshrc file.

Functions:

    "newdaily - make new notes labelled todays date. Will carry over uncompleted TODOs from yesterday."

    "note - will take all args, wrap in "" and echo into today's daily."

    "todo - takes all args, wraps in "" and prefixes with 'TODO: '"
    
    "completetodo (todo number) - Marks a TODO as complete by prepending an X."

    "readnotes - will cat today's daily."

    "readtodos - cat today's daily and grep for 'TODO'"

