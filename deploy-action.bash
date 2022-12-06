#!/bin/bash
set -e
# Remove trailing slashes from path variables:
ACTION_PATH=${ACTION_PATH%/}
ACTION_TRANSFER_PATH=${ACTION_TRANSFER_PATH%/}

# Initiate SSH environment for remote connection:
mkdir -p ~/.ssh
ssh-keyscan -t rsa "$ACTION_HOSTNAME" >> ~/.ssh/known_hosts
ssh_key_path=~/.ssh/action_rsa
echo "$ACTION_SSH_KEY" > "$ssh_key_path"
chmod g-rw,o-rw "$ssh_key_path"

cd "$GITHUB_WORKSPACE"
# Pass in required variables to post-transfer script:
full_transfer_path="$ACTION_TRANSFER_PATH/$GITHUB_SHA"
action_dir="$(dirname -- "${BASH_SOURCE[0]}")"
{
	echo "#!/bin/bash"; \
	declare -p \
	ACTION_PATH \
	GITHUB_REF_NAME \
	full_transfer_path \
	; \
	cat "$action_dir"/remote-post-transfer.bash;
} > ./post-transfer.bash
chmod +x ./post-transfer.bash
# Archive directory and pipe over SSH:
dir_size_human=$(du -sbh --exclude "./.git" | grep -o "[0-9]*")
echo "Transferring $dir_size_human bytes to $ACTION_HOSTNAME..."
tar -czf - --exclude-vcs . | \
	ssh \
	-i "$ssh_key_path" \
	-p "$ACTION_PORT" \
	"$ACTION_USER"@"$ACTION_HOSTNAME" \
	"rm -rf $full_transfer_path && mkdir -p $full_transfer_path && cd $full_transfer_path && tar -xzf - && mv ./post-transfer.bash $ACTION_POST_TRANSFER_SCRIPT && echo $ACTION_POST_TRANSFER_SCRIPT_PREFIX $ACTION_POST_TRANSFER_SCRIPT && cat $ACTION_POST_TRANSFER_SCRIPT && $ACTION_POST_TRANSFER_SCRIPT_PREFIX $ACTION_POST_TRANSFER_SCRIPT"
echo "Transfer complete"

#action_dir="$(dirname -- "${BASH_SOURCE[0]}")"
#{ declare -p \
#	ACTION_PATH \
#	GITHUB_REF_NAME \
#	full_transfer_path \
#	; \
#cat "$action_dir"/remote-script.bash; } | \
#	ssh \
#	-i "$ssh_key_path" \
#	-p "$ACTION_PORT" \
#	"$ACTION_USER"@"$ACTION_HOSTNAME" \
#	bash -s

# TODO:
# remote-script.bash
