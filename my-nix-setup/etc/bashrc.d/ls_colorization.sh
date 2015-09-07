#! /bin/bash
case "$TERM" in
  xterm*|rxvt*)
    export CLICOLOR=1
    export LSCOLORS=ExFxCxDxBxegedabagacad
    ;;
  *)
    ;;
esac
