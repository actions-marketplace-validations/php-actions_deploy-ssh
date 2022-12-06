#!/bin/bash
# shellcheck disable=SC2154
echo "This is the remote script. We are going to move $full_transfer_path to the branch named in $ACTION_PATH/$GITHUB_REF_NAME"
# Are all env vars still present?
# Move $full_transfer_path to the correct branch-named directory ($ACTION_PATH)
# It's probable that the newly-created directory, once moved in place, will require symlinks adding to mount points (for external volumes)... how should this be handled?
# On that same note, there will be certain deploy-specific config files needing putting in place... in real apps this will be a branch name database schema, but we could just put the branch name in the config.development.ini and echo it in PHP to prove that it's working...
# For dev servers, there needs to be a way to deploy into a container with branch name, and for nginx to automatically know what to do with branchname.dev.example.com
