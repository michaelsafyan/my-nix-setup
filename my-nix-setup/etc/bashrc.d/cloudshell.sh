#! /bin/bash

function addCloudShellSetup() {
  local old_path="$PATH"
  if [ -f "/google/devshell/bashrc.google" ]; then
    source "/google/devshell/bashrc.google"
  fi
  export PATH="$PATH:$old_path"
}

addCloudShellSetup
