# Packages ----------------------------------------------------------------
library(valr)
library(dplyr)
library(stringr)

# Data Import & Cleaning --------------------------------------------------
rd <- read_bed("./data/raw/sample_interval.bed") %>%
  mutate(chrom = ifelse(str_detect(chrom,"chr"), chrom, paste0("chr",chrom)))
