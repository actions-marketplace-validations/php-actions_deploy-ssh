#!/bin/bash
set -e
full_transfer_path="$ACTION_TRANSFER_PATH/$GITHUB_SHA"
tar -czf - "$GITHUB_WORKSPACE" | \
	ssh -p "$ACTION_PORT" "$ACTION_USER"@"$ACTION_HOSTNAME" \
	"mkdir -p $full_transfer_path && cd $full_transfer_path && tar -xzvf -"

# TODO:
# This should copy the files to the server.
# Documentation is needed for getting SSH keys set up as secrets.
# The transferred directory might be full of crap directories - can tar convert the path to relative to the $GITHUB_WORKSPACE?
# Once transferred, what's the best way to switch the current $ACTION_PATH with the newly-deployed?
# It's probable that the newly-created directory, once moved in place, will require symlinks adding to mount points (for external volumes)... how should this be handled?
# On that same note, there will be certain deploy-specific config files needing putting in place... in real apps this will be a branch name database schema, but we could just put the branch name in the config.development.ini and echo it in PHP to prove that it's working...
# For dev servers, there needs to be a way to deploy into a container with branch name, and for nginx to automatically know what to do with branchname.dev.example.com
