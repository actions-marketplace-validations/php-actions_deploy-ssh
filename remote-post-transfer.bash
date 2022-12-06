#!/bin/bash
full_transfer_path=${full_transfer_path:-"/dev/null"}
source_dir="$full_transfer_path"
destination_dir="$ACTION_PATH/$GITHUB_REF_NAME"
destination_dir_prev="$destination_dir.previous"

echo "Started post-transfer script with source ($source_dir) destination ($destination_dir)"

if [[ -d "$destination_dir" ]]
then
	if [[ -d "$destination_dir_prev" ]]
	then
		echo rm -rf "$destination_dir_prev"
	fi

	echo mv "$destination_dir" "$destination_dir_prev"
fi

echo mv "$source_dir" "$destination_dir"

echo "Completed post-transfer script"

# TODO:
# Receive the following:
# Add symlinks from a definition list somewhere
# Set a special deployment config variable
