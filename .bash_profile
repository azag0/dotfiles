[[ -e ~/.bashrc ]] && . ~/.bashrc

export GREP_OPTIONS='--color=auto'
set -o vi 
export PS1='\[\033[01;32m\]\u@\h \[\033[01;34m\]\w \$ \[\033[00m\]'
shopt -s histappend
shopt -s cmdhist
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export HISTCONTROL=ignoreboth
export HISTIGNORE='ls:bg:fg:history'
export HISTTIMEFORMAT='%F %T '
export PROMPT_COMMAND='history -a ; echo -ne "\033]0;${PWD}\007" ; $PROMPT_COMMAND'

export PATH=$HOME/software/anaconda/bin:$PATH
export PATH=~/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/software/anaconda/lib

if [[ $TERM_PROGRAM != Apple_Terminal ]]; then
    export REMOTE=`last -n 1 -a | head -1 | awk '{print $NF}'`
fi
