#!/usr/bin/env bash

DEST=/beegfs/mnt
HASH=/scripts/hash

mkdir -p $HASH

# Create 20 files of 10MB each and save the hash of each file
echo "Creating 20 files of 10MB each"
for i in {1..20}; do
    dd if=/dev/urandom of=$DEST/file$i bs=1M count=10 2> /dev/null
    md5sum $DEST/file$i > $HASH/file$i.hash
done

# Create 20k small (1kb) files
echo "Creating 20k small files"
mkdir -p $DEST/small_files
for i in {1..20000}; do
    if (( $i % 500 == 0 )); then
        echo "Created $i files"
    fi
    dd if=/dev/zero of=$DEST/small_files/$i bs=1K count=1 2> /dev/null
done