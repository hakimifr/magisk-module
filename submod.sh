#!/bin/bash

# query list of folders in the current directory
folders=$(ls -d */ | sed 's/\///g')

for folder in $folders; do
	cd "$folder" || exit 1
	remote_url=$(git remote get-url origin)
	if [[ $? -ne 0 ]]; then
		echo "No remote url found for $folder"
		cd ..
		continue
	fi
	cd ..

	rm -rf $folder
	git submodule add --force $remote_url

done
