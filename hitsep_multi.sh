#!/bin/bash

# Prompt the user for the base directory where all subfolders are located
read -p "Please enter the path to the base directory where all subfolders are located: " BASE_DIR

# Check if provided directory exists
if [ ! -d "$BASE_DIR" ]; then
    echo "Error: The provided directory does not exist."
    exit 1
fi

# Prompt the user for the directory to store the output
read -p "Please enter the path to store multihetsep results: " OUTPUT_DIR

# Check if provided output directory exists, if not, create it
if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
fi

# Iterate over each subfolder
for SUBFOLDER in "$BASE_DIR"/*; do
    if [ -d "$SUBFOLDER" ]; then
        # Extract contig name from subfolder name
        CONTIG_NAME=$(basename "$SUBFOLDER")

        # Collect all .vcf.gz and .vcf.gz.bed.gz filenames
        VCF_FILES=($(find "$SUBFOLDER" -type f -name "*.vcf.gz"))
        MASK_FILES=($(find "$SUBFOLDER" -type f -name "*.vcf.gz.bed.gz"))

        # Construct the --mask part of the command
        MASK_PART=""
        for MASK_FILE in "${MASK_FILES[@]}"; do
            MASK_PART="$MASK_PART --mask $MASK_FILE"
        done

        # Construct the command
        COMMAND="python /mnt/data2/martij04/PolyplaxNS_Demographic/generate_multihetsep.py --chr $CONTIG_NAME $MASK_PART ${VCF_FILES[@]} > $OUTPUT_DIR/${CONTIG_NAME}.multihetsep"
        
        # Run the command
        echo "Processing: $CONTIG_NAME"
        eval "$COMMAND"
    fi
done

echo "Processing complete."

