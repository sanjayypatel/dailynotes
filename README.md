# dailynotes

dailynotes is a zsh script that facilitatesa making plain text notes and todo lists. 

### Setup

Add dailynotes to your PATH in your ~/.zshrc profile.  
Example commands:
```shell
# copy dailynotes to a ~/bin
mkdir -p ~/bin
cp ./dailynotes ~/bin

# export an updated PATH in your ~.zshrc profile
echo 'export PATH=$PATH:~/bin' >> ~/.zshrc
```

### Options:

    -h - Help - Outputs list of options and their description.
    
    -n - New note - Takes a string as argument and writes it to todays note.

    -r - Read Notes - Outputs contents of todays note.

### To Do:
- implement todos with getopts
- add filtering to text inputs to avoid issues with special characters
- create archiving functionality
- create filter/search functions across date-range