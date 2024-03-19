#!/bin/bash

# command to regenerate the folder structure
# dh_make --createorig --single --email YOUR_EMAIL --copyright gpl3

# Settings 
project_dir="/home/khophidev/Development/package/ollama-1"
gpg_key_id="F4835FCA7F1F1B3B649965F1F855A222C1DE8A01"
ppa="ppa:khophi/ollama"

# Change to the project directory
cd "$project_dir" || exit 1

# Build the package
echo "Building the package..."
debuild -S || { echo "Error during package build. Exiting."; exit 1; }

# Move up one directory level
cd ..

# Find the .changes file
changes_file=$(find . -maxdepth 1 -name "*.changes") 
if [ -z "$changes_file" ]; then
    echo "Error: No .changes file found in the directory."
    exit 1
fi

# Sign the .changes file
echo "Signing the package..."
debsign -k "$gpg_key_id" "$changes_file" || { echo "Error during signing. Exiting."; exit 1; }

# Upload to PPA
echo "Uploading to PPA..."
dput "$ppa" "$changes_file" || { echo "Error during upload. Exiting."; exit 1; }

echo "Package build, signing, and upload successful!"

# Cleaning up folder

echo "Cleaning up built files"

function cleanup_build_artifacts() {
    find . -maxdepth 1 \( -name "*.build" -o -name "*.buildinfo" -o -name "*.changes" -o -name "*.upload" -o -name "*.debian.tar.xz" -o -name "*.dsc" \) -delete
}

cleanup_build_artifacts