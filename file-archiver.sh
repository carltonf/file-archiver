#!/bin/bash

# Usage:
#

if [[ $# < 2 ]]; then
  echo "Usage:$0 <source dir> <dest directory> "
  exit 1
fi

TOP=$(pwd)
SRC_DIR=$(realpath "$1")
DST_DIR=$(realpath "$2")
if [[ ! -d "$SRC_DIR" ]]; then
  echo "ERROR: source directory doesn't exist."
  exit 2
fi
if [[ ! -d "$DST_DIR" ]]; then
  echo "ERROR: destination directory doesn't exist."
  exit 2
fi

SECRET_FILE=$HOME/.config/file-archiver-secret
if [[ ! -e $SECRET_FILE ]]; then
  echo "ERROR: $SECRET_FILE doesn't exist."
  exit 3
fi
PASSWORD=$(<$SECRET_FILE)

FILELIST=$TOP/$(date +%Y%m%d)-backup-filelist.txt
echo "$FILELIST" > "$FILELIST"


args7z=(
# make logs
"-bt" "-bb3"
# force 7z format
"-t7z"
# faster compression. No need to save cloud storage
"-m0=lzma2" "-mx=1"
# enable solid block
# increase compression performance at cost of retrieving
"-ms=on"
# turn on encryption also for files listings
"-mhe=on" "-p$PASSWORD"
# create volume in 100m
"-v100m"
)

# create archive for each files and subdirectories
cd "$SRC_DIR"
for i in *; do
  list_entry="$(echo $i | md5sum) $i"
  archive_name="${list_entry%% *}"
  7z a "${args7z[@]}" "$DST_DIR/$archive_name.7z" "$i"
  echo "$list_entry" >> "$FILELIST"
  if [[ -d "$i" ]]; then
    tree "$i" >> "$FILELIST"
  fi
done

