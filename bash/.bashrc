#Aliases

alias code="'/c/Users/ivanh/AppData/Local/Programs/Microsoft VS Code/Code.exe'"
# sublime text
# alias sub="sublime_text.exe"
alias gb="/git-bash.exe & > /dev/null 2&>1"
alias cpwd="pwd | tr -d '\n' | clip && echo 'wd copied to clipboard'"

#makes directory and changes to new directory
mkcd ()
{
  mkdir -p -- "$1" && cd -P -- "$1"
}

# touch and open in vs code
tocode ()
{
  touch "$1" && code "$1"
}

# venv stuff
export WORKON_HOME=$HOME/.virtualenvs   # Optional
export PROJECT_HOME=$HOME/projects      # Optional
# source /usr/local/bin/virtualenvwrapper.sh
. /c/ProgramData/Miniconda3/etc/profile.d/conda.sh
# working directory for personal repo
export PERSONAL=$HOME/repos/personal