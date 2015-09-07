#! /bin/bash
#
# If the Android SDK is present in one a set of pre-specified directories,
# this utilty adds the Android SDK to the path.
function AddAndroidSdkToPath() {
  for folder in "$HOME/Library/AndroidSDK" "$HOME/.android-sdk" "$HOME/android-sdk" "$HOME/Tools/android-sdk" ; do
    if [ -d "$folder" ] ; then
      if [ -x "$folder/tools/android" ] ; then
        export PATH="$PATH:$folder/tools:$folder/platform-tools"
        return
      fi
    fi
   done
}

AddAndroidSdkToPath

