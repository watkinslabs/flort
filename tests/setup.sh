#!/bin/bash

# Create the test.py file
cat <<EOL > test.py
import os

def list_files(dir_path, ignore_list):
    all_files = []
    for root, dirs, files in os.walk(dir_path):
        for file in files:
            file_path = os.path.join(root, file)
            if not any(file_path.startswith(os.path.join(dir_path, i)) for i in ignore_list):
                all_files.append(file_path)
    return all_files

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="List files in a directory, ignoring specified subdirectories.")
    parser.add_argument("dir", help="Directory to list files from.")
    parser.add_argument("ignore_dirs", nargs="*", help="Subdirectories to ignore.")
    args = parser.parse_args()

    files = list_files(args.dir, args.ignore_dirs)
    for file in files:
        print(file)
EOL

# Create the directories and files
mkdir -p tests/test_ignore
mkdir -p tests/test_no_ignore

touch tests/test_ignore/file1.txt
touch tests/test_ignore/file2.py
touch tests/test_ignore/.hidden_file

touch tests/test_no_ignore/file3.txt
touch tests/test_no_ignore/file4.py
touch tests/test_no_ignore/binary_file.bin

echo "Directories and files created successfully."
