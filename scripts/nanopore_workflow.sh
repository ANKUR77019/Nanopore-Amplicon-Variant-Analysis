#!/bin/bash

# Nanopore Amplicon Variant Analysis
# Primary sample: SRR14455399
# Reference: GRCh38.p14

# 1. Quality Control
fastqc raw/SRR14455399_1.fastq.gz -o qc/

NanoPlot --fastq raw/SRR14455399_1.fastq.gz -o qc/nanoplot_SRR14455399

# 2. Read Subsampling
seqkit sample -n 10000 -s 12345 \
raw/SRR14455399_1.fastq.gz \
-o working/SRR14455399_10k.fastq.gz

# 3. Reference Index
samtools faidx reference/GCF_000001405.40_GRCh38.p14_genomic.fna

# 4. Nanopore Read Alignment
minimap2 -t 1 -ax map-ont \
-I 500M \
--split-prefix=GRCh38_split \
reference/GCF_000001405.40_GRCh38.p14_genomic.fna \
working/SRR14455399_10k.fastq.gz \
> alignment/SRR14455399_10k.sam

# 5. SAM to BAM
samtools view -b \
alignment/SRR14455399_10k.sam \
-o alignment/SRR14455399_10k.bam

# 6. BAM Sorting
samtools sort \
alignment/SRR14455399_10k.bam \
-o alignment/SRR14455399_10k.sorted.bam

# 7. BAM Indexing
samtools index \
alignment/SRR14455399_10k.sorted.bam

# 8. Alignment Statistics
samtools flagstat \
alignment/SRR14455399_10k.sorted.bam

# 9. Variant Calling
bcftools mpileup \
-f reference/GCF_000001405.40_GRCh38.p14_genomic.fna \
alignment/SRR14455399_10k.sorted.bam \
-o working/SRR14455399.mpileup.bcf

bcftools call -mv \
working/SRR14455399.mpileup.bcf \
-Ov \
-o variants/SRR14455399.raw.vcf

# 10. Candidate Variant Filtering
bcftools filter \
-i 'INFO/DP>=20 && QUAL>=20 && FORMAT/AD[0:1]/(FORMAT/AD[0:0]+FORMAT/AD[0:1])>=0.20' \
variants/SRR14455399.raw.vcf \
-Ov \
-o variants/SRR14455399.filtered.vcf

# 11. ClinVar Annotation
bcftools annotate \
-a reference/clinvar.vcf.gz \
-c INFO/CLNSIG,INFO/CLNDN,INFO/GENEINFO,INFO/CLNREVSTAT,INFO/CLNHGVS \
variants/SRR14455399.clinvar_ready.vcf.gz \
-Oz \
-o variants/SRR14455399.clinvar_annotated.vcf.gz
