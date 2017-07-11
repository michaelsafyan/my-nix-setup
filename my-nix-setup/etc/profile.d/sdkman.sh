#! /bin/bash

function addSdkManToProfile() {
  if [ -d "$HOME/.sdkman" ] ; then
   export SDKMAN_DIR="$HOME/.sdkman"
   source "${SDKMAN_DIR}/bin/sdkman-init.sh"
  fi
}

addSdkManToProfile
