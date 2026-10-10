# Computational Environment

## Operating System

Ubuntu 26.04.1 LTS running inside VirtualBox.

## Hardware

- RAM allocated: 8 GB
- CPU: 2 cores
- Storage: approximately 70 GB dynamic virtual disk

## Software

| Software | Version | Purpose |
|---|---|---|
| FastQC | 0.12.1 | FASTQ quality control |
| NanoPlot | 1.48.0 | Nanopore read QC |
| SeqKit | 2.10.1 | FASTQ processing and subsampling |
| minimap2 | 2.27-r1193 | Nanopore read alignment |
| SAMtools | 1.22.1 | Alignment file processing |
| BCFtools | 1.22 | Variant calling and filtering |
| Python | 3.14 | Supporting environment |
| Git | Installed | Version control |

## Reference Genome

**GRCh38.p14**

NCBI accession:

`GCF_000001405.40`

## Variant Database

**ClinVar**

ClinVar GRCh38 VCF was used for candidate variant annotation.

## Reproducibility

The analysis commands used for the primary sample are provided in:

`scripts/nanopore_workflow.sh`

The workflow was developed in a Linux environment and used a reproducible random seed for the 10,000-read subsampling step.
