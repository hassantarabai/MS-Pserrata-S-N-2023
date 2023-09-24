#!/bin/bash

# Define the samples with their path
declare -A samples=(
    ["12Mocb_N_Af"]="/mnt/data2/martij04/Polyplax_NGS/12Mocb_N_Af.sorted.bam"
    ["13ZD_SW"]="/mnt/data2/martij04/Polyplax_NGS/S_lineage_4_9_2022/13ZD_SW.sorted.bam"
    ["14AFOB_N_Af"]="/mnt/data2/martij04/Polyplax_NGS/14AFOB_N_Af.sorted.bam"
    ["15KOCb_SE"]="/mnt/data2/martij04/Polyplax_NGS/S_lineage_4_9_2022/15KOCb_SE.sorted.bam"
    ["19Moc_N_As"]="/mnt/data2/martij04/Polyplax_NGS/19Moc_N_As.sorted.bam"
    ["1JAAp1b_SW"]="/mnt/data2/martij04/Polyplax_NGS/S_lineage_4_9_2022/1JAAp1b_SW.sorted.bam"
    ["21AbAf3_N_As"]="/mnt/data2/martij04/Polyplax_NGS/21AbAf3_N_As.sorted.bam"
    ["2HBb_SW"]="/mnt/data2/martij04/Polyplax_NGS/S_lineage_4_9_2022/2HBb_SW.sorted.bam"
    ["6ASPOB_N_As"]="/mnt/data2/martij04/Polyplax_NGS/6ASPOB_N_As.sorted.bam"
    ["7KOCc_SE"]="/mnt/data2/martij04/Polyplax_NGS/S_lineage_4_9_2022/7KOCc_SE.sorted.bam"
    ["KO_78_N_Af"]="/mnt/data2/martij04/Polyplax_NGS/KO_78_N_Af.sorted.bam"
    ["KO_82bN_As"]="/mnt/data2/martij04/Polyplax_NGS/KO_82bN_As.sorted.bam"
    ["SoNet29_N_As"]="/mnt/data2/martij04/Polyplax_NGS/SoNet29_N_As.sorted.bam"
    ["VII13_SW"]="/mnt/data2/martij04/Polyplax_NGS/VII13_SW.sorted.bam"
    ["RAD51c_SE"]="/mnt/data2/martij04/Polyplax_NGS/RAD51c_SE.sorted.bam"
    ["RAD44b_SE"]="/mnt/data2/martij04/Polyplax_NGS/RAD44b_SE.sorted.bam"
)

# Define the contigs
declare -a contigs=(
    "scaffold3310" "scaffold710" "scaffold110" "scaffold1510" "contig210a" "contig210b"
    "contig2010" "contig14870100" "contig45166900" "contig1410" "contig2355090" "contig610"
    "contig1010" "contig2910" "contig2210" "contig14010" "contig22010" "contig5010"
)

# Check and create indices for BAM files
for sample in "${!samples[@]}"; do
    if [ ! -f "${samples["$sample"]}.bai" ]; then
        echo "Creating index for ${samples["$sample"]}..."
        samtools index "${samples["$sample"]}"
    fi
done

output_directory="/mnt/data2/Hassan/jana_test/mcms/bam_call/"

process_sample() {
    sample_name=$1
    sample_path=${samples["$sample_name"]}
    contig=$2

    output_name="${output_directory}${sample_name}_${contig}.vcf.gz"
    command="bcftools mpileup -q 20 -Q 20 -C 50 -r $contig -f /mnt/data2/martij04/Poly_Genome_annotation/Poly_assembly_outLeg_host_89contigs.fasta $sample_path | bcftools call -c -V indels | ./bamcaller.py 20 ${output_name}.bed.gz | gzip -c > $output_name"
    echo "Executing: $command"
    eval $command
}

export -f process_sample

# Iterate over each sample and contig to process them
for sample in "${!samples[@]}"; do
    for contig in "${contigs[@]}"; do
        process_sample $sample $contig
    done
done

