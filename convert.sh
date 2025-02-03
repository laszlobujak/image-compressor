#!/bin/bash

ARG1=${1:-20}

# Check if ARG1 is a number
if ! [[ "$ARG1" =~ ^[0-9]+$ ]]; then
    echo "Error: ARG1 must be a number." >&2
    exit 1
fi

# Create folder for output files (only if it does not exist)
mkdir -p minified

# Convert possible HEIC file to jpeg beforehand, because cwebp does not handle them
temp_id=$(uuidgen)
for file in *.heic *.HEIC; do
    filename="${file%.*}"
    sips -s format jpeg $file --out "${filename}-${temp_id}.jpeg"
done


# Start compress and convert files
for file in *.jpg *.JPG *.jpeg *.JPEG *.png *.PNG; do
    # Extract the filename without the extension
    filename="${file%.*}"
    
    # Convert images to WEBP using cwebp with quality set by ARG1
    cwebp -q "$ARG1" "$file" -o "minified/${filename}-q${ARG1}.webp"
    echo "Converted $file to ${filename}.webp with quality $ARG1"
done

# Delete temporary created HEIC -> jpeg converted images using the uuid
find . -type f -maxdepth 1 -name "*${temp_id}*" -delete