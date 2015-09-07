#! /bin/bash

USER_AT_HOST='\u@\h'
if [[ "$C9_USER" != "" ]] ; then
  USER_AT_HOST='${C9_USER}@${C9_PROJECT}'
fi

GIT_COMPLETION=''
if [ $(type __git_ps1 >/dev/null 2>&1 ; echo $?) -eq 0 ] ; then
  GIT_COMPLETION='$(__git_ps1 " (%s)")'
fi

XTERM_RED='01;31'
XTERM_GREEN='01;32'
BASIC_COLOR=$XTERM_GREEN
DIRECTORY_COLOR='01;34'
GIT_STATUS_COLOR='0;35'
PROMPT_SYMBOL='\$'
if [ $EUID -eq 0 ] ; then
  PROMPT_SYMBOL='#'
  BASIC_COLOR=$XTERM_RED
fi
if [ $UID -eq 0 ] ; then
  PROMPT_SYMBOL='#'
  BASIC_COLOR=$XTERM_RED
fi
if [[ "$USER" == "root" ]] ; then
  PROMPT_SYMBOL='#'
  BASIC_COLOR=$XTERM_RED
fi

function set_uncolored_prompt() {
  export PS1="[${USER_AT_HOST} \w${GIT_COMPLETION}]${PROMPT_SYMBOL} "
}

function set_colored_prompt() {
  export PS1="\[\033[${BASIC_COLOR}m\][${USER_AT_HOST} \[\033[${DIRECTORY_COLOR}m\]\w\[\033[00m\]\[\033[${GIT_STATUS_COLOR}m\]${GIT_COMPLETION}\[\033[00m\]\[\033[${BASIC_COLOR}m\]]${PROMPT_SYMBOL}\[\033[00m\] "
}

function set_prompt() {
  case "$TERM" in
    xterm*|rxvt*|screen) set_colored_prompt ;;
    *) set_uncolored_prompt ;;
  esac
}

set_prompt
