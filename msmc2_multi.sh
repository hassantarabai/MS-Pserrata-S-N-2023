#!/bin/bash

# Base paths to your bootstrap folders
S_PATH="/mnt/data2/Hassan/jana_test/mcms/new/S_contigs_multihitsep/Bootstrap"
N_PATH="/mnt/data2/Hassan/jana_test/mcms/new/N_contigs_multihitsep/Bootstrap"

# Main output directories
OUT_S="/mnt/data2/Hassan/jana_test/mcms/new/msmc_S"
OUT_N="/mnt/data2/Hassan/jana_test/mcms/new/msmc_N"

# Subdirectories for each setting
SETTING_1_S="$OUT_S/setting_1"
SETTING_2_S="$OUT_S/setting_2"
SETTING_1_N="$OUT_N/setting_1"
SETTING_2_N="$OUT_N/setting_2"

# Create output directories if they don't exist
mkdir -p $SETTING_1_S $SETTING_2_S $SETTING_1_N $SETTING_2_N

# Function to run msmc2 analysis
run_msmc2() {
    local PATH="$1"
    local OUT_DIR_1="$2/setting_1"
    local OUT_DIR_2="$2/setting_2"
    local PREFIX="$3"
    local COUNT=0

    for ((i=1; i<=20; i++)); do
        FOLDER="${PATH}/files_${i}"

        # Use the full path to the msmc2 executable and run in background
        (/usr/local/bin/msmc2 -t 20 -p 1*2+15*1+1*2 -o ${OUT_DIR_1}/${PREFIX}18seg.boot.msmc2.${i} ${FOLDER}/bootstrap_multihetsep.chr{1..18}.txt &&
         /usr/local/bin/msmc2 -t 20 -o ${OUT_DIR_2}/${PREFIX}32seg.boot.msmc2.${i} ${FOLDER}/bootstrap_multihetsep.chr{1..18}.txt) &

        # Increment the count
        ((COUNT++))

        # If 5 jobs are running, wait for them to complete
        if ((COUNT == 5)); then
            wait
            COUNT=0
        fi
    done

    # Wait for any remaining jobs to complete
    wait
}

# Run msmc2 analysis for S and N lineages
run_msmc2 $S_PATH $OUT_S "PolyS_"
run_msmc2 $N_PATH $OUT_N "PolyN_"

