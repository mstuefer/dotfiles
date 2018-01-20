##########

# PATH
# use stuff installed via brew first
export PATH=/usr/local/bin:$PATH:$HOME/.rvm/bin

# Load RVM function
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# autojump around
if [ -f $(brew --prefix)/etc/profile.d/z.sh ]; then
  . $(brew --prefix)/etc/profile.d/z.sh
fi

if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
fi

if [ -f ~/.git-completition.bash ]; then
  source ~/.git-completition.bash
fi

##########
# Functions
my_find() {
    find . -name "*$1*"
}

# extracts the given file
x () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

##########
# Aliases
alias vim='nvim'
alias e=vim
alias v=vim
alias vi=vim

alias el='exa -l --git --sort=Name'
alias l=el
alias ll='el -a'
alias lt='el -T'

alias ..='cd .. && pwd'

alias t='tree -C -L 1'
alias t1='tree -C -L 1'
alias t2='tree -C -L 2'
alias t3='tree -C -L 3'
alias td='tree -C -d'
alias td1='tree -C -d -L 1'
alias td2='tree -C -d -L 2'
alias td3='tree -C -d -L 3'

alias grv='~/go/bin/grv'

alias gpull='git pull '
alias gpush='git push '
alias gadd='git add '
alias gstatus='git status -sb'
alias gstat='gstatus'
alias gst='gstatus'
alias gcommit='git commit '
alias gcom='gcommit'
alias glog='git log --color --graph --decorate --abbrev-commit '
alias gflog='glog --stat '
alias gbranch='git branch'
alias gb=gbranch
alias gbv='gb -v -v '
alias gdiff='git diff --color '
alias d=gdiff
alias gsh='git show --color '

alias j='jobs'
alias p='pwd'

#ag (the silver searcher)
alias ag='ag -i '   # case_insensitive as default
alias agt='ag -t '  # search all txt files
alias agl='ag -l '  # show only filename, not lines matching

#find file
alias ff=my_find

# show me all my aliases :)
alias aliases='grep alias ~/.bashrc | grep -v \# | cut -d " " -f2 -f3 '
alias ali=aliases

##########
# Exports
export GOPATH=~/go

export EDITOR="vim"

export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true

#export PS1='\[\033[31m\]$(print_git_branch)\[\033[36m\] \w \[\033[37m\]\$ '
export PROMPT_COMMAND='__git_ps1 "\[$(tput setaf 6)\]\W\[$(tput sgr0)\]\[$(tput sgr0)\]" " \\\$ ";'

# ignoreboth ingores commands starting with a space and duplicates! Erasedups removes all previous dups in hist
export HISTCONTROL=ignoreboth:erasedups
export HISTFILE=~/.bash_history
export HISTSIZE=10000000
export HISTFILESIZE=10000000
export HISTTIMEFORMAT='%F %T '
shopt -s histappend
shopt -s cmdhist
shopt -s lithist # saves multi-line cmds to hist with embedded newlines, requires cmdhist to be on

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind "set completion-ignore-case on" # note: bind used instead of sticking these in .inputrc
bind "set bell-style none"
bind "set show-all-if-ambiguous On" # show list automatically, without double tab

# on completion ignore files with suffixes:
export FIGNORE='.o:.pyc'

# on filename expansion ignore:
export GLOBIGNORE='.DS_Store:*.o:*.pyc'

# Colored man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# https://github.com/junegunn/fzf
export FZF_DEFAULT_OPTS="--preview 'head -n 100 {}'"

# check windows size if windows is resized
shopt -s checkwinsize
# autocorrect directory if mispelled
shopt -s dirspell direxpand
# auto cd if only the directory name is given
shopt -s autocd
#use extra globing features. See man bash, search extglob.
shopt -s extglob
#include .files when globbing.
shopt -s dotglob
# Do not exit an interactive shell upon reading EOF.
set -o ignoreeof;
# Check the hash table for a command name before searching $PATH.
shopt -s checkhash
# Enable `**` pattern in filename expansion to match all files,
# directories and subdirectories.
shopt -s globstar
# Do not attempt completions on an empty line.
shopt -s no_empty_cmd_completion
# Case-insensitive filename matching in filename expansion.
shopt -s nocaseglob
# lists the status of any stopped and running jobs before exiting. If jobs r running, it causes the exit to be deferred until a second exit is attempted
shopt -s checkjobs


eval "$(direnv hook bash)"

# Cargo / Rust
export PATH="$HOME/.cargo/bin:$PATH"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.local_aliases ] && source ~/.local_aliases
