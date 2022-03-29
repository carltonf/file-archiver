#!/bin/bash

TOP=$(pwd)
SRC_DIR=$TOP/test-data
DST_DIR=$TOP/build
mkdir -pv "$DST_DIR"
FILELIST=$TOP/filelist.txt
touch "$FILELIST"

set -x

# TODO retrieve password from file
PASSWORD=$(<archiver-secret)

args7z=(
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
    tree $i >> "$FILELIST"
  fi
done

# command to clean up
# rm -rf build/ filelist.txt

