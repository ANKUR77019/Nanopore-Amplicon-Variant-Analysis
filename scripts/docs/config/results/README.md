# Nanopore Amplicon Variant Analysis

A reproducible bioinformatics workflow for analysis of Oxford Nanopore
amplicon sequencing data, covering quality assessment, reference
alignment, BAM processing, variant calling, candidate variant filtering,
and ClinVar annotation.

---

## Project Overview

This project demonstrates an end-to-end analysis workflow for Oxford
Nanopore amplicon sequencing data.

The workflow starts from raw Nanopore FASTQ reads and proceeds through
quality control, alignment to the human GRCh38 reference genome, variant
calling, exploratory candidate filtering, and ClinVar annotation.

### Workflow

```text
Raw Nanopore FASTQ
        |
        v
Quality Control
(FastQC / NanoQC / NanoPlot)
        |
        v
10,000-read Working Subset
        |
        v
GRCh38 Reference Genome
        |
        v
Read Alignment
(minimap2)
        |
        v
SAM → BAM
(samtools)
        |
        v
Sorting & Indexing
(samtools)
        |
        v
Variant Calling
(bcftools mpileup + call)
        |
        v
Raw VCF
        |
        v
Candidate Variant Filtering
(DP / QUAL / Allele Fraction)
        |
        v
Filtered Candidate Variants
        |
        v
ClinVar Annotation
        |
        v
Clinical Significance Interpretation
Objectives

The main objectives of this project were to:

Assess the quality of Oxford Nanopore sequencing reads.
Align Nanopore reads to the GRCh38 human reference genome.
Process alignments into sorted and indexed BAM files.
Identify candidate variants using bcftools.
Apply an exploratory variant filtering strategy.
Compare filtered candidate variants with ClinVar.
Interpret the reported clinical significance of matching ClinVar records.
Organize the workflow into reproducible command-line scripts.
Dataset
Sequencing platform
Oxford Nanopore MinION
Sequencing type: Amplicon sequencing

Four Nanopore datasets were available:

Sample
SRR14455399
SRR14455431
SRR14455433
SRR14455446

The completed workflow documented in this repository currently focuses
on the initial analysis of:

SRR14455399

A standardized 10,000-read subset was used for the initial workflow
development and variant analysis.

Tools Used
Tool	Purpose
FastQC	General sequencing quality assessment
NanoQC	Nanopore-specific quality assessment
NanoPlot	Nanopore read length and quality assessment
SeqKit	FASTQ statistics and read subsampling
minimap2	Alignment of Nanopore reads to GRCh38
samtools	SAM/BAM processing, sorting and indexing
bcftools	Variant evidence generation and variant calling
ClinVar	Clinical variant annotation
Linux/Ubuntu	Command-line analysis environment
Sample 1: SRR14455399
Raw sequencing data
Metric	Result
Reads	40,000
Total bases	34,595,009
Mean read length	864.9 bp
Median read length	692 bp
N50	1,098 bp
Mean quality	Q10.1
Reads > Q10	62.5%
Reads > Q15	~0%
Reads > Q20	0
GC	~53.3%
Longest read	7,428 bp

FastQC showed several quality/composition warnings or failures,
including per-base sequence quality, per-sequence quality scores,
per-base sequence content and overrepresented sequences.

These QC observations were not treated as an automatic reason to
discard the dataset.

Read Subsampling

A reproducible 10,000-read working subset was generated from the
original FASTQ file.

The original FASTQ file was retained unchanged.

The working subset contained:

10,000 reads
8,602,457 bases
Mean read length: 860.2 bp
Minimum read length: 80 bp
Maximum read length: 5,985 bp

The 10,000-read subset represents a standardized working subset and
should not be interpreted as 10,000× sequencing coverage.

Reference Genome

The human reference genome used for alignment was:

GRCh38.p14

Reference:

GCF_000001405.40_GRCh38.p14_genomic.fna

A FASTA index was generated using samtools faidx.

Alignment

Nanopore reads were aligned to GRCh38 using:

minimap2 — map-ont preset

Because the analysis was performed in a memory-limited virtual machine,
a split-index alignment strategy was used.

Alignment result
Metric	Result
Primary reads	10,000
Primary mapped reads	9,784
Primary mapping rate	97.84%

Secondary and supplementary alignment records were also present.

The total number of alignment records should therefore not be interpreted
as the number of sequencing reads.

A high mapping rate indicates that most primary reads could be aligned
to the reference, but mapping rate alone does not establish alignment
correctness or variant validity.

BAM Processing

The alignment workflow included:

SAM
 ↓
BAM
 ↓
Sorted BAM
 ↓
BAM Index

samtools was used for:

SAM to BAM conversion
BAM sorting
BAM indexing
Alignment statistics

The final alignment files included:

SRR14455399_10k.sorted.bam
SRR14455399_10k.sorted.bam.bai
Variant Calling

Variant calling was performed using:

bcftools mpileup
bcftools call

bcftools mpileup was used to generate base-level evidence from the
aligned reads.

bcftools call was then used to identify candidate variants.

Result

153 raw candidate variants were identified.

Variant Filtering

An exploratory working filter was applied using:

DP ≥ 20
QUAL ≥ 20
Alternate allele fraction ≥ 20%
Result
Raw candidate variants:       153
Filtered candidate variants:   36

The purpose of this filtering step was to prioritize candidate variants
with greater supporting read depth, variant quality and alternate allele
fraction.

Important

These thresholds represent an exploratory working filter.

They are not a clinically validated variant-filtering strategy.

ClinVar Annotation

The filtered candidate variants were compared with the GRCh38 ClinVar
database.

ClinVar annotation included fields such as:

CLNSIG
CLNDN
GENEINFO
CLNREVSTAT
CLNHGVS

Because chromosome naming conventions differed between the reference
VCF and ClinVar, chromosome identifiers were normalized before
annotation.

Result

Of the 36 filtered candidate variants:

3 had matching ClinVar clinical-significance annotations.

Gene	Variant	DP	ClinVar significance
ARID1A	chr1:26729693 C>T	67	Uncertain significance
CTNNB1	chr3:41224622 C>G	273	Pathogenic/Likely pathogenic
TP53	chr17:7673802 C>T	238	Pathogenic
ClinVar Interpretation
ARID1A

The matching ClinVar record was classified as:

Uncertain significance

and had a single-submitter review status.

CTNNB1

The matching ClinVar record was classified as:

Pathogenic/Likely pathogenic

with no assertion criteria provided in the matching record.

TP53

The matching ClinVar record was classified as:

Pathogenic

with an expert-panel review status.

Important Interpretation Caveat

A ClinVar match represents the clinical interpretation reported for
the corresponding database record.

It does not by itself establish that:

the sample has the associated disease,
the detected variant caused disease,
the variant is somatic,
the variant is germline,
or the candidate variant has been independently validated.

Therefore, the variants are described as candidate variants matching
ClinVar records, rather than confirmed disease-causing or confirmed
somatic mutations.

Trimming

No separate adapter or quality-trimming step was performed in the
current workflow.

The Nanopore reads were first assessed using quality-control tools and
then taken forward for alignment.

Trimming was not included because it was not part of the workflow
specified for this project.

This does not imply that Nanopore data can never require trimming;
trimming may be appropriate depending on the sequencing protocol,
adapter contamination and downstream analysis requirements.

Primer/BED Analysis

Primer reconstruction and BED-file generation were explored during
workflow development but were not included in the final project
workflow.

The final workflow therefore does not depend on:

Primer mapping
Primer reconstruction
Custom primer BED generation
Computational Considerations

The analysis was performed in an Ubuntu virtual-machine environment
with limited available memory.

A memory-conscious split-index strategy was used for minimap2 alignment
to the complete GRCh38 reference.

This demonstrated the importance of considering computational resources
when working with large reference genomes and sequencing datasets.

Reproducibility

The project is being organized as a reproducible command-line workflow.

The repository contains:

scripts/   → analysis scripts
docs/      → workflow and detailed documentation
config/    → sample information
results/   → summarized results

Large sequencing and reference files are intentionally not stored in
the GitHub repository.

Limitations

This project represents an exploratory bioinformatics workflow rather
than a clinically validated diagnostic pipeline.

Important limitations include:

Variant filtering thresholds were exploratory.
A 10,000-read working subset was used for the initial analysis.
Mapping rate alone does not establish alignment correctness.
Secondary and supplementary alignments were observed.
ClinVar annotation does not establish disease causation in the sample.
Somatic versus germline status was not established.
Candidate variants were not independently experimentally validated.
The workflow was not designed as a clinical-grade reporting pipeline.
Key Skills Demonstrated
Sequencing and NGS
Oxford Nanopore sequencing data
FASTQ quality assessment
Long-read alignment
Variant calling
VCF interpretation
Bioinformatics Tools
FastQC
NanoQC
NanoPlot
SeqKit
minimap2
samtools
bcftools
ClinVar
Computational Skills
Linux command line
Bash scripting
File organization
Compression and indexing
Reproducible workflows
Computational resource management
Project Status

Current status: Initial workflow completed for SRR14455399.

Four Nanopore samples were available for the project. The documented
completed workflow currently covers the initial sample and provides a
reproducible framework that can be applied to the remaining datasets.

Repository Structure
nanopore-amplicon-variant-analysis/
│
├── README.md
│
├── scripts/
│
├── docs/
│
├── config/
│
└── results/

---

## Then commit it

At the bottom:

**Commit changes**

Use the commit message:

```text
Add project README

