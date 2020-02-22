# CICNV - Clinical Interpreter for Copy Number Variations
This tool allows annotation of single or multiple genomic intervals according to the guideline of American College of Medical Genetics and Genomics (ACMG) and the Clinical Genome Resource (ClinGen) publised on 2019.<sub>**1**</sub> All The Haplosuccificieny scores were obtained from The Clinical Genome Resource (ClinGen) consortium.<sub>**1**</sub>



## Current Status
- **23.02.2020** - L2A and L2B evidences are added.
- **21.02.2020** - Reference database changed to RefSeq from UCSC. L2A and L2B evidences removed.
- **20.02.2020** - Protein-coding-genes database are replaced with protein-coding-regions database to eliminate the intronic regions.
- **19.02.2020** - Evidence code G1A function and protein-coding gene database are added.

# Evidence Criteria
**Loss 1.A & Loss 1.B**
If the submitted CNV (loss) has overlap (>1bp) with exonic/UTR region of any protein-coding gene or with regions that have sufficient evidence for dosage pathogenicity (Haploinsufficiency score = 3) it recieves 0 score, otherwise recieves -0.6. 

**Loss 2.A**
If the submitted CNV (loss) has complete overlap with established dosage sensitive genes (Haploinsufficiency score = 3) or genomic regions (Haploinsufficiency score = 3) it recieves 1.00 score, otherwise recieves 0.00.

**Loss 2.B**
If the submitted CNV (loss) has partial overlap (>1bp) with established dosage sensitive genes (Haploinsufficiency score = 3) or genomic regions (Haploinsufficiency score = 3) it recieves 0.00 score, otherwise recieves 0.00.

# References
[1] Riggs, E. R., Andersen, E. F., Cherry, A. M., Kantarci, S., Kearney, H., Patel, A. et al. (2019). Technical standards for the interpretation and reporting of constitutional copy-number variants: a joint consensus recommendation of the American College of Medical Genetics and Genomics (ACMG) and the Clinical Genome Resource (ClinGen). Genet Med.
[2] Riggs, E. R., Nelson, T., Merz, A., Ackley, T., Bunke, B., Collins, C. D. et al. (2018). Copy number variant discrepancy resolution using the ClinGen dosage sensitivity map results in updated clinical interpretations in ClinVar. Hum Mutat, 39(11), 1650-1659.