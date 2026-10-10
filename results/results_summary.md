# Results Summary

## Sample Analyzed

The documented workflow was demonstrated using:

**Sample:** SRR14455399_1.fastq.gz  
**Sample ID:** SRR14455399  
**Sequencing platform:** Oxford Nanopore

## Quality Control

The raw dataset contained:

| Metric | Result |
|---|---:|
| Total reads | 40,000 |
| Total bases | 34,595,009 |
| Mean read length | 864.9 bp |
| Median read length | 692 bp |
| N50 | 1,098 bp |
| Mean read quality | Q10.1 |
| GC content | ~53% |

The FastQC and NanoPlot results indicated variable read quality, which is typical of Nanopore sequencing data.

## Subsampled Dataset

A reproducible subset of **10,000 reads** was generated using SeqKit.

The subset contained approximately:

- 8.6 Mb total sequence
- Mean read length: ~860 bp

This subset was used for the downstream alignment and variant analysis.

## Alignment

The reads were aligned to the **GRCh38.p14** human reference genome using minimap2 with the Oxford Nanopore `map-ont` preset.

Alignment statistics for the 10,000-read subset were:

| Metric | Result |
|---|---:|
| Primary reads | 10,000 |
| Primary mapped reads | 9,784 |
| Primary mapping rate | 97.84% |

The alignment also contained secondary and supplementary alignment records. Therefore, the total number of alignment records should not be interpreted as the number of sequencing reads.

## Variant Calling

Variant calling was performed using BCFtools.

The initial variant-calling step produced:

**153 candidate variants**

An exploratory filtering step was applied using:

- DP ≥ 20
- QUAL ≥ 20
- Alternate allele fraction ≥ 20%

After filtering:

**36 candidate variants remained**

These were considered candidate variants and were not treated as clinically validated calls.

## ClinVar Annotation

The filtered candidate variants were compared with the ClinVar database.

Three candidate variants had corresponding ClinVar annotations involving:

| Gene | ClinVar classification |
|---|---|
| ARID1A | Uncertain significance |
| CTNNB1 | Pathogenic/Likely pathogenic |
| TP53 | Pathogenic |

The TP53 variant had an expert-panel review status in ClinVar.

The ClinVar classification describes the database's existing interpretation of the variant. It does not by itself establish that the variant is disease-causing in this particular sample.

## Overall Outcome

The analysis successfully demonstrated the following Nanopore variant-analysis workflow:

**Quality Control → Subsampling → GRCh38 Alignment → BAM Processing → Variant Calling → Candidate Filtering → ClinVar Annotation**

The workflow produced a set of candidate variants and identified three candidates with corresponding ClinVar annotations.

## Important Limitations

- The documented downstream analysis used a 10,000-read subset rather than the complete sequencing dataset.
- The candidate variants were not experimentally validated.
- ClinVar matches were used for database annotation and not as evidence of clinical diagnosis.
- Some filtered variants showed relatively low mapping-quality values and therefore require additional validation before biological or clinical interpretation.
- The workflow was demonstrated on one primary sample.
