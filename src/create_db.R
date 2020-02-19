# The script generates the reference bed files
# https://genome.ucsc.edu/goldenpath/gbdDescriptionsOld.html

# Packages ----------------------------------------------------------------
library(RMySQL)
library(valr)
library(tidyverse)


# Protein Coding Genes ----------------------------------------------------
db <- db_ucsc("hg19")

protein_coding_genes <- collect(tbl(db, "knownGene"))

protein_coding_genes %>% 
  filter(proteinID != "") %>% 
  mutate(exonStarts = str_remove(exonStarts, ",$"),
         exonEnds   = str_remove(exonEnds, ",$")) %>% 
  separate_rows(exonStarts, exonEnds, sep = ",") %>% # Regions (Removing of intronic regions)
  select(chrom, start = exonStarts, end = exonEnds, name) %>% 
  write.table("./data/reference/protein_coding_regions.bed",
              row.names = F, quote = F, sep = "\t", col.names = F)
