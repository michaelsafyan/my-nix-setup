#! /bin/bash
#
# Adds the Google Cloud SDK to the PATH if it exists at one of a variety of
# pre-specified locations to look for it
function AddCloudSdkToPath() {
  for folder in "/google/google-cloud-sdk" "$HOME/Library/CloudSDK" "$HOME/Library/GoogleCloudSDK" "$HOME/cloud-sdk" "$HOME/google-cloud-sdk" "$HOME/.cloud-sdk" "$HOME/.google-cloud-sdk" "$HOME/Tools/cloud-sdk" "$HOME/Tools/google-cloud-sdk"; do
    if [ -d "$folder" ] ; then
      if [ -f "$folder/path.bash.inc" ] ; then
        source "$folder/path.bash.inc"
        source "$folder/completion.bash.inc"
        return
      fi
    fi
   done
}

AddCloudSdkToPath
