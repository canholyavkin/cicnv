# Packages ----------------------------------------------------------------
library(valr)
library(dplyr)
library(stringr)

# Data Import & Cleaning --------------------------------------------------
rd <- read_bed("./data/raw/sample_interval.bed", n_fields = 4) %>%
  mutate(chrom = ifelse(str_detect(chrom,"chr"), chrom, paste0("chr",chrom)))

protein_coding_genes <- read_bed("./data/reference/protein_coding_genes.bed", 
                                 n_fields = 4)

fevid_1 <- function(x) {
  target <- trbl_interval(~ chrom, ~ start, ~ end, 
                          x[[1]], as.numeric(x[[2]]), as.numeric(x[[3]]))
  bed_intersect(target, protein_coding_genes) %>% nrow() != 0
}


rd %>% 
  mutate(ev1 = apply(rd, 1, function(x) fevid_1(x)))
