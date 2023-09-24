# **MS-Pserrata-SN-2023**
A reposatory providing scripts used in the analysis of genomic and phylogenetic data included in the publication titled "....".

## **Phylogenetic dating**
### **ortho_gen.py**
Used in obtaining sets of orthologs in fasta format corresponding to different arthropods' species from a nexus format ortholog alignment file sourced from [de Moya et al 2020](https://academic.oup.com/sysbio/article/70/4/719/5912026). The script requires [Biopython](https://biopython.org/) for its function. 

## **Population demography**
### **bamcall_multi.sh**
Utilizing [bamCaller.py](https://github.com/stschiff/msmc-tools) to iterate over a list of bam files and defined contigs and generate and output of single VCF and a mask file in bed format per sample/contig combination.

Requires:
- bamCaller.py
- [utils.py](https://github.com/stschiff/msmc-tools)
- [samtools](http://www.htslib.org/download/)
- [bcftools](http://www.htslib.org/download/)

### ***




