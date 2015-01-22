# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH

# PS1
case $- in

# interactive shell
*i*)
    _PRE='\[\e['
    _POST='m\]'

    _DIM_CYAN="${_PRE}36${_POST}"
    _BRIGHT_CYAN="${_PRE}36;01${_POST}"
    _RESET="${_PRE}00${_POST}"

    _USER="$_DIM_CYAN\u$_RESET"
    _HOST="$_DIM_CYAN\h$_RESET"
    _PWD="$_DIM_CYAN\w$_RESET"
    _PROMPT="$_BRIGHT_CYAN\$$_RESET"

    . ~/.ps1_vcs

    running_jobs="
        J=\$(jobs -l)
        if [ -n \"\$J\" ]; then
            jobs -l
            echo \"\n\"
        fi
    "

    export PS1="$_USER@$_HOST:$_PWD\$(${dvcs_function})\n\$(${running_jobs})$_PROMPT "
    unset _PRE _POST _DIM_CYAN _BRIGHT_CYAN _RESET _USER _HOST _PWD _PROMPT

    # Whenever displaying the prompt, append history to disk
    PROMPT_COMMAND='history -a'

    # display red exit value if it isn't zero
    PROMPT_COMMAND='EXITVAL=$?; '$PROMPT_COMMAND
    GET_EXITVAL='$(if [[ $EXITVAL != 0 ]]; then echo -n "\[\e[37;41;01m\] $EXITVAL \[\e[0m\] "; fi)'
    export PS1="$GET_EXITVAL$PS1"

    # turn off flow control, mapped to ctrl-s, so that we regain use of that key
    # for searching command line history forwards (opposite of ctrl-r)
    stty -ixon
;;

# non-interactive shell
*)
;;

esac


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# recursive search in files
function grp {
    GREP_OPTIONS="-rI --color --exclude-dir=\.bzr --exclude-dir=\.git --exclude-dir=\.hg --exclude-dir=\.svn --exclude=tags $GREP_OPTIONS" grep "$@"
}

# recursive search in Python source
function grpy {
    GREP_OPTIONS="--exclude-dir=build --exclude-dir=dist --include=*.py $GREP_OPTIONS" grp "$@"
}

function glog {
    git log --graph --all --format=format:"%x09%C(yellow)%h%C(reset) %C(green)%ai%x08%x08%x08%x08%x08%x08%C(reset) %C(bold white)%cn%C(reset)%C(auto)%d%C(reset)%n%x09%C(white)%s%C(reset)" --abbrev-commit "$@"
    echo
}

# Remove all tags files in dirs under . but skip .git subdirs
function rm_tags {
    find . -path "./.git" -prune -o -name "tags" -print | xargs rm -f
}

# Remove tags files and create new one
function pytags {
    rm_tags
    ctags -R --languages=python $*
}

function gpp {
    git pull && git fetch --tags && git push --tags
}