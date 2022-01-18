#!/bin/bash
# shellcheck disable=SC2129

# pretty print function
function print_info() {
  echo -e "\e[1;32m[*]\e[0m $1"
}

# pretty warning print function
function print_warning() {
  echo -e "\e[1;33m[*]\e[0m $1"
}

# pretty error print function
function print_error() {
  echo -e "\e[1;31m[*]\e[0m $1"
}

# function to handle cd error function -> exit
function handle_cd_error() {
  # check if return code is 1
  if [ $? -eq 5 ]; then
    print_error "Could not enter directory: $1"
    exit 1
  fi
}

##########################################################
##########################################################

# query list of folders in the current directory
folders=$(ls -d */ | sed 's/\///g')
ignore_folders=$(sed 's/#.*//g' .gitignore | sed 's/\///g')
line="----------------------------------------------------"
extra_ignore_folders=(
  "zipped"
)
enable_compression=true

##########################################################
##########################################################

case $1 in
  -c | --clean | --fresh)
    rm -rf zipped/*
    ;;
  *)
    # do nothing
esac

print_info "Note: all output will be redirected to update.log"

# Decompress log file if compressed (lz4)
if [ -f update.log.lz4 ]; then
  print_info "Decompressing log file"
  lz4 --rm -qd update.log.lz4
fi

# Update submodules
git submodule update

for folder in $folders; do

  # skip folders in .gitignore
  if [[ $ignore_folders =~ $folder ]]; then
    print_info "$line"
    print_warning "Skipping folder: $folder"
    continue
  fi

  # skip extra ignore folders
  for extra_ignore_folder in "${extra_ignore_folders[@]}"; do
    if [[ $folder =~ $extra_ignore_folder ]]; then
      print_info "$line"
      print_warning "Skipping folder: $folder"
      continue 2
    fi
  done

  print_info "$line"

  # enter every folder and zip the content recursively
  print_info "Zipping $folder"
  mkdir -p zipped
  (
    cd "$folder" || exit 5
    zip -r "../zipped/$folder.zip" *
  ) &>> update.log
  handle_cd_error "$folder"

  # copy generated zip to ~/shared/modules
  # make sure the folder exist first
  print_info "Copying $folder.zip to ~/shared/modules" # (this folder will be synced to my phone by syncthing/KDE Connect)
  (
    mkdir -p ~/shared/modules
    cp "zipped/$folder.zip" ~/shared/modules
  ) &>> update.log

done

if [[ $enable_compression == true ]]; then
  print_info "$line"
  print_info "Compressing log file"
  lz4 --rm -q update.log
fi
