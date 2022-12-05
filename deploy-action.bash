#!/bin/bash
set -e
# shellcheck disable=SC2024
sudo apt install -y pv > ./output.log
full_transfer_path="$ACTION_TRANSFER_PATH/$GITHUB_SHA"
mkdir -p ~/.ssh
ssh-keyscan -t rsa "$ACTION_HOSTNAME" >> ~/.ssh/known_hosts
ssh_key_path=~/.ssh/action_rsa
echo "$ACTION_SSH_KEY" > "$ssh_key_path"
chmod g-rw,o-rw "$ssh_key_path"
cd "$GITHUB_WORKSPACE"
dir_size=$(du -sb --exclude "./.git" | grep -o "[0-9]*")
echo "Transferring $dir_size bytes to $ACTION_HOSTNAME..."
tar -cf - --exclude-vcs . | \
	pv -s "$dir_size" | \
	gzip | \
	ssh \
	-i "$ssh_key_path" \
	-p "$ACTION_PORT" \
	"$ACTION_USER"@"$ACTION_HOSTNAME" \
	"mkdir -p $full_transfer_path && cd $full_transfer_path && tar -xzf -"

echo "TODO: Move to $ACTION_PATH/$GITHUB_REF_NAME"
# TODO:
# This copies the files to the server.
# Once transferred, what's the best way to switch the current $ACTION_PATH with the newly-deployed?
# It's probable that the newly-created directory, once moved in place, will require symlinks adding to mount points (for external volumes)... how should this be handled?
# On that same note, there will be certain deploy-specific config files needing putting in place... in real apps this will be a branch name database schema, but we could just put the branch name in the config.development.ini and echo it in PHP to prove that it's working...
# For dev servers, there needs to be a way to deploy into a container with branch name, and for nginx to automatically know what to do with branchname.dev.example.com
