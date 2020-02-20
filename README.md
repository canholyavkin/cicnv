# CICNV - Clinical Interpreter for Copy Number Variations
This tool allows annotation of single or multiple genomic intervals according to the guideline of American College of Medical Genetics and Genomics (ACMG) and the Clinical Genome Resource (ClinGen) publised on 2019.[1]

[1] Riggs, E. R., Andersen, E. F., Cherry, A. M., Kantarci, S., Kearney, H., Patel, A. et al. (2019). Technical standards for the interpretation and reporting of constitutional copy-number variants: a joint consensus recommendation of the American College of Medical Genetics and Genomics (ACMG) and the Clinical Genome Resource (ClinGen). Genet Med.

## Current Status
- **21.02.2020** - Reference database changed to RefSeq from UCSC. L2A and L2B evidences removed.
- **20.02.2020** - Protein-coding-genes database are replaced with protein-coding-regions database to eliminate the intronic regions.
- **19.02.2020** - Evidence code G1A function and protein-coding gene database are added.

# Evidences
## Loss 1.A & Loss 1.B
If the CNV contains or overlaps protein-coding exonic regions it is flagged as L1A.

## Loss 2.A
the CNV is evaluated for complete overlap with established dosage sensitive genes or genomic regions it is flagged as L2A.

## Loss 2.B
the CNV is evaluated for partial overlap with established dosage sensitive genes or genomic regions it is flagged as L2B.