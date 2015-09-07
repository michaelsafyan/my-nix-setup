#! /bin/bash

# Determine whether debugging is enabled or not. Setting this flag
# makes it easier to debug the internal workings of this script.
DEBUG=$BASHRC_DEBUG_LEVEL
if [[ "$DEBUG" == "" ]] ; then
  DEBUG=0
fi

function source_platform_directory() {
  local path="$1"
  if [ -f "$path/bashrc.sh" ] ; then
    if [ $DEBUG -eq 1 ] ; then
      echo "  Sourcing: $path/bashrc.sh" >&2
    fi
    source "$path/bashrc.sh"
  fi
  
  if [ -d "$path/bashrc.d" ] ; then
    for bashrc_script_basename in $(/bin/ls "$path/bashrc.d/") ; do
      if [ -f "$path/bashrc.d/$bashrc_script_basename" ] ; then
        if [ $DEBUG -eq 1 ] ; then
          echo "  Sourcing: $path/bashrc.d/$bashrc_script_basename" >&2
        fi
        source "$path/bashrc.d/$bashrc_script_basename"
      fi
    done
  fi
}

function init_bashrc() {
  local start_time=$(date +%s)
  if [ $DEBUG -eq 1 ] ; then
    echo "Initializing bashrc..." >&2
  fi

  # Determine the location into which this code has been installed.
  if [[ "$MY_NIX_SETUP_HOME" == "" ]] ; then
    pushd $(dirname ${BASH_SOURCE[0]}) > /dev/null
    local this_script_dir=$(pwd -P)
    popd > /dev/null
    local mynix_root_dir=$(dirname "$this_script_dir")
    export MY_NIX_SETUP_HOME=$(cd -P "$mynix_root_dir" > /dev/null && pwd -P)
  fi
  local mynix_setup_dir_abspath="$MY_NIX_SETUP_HOME"
  export PATH="$MY_NIX_SETUP_HOME/bin:$PATH"

  # Add my-nix-setup bashrc.d files
  if [ -d "$mynix_setup_dir_abspath/etc/bashrc.d" ] ; then
    for bashrc_script_basename in $(/bin/ls "$mynix_setup_dir_abspath/etc/bashrc.d/") ; do
      local bashrc_script="$mynix_setup_dir_abspath/etc/bashrc.d/$bashrc_script_basename"
      if [ -f "$bashrc_script" ] ; then
        if [ $DEBUG -eq 1 ] ; then
          echo "  Sourcing: $bashrc_script" >&2
        fi
        source "$bashrc_script"
      fi
    done
  fi

  # Add my-nix-setup platform-specific bashrc.d files
  local platforms=$("$mynix_setup_dir_abspath/bin/platform_aliases")
  for platform in $platforms ; do
    # Add platform-specific aliases for my-nix-setup
    if [ -d "$mynix_setup_dir_abspath/platform/$platform" ] ; then
      if [ -d "$mynix_setup_dir_abspath/platform/$platform/etc" ] ; then
        source_platform_directory "$mynix_setup_dir_abspath/platform/$platform"
      fi
      if [ -d "$mynix_setup_dir_abspath/platform/$platform/bin" ] ; then
        export PATH="$mynix_setup_dir_abspath/platform/$platform/bin:$PATH"
      fi
    fi
  done
  
  # Add .local bashrc.d and bin files
  if [ -d "$HOME/.local" ] ; then
    if [ -d "$HOME/.local/bin" ] ; then
      export PATH="$HOME/.local/bin:$PATH"
    fi
    if [ -f "$HOME/.local/etc/bashrc.sh" ] ; then
      if [ $DEBUG -eq 1 ] ; then
        echo "  Sourcing: $HOME/.local/etc/bashrc.sh" >&2
      fi
      source "$HOME/.local/etc/bashrc.sh"
    fi
    if [ -d "$HOME/.local/etc/bashrc.d" ] ; then
      for bashrc_script_basename in $(/bin/ls "$HOME/.local/etc/bashrc.d/") ; do
        bashrc_script="$HOME/.local/etc/bashrc.d/$bashrc_script_basename"
        if [ -f "$bashrc_script" ] ; then
          if [ $DEBUG -eq 1 ] ; then
            echo "  Sourcing: $bashrc_script" >&2
          fi
          source "$bashrc_script"
        fi
      done
    fi
  fi
  
  # Add platform-specific aliases for .local/platform/
  if [ -d "$HOME/.local/platform" ] ; then
    for platform in $platforms ; do
      if [ -d "$HOME/.local/platform/"] ; then
        if [ -d "$HOME/.local/platform/etc" ] ; then
          source_platform_directory "$HOME/.local/platform/etc"
        fi
        if [ -d "$HOME/.local/platform/bin" ] ; then
          export PATH="$HOME/.local/platform/bin:$PATH"
        fi
      fi
    done
  fi
  
  if [ $DEBUG -eq 1 ] ; then
    local end_time=$(date +%s)
    local total_time=$(expr "$end_time" - "$start_time")
    if [ $total_time -gt 0 ] ; then
      if [ $total_time -eq 1 ] ; then
        log info "Loaded bashrc configuration in 1 second."
      else
        log info "Loaded bashrc configuration in $total_time seconds."
      fi
    fi
  fi
}

init_bashrc
