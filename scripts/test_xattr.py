#!/usr/bin/env python3
# Read extended attributes from a file
import subprocess
import argparse

def get_xattr(path, name):
    try:
        return subprocess.check_output(['getfattr', '--only-values', '-n', name, path]).strip()
    except subprocess.CalledProcessError:
        return None
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Read extended attributes from a file')
    parser.add_argument('path', help='Path to the file')
    parser.add_argument('name', help='Name of the attribute')
    args = parser.parse_args()
    print(get_xattr(args.path, args.name))
    