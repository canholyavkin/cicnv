# The script generates the reference bed files
# https://genome.ucsc.edu/goldenpath/gbdDescriptionsOld.html

# Packages ----------------------------------------------------------------
library(RMySQL)
library(valr)
library(dplyr)


# Protein Coding Genes ----------------------------------------------------
db <- db_ucsc("hg19")

protein_coding_genes <- collect(tbl(db, "knownGene"))

protein_coding_genes %>% 
  filter(proteinID != "") %>% 
  select(chrom, start = txStart, end = txEnd, name) %>% 
  write.table("./data/reference/protein_coding_genes.bed",
              row.names = F, quote = F, sep = "\t", col.names = F)
