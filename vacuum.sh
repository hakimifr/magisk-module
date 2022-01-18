#!/bin/bash

# script to trim update.log.lz4 / update.log

# pretty print function
function print_info() {
  echo -e "\e[1;32m[*]\e[0m $1"
}

enable_compression=true

# first decompress the file if it is compressed
if [ -f update.log.lz4 ]; then
  print_info "Decompressing log file"
  lz4 --rm -qd update.log.lz4
fi

# then trim the file
print_info "Trimming log file"
tail -n 50 update.log > update.log.trimmed

# rename the file
print_info "Finishing trim"
mv update.log.trimmed update.log

# compress it back if enabled
if [[ "$enable_compression" = true ]]; then
  print_info "Compressing log file"
  lz4 --rm -q update.log
fi
