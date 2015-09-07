#! /bin/bash
function AddGrepAlias() {
  local which_grep=$(which grep)
  case "$TERM" in
    xterm*|rxvt*)
      alias grep="$which_grep --color='auto'"
      ;;
    *)
      ;;
  esac
}

AddGrepAlias
