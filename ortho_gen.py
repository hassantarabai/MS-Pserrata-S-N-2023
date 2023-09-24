import os
from Bio import SeqIO

# Convert Nexus file to FASTA format
records = SeqIO.parse("input.nexus", "nexus")
count = SeqIO.write(records, "output_converted_nexus.fasta", "fasta")
print(f"Converted {count} records")

def extract_subsets_from_fasta(fasta_file, partition_file):
    sequences = {}
    subset_coords = {}
    
    # Parse the FASTA file and group sequences by species
    with open(fasta_file, 'r') as file:
        current_species = ''
        current_sequence = ''
        for line in file:
            line = line.strip()
            if line.startswith('>'):
                if current_species and current_sequence:
                    sequences.setdefault(current_species, []).append(current_sequence)
                current_species = line[1:]
                current_sequence = ''
            else:
                current_sequence += line
        if current_species and current_sequence:
            sequences.setdefault(current_species, []).append(current_sequence)
    
    # Extract subset coordinates from the partition file
    with open(partition_file, 'r') as file:
        for line in file:
            line = line.strip()
            if line:
                subset, coords = line.split(' = ')
                coords = coords.split(',')[0].strip()
                start, end = extract_coordinates(coords)
                subset_coords[subset] = (start, end)

    species_files = {}
    
    # Generate sequences for each subset and species
    for species, contigs in sequences.items():
        species_file = ''
        for subset, (start, end) in subset_coords.items():
            subset_sequence = ''
            for contig in contigs:
                subset_sequence += contig[start - 1:end]
            species_file += f'>{subset}\n{subset_sequence}\n'
        species_files[species] = species_file

    return species_files

def extract_coordinates(coords):
    if '-' in coords:
        start, end = coords.split('-')
    else:
        start, end = coords.split(',')
    return int(start), int(end)

# Process the converted FASTA file
fasta_file = 'output_converted_nexus.fasta'
partition_file = 'partition_file.txt'
species_files = extract_subsets_from_fasta(fasta_file, partition_file)

#Ask for output folder
output_folder = input("Please enter the path to the output folder: ")

# Create the output folder if it doesn't exist
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# Save each species' subset orthologue sequences to separate FASTA files
for species, file_content in species_files.items():
    output_file = os.path.join(output_folder, f'{species}.fasta')
    with open(output_file, 'w') as file:
        file.write(file_content)
