#! /bin/bash

# Determine whether debugging is enabled or not. Setting this flag
# makes it easier to debug the internal workings of this script.
DEBUG=$BASHPROFILE_DEBUG_LEVEL
if [[ "$DEBUG" == "" ]] ; then
  DEBUG=0
fi


function source_platform_directory() {
  local path="$1"
  if [ -f "$path/profile.sh" ] ; then
    if [ $DEBUG -eq 1 ] ; then
      echo "  Sourcing: $path/profile.sh" >&2
    fi
    source "$path/profile.sh"
  fi
  
  if [ -d "$path/profile.d" ] ; then
    for bashrc_script_basename in $(/bin/ls "$path/profile.d/") ; do
      if [ -f "$path/profile.d/$bashrc_script_basename" ] ; then
        if [ $DEBUG -eq 1 ] ; then
          echo "  Sourcing: $path/profile.d/$bashrc_script_basename" >&2
        fi
        source "$path/profile.d/$bashrc_script_basename"
      fi
    done
  fi
}

function init_profile() {
  local start_time=$(date +%s)
  if [ $DEBUG -eq 1 ] ; then
    echo "Initializing profile..." >&2
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
  
  # If there is a *.bashrc file to source, make sure to source that.
  if [ -f "$mynix_setup_dir_abspath/etc/bashrc.sh" ] ; then
    source "$mynix_setup_dir_abspath/etc/bashrc.sh"
  fi


  # Add my-nix-setup profile.d files
  if [ -d "$mynix_setup_dir_abspath/etc/profile.d" ] ; then
    for bashrc_script_basename in $(/bin/ls "$mynix_setup_dir_abspath/etc/profile.d/") ; do
      local bashrc_script="$mynix_setup_dir_abspath/etc/profile.d/$bashrc_script_basename"
      if [ -f "$bashrc_script" ] ; then
        if [ $DEBUG -eq 1 ] ; then
          echo "  Sourcing: $bashrc_script" >&2
        fi
        source "$bashrc_script"
      fi
    done
  fi

  # Add my-nix-setup platform-specific profile.d files
  local platforms=$("$mynix_setup_dir_abspath/bin/platform_aliases")
  for platform in $platforms ; do
    # Add platform-specific aliases for my-nix-setup
    if [ -d "$mynix_setup_dir_abspath/platform/$platform" ] ; then
      if [ -d "$mynix_setup_dir_abspath/platform/$platform/etc" ] ; then
        source_platform_directory "$mynix_setup_dir_abspath/platform/$platform"
      fi
    fi
  done
  
  # Add .local profile.d and bin files
  if [ -d "$HOME/.local" ] ; then
    if [ -f "$HOME/.local/etc/profile.sh" ] ; then
      if [ $DEBUG -eq 1 ] ; then
        echo "  Sourcing: $HOME/.local/etc/profile.sh" >&2
      fi
      source "$HOME/.local/etc/profile.sh"
    fi
    if [ -d "$HOME/.local/etc/profile.d" ] ; then
      for bashrc_script_basename in $(/bin/ls "$HOME/.local/etc/profile.d/") ; do
        bashrc_script="$HOME/.local/etc/profile.d/$bashrc_script_basename"
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
      fi
    done
  fi
  
  if [ $DEBUG -eq 1 ] ; then
    local end_time=$(date +%s)
    local total_time=$(expr "$end_time" - "$start_time")
    if [ $total_time -gt 0 ] ; then
      if [ $total_time -eq 1 ] ; then
        log info "Loaded profile configuration in 1 second."
      else
        log info "Loaded profile configuration in $total_time seconds."
      fi
    fi
  fi
}

init_profile
