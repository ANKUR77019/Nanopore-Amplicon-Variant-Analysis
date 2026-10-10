# Methods

## Overview

This project follows a reproducible Oxford Nanopore amplicon sequencing workflow for quality assessment, read alignment, variant calling, candidate variant filtering, and ClinVar annotation.

The workflow was demonstrated using **SRR14455399_1.fastq.gz** as the primary sample.

## Quality Control

Raw Nanopore FASTQ reads were assessed before downstream analysis using **FastQC** and **NanoPlot**. The QC analysis evaluated read count, read length distribution, base quality, GC content, and other sequence-level characteristics.

For the primary sample, 40,000 reads containing approximately 34.6 Mb of sequence were assessed. The mean read length was approximately 865 bp, with an N50 of 1,098 bp and a mean read quality of approximately Q10.

No separate adapter or quality-trimming step was applied in the documented workflow. The reads were retained after QC and used for downstream analysis.

## Read Subsampling

For computationally efficient workflow development, a reproducible subset of **10,000 reads** was randomly selected from the primary sample using SeqKit with a fixed random seed.

This subset was used for the subsequent alignment and variant-calling steps.

## Reference Genome and Alignment

The human **GRCh38.p14** reference genome was obtained from NCBI and indexed using SAMtools.

Nanopore reads were aligned to the reference genome using **minimap2** with the `map-ont` preset. A split-index approach was used because the complete minimap2 index exceeded the available memory of the virtual machine.

The alignment produced a SAM file, which was converted to BAM format, sorted, and indexed using SAMtools.

For the 10,000-read subset, 9,784 primary reads were mapped, giving a **97.84% primary mapping rate**.

## Variant Calling and Filtering

Variants were called from the aligned reads using **BCFtools**. The workflow consisted of generating a pileup with `bcftools mpileup` followed by variant calling with `bcftools call`.

The initial variant-calling step produced **153 candidate variants**.

An exploratory filtering step was then applied using:

- Read depth (DP) ≥ 20
- Variant quality (QUAL) ≥ 20
- Alternate allele fraction ≥ 20%

After filtering, **36 candidate variants** remained.

These variants were considered candidate calls and were not treated as clinically validated variants.

## ClinVar Annotation

The filtered candidate variants were compared against the **ClinVar** database using BCFtools annotation.

The annotation included clinical significance, associated condition information, gene information, review status, and HGVS genomic descriptions where available.

Three candidate variants had corresponding ClinVar annotations. These included variants associated with **ARID1A, CTNNB1, and TP53**.

The ClinVar classifications represent database annotations and should not be interpreted as proof that a variant is disease-causing in the sequenced sample. Additional validation and biological/clinical interpretation would be required.

## Software Used

| Tool | Purpose |
|---|---|
| FastQC | General sequencing quality assessment |
| NanoPlot | Nanopore read quality assessment |
| SeqKit | Read statistics and reproducible subsampling |
| minimap2 | Nanopore read alignment |
| SAMtools | SAM/BAM processing and alignment statistics |
| BCFtools | Variant calling, filtering, and annotation |
| ClinVar | Clinical variant database for annotation |

## Workflow

The final documented workflow was:

**Raw Nanopore FASTQ → Quality Control → Read Subsampling → GRCh38 Alignment → SAM/BAM Processing → Variant Calling → Candidate Filtering → ClinVar Annotation**

## Notes and Limitations

The analysis was performed using a 10,000-read subset of the primary Nanopore sample for computationally efficient workflow development. The resulting variants should therefore be considered candidate variants rather than final clinical or research-grade mutation calls.

Primer reconstruction and target-specific BED generation were not included in the final workflow.

The workflow demonstrates the core steps of Nanopore sequence quality assessment, reference alignment, variant identification, filtering, and database-based clinical annotation.
