#!/usr/bin/env bash

DEST=/beegfs/mnt
HASH=/scripts/hash

# Check that the hash of each file is the same as the original
for i in {1..20}; do
    md5sum -c $HASH/file$i.hash
done