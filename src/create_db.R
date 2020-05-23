# The script generates the reference bed files
# https://genome.ucsc.edu/goldenpath/gbdDescriptionsOld.html

# Packages ----------------------------------------------------------------
library(tidyverse)
library(valr)

# RefSeq 105v2 ------------------------------------------------------------
refseq <- vroom::vroom("./data/reference/refseq_105v2.txt.gz",
                       col_types = cols(`Exon Starts` = col_character(),
                                        `Exon Stops` = col_character())) %>% 
  janitor::clean_names() %>% 
  mutate(chr = paste0("chr",chr)) %>% 
  rename(chrom = chr, end = stop, name = transcript_name)

# Protein Coding Regions --------------------------------------------------
# Data includes only protein coding (mRNA) genes
protein_coding_regions <- refseq %>% 
  filter(transcript_type=="mRNA") %>% 
  separate_rows(exon_starts, exon_stops, sep = ",") %>% 
  select(chrom, start = exon_starts, end = exon_stops, name, gene_name) %>% 
  mutate(start = as.numeric(start) + 1,
         end = as.numeric(end))

# Haploinsufficient Genes -------------------------------------------------
hi_genes <- read_delim("ftp://ftp.clinicalgenome.org/ClinGen_haploinsufficiency_gene_GRCh37.bed",
                       delim = "\t", skip = 1, col_names = F) %>%
  filter(X5 == 3) %>%
  select(chrom = X1, start = X2, end = X3, name = X4)

# Known Functionally Important Elements -----------------------------------
hi_regions <- read.delim("ftp://ftp.clinicalgenome.org/ClinGen_region_curation_list_GRCh37.tsv",
                         sep = "\t", skip = 5) %>%
  janitor::clean_names() %>% 
  filter(haploinsufficiency_score == 3) %>%
  mutate(chrom = str_remove(genomic_location, ":.*"),
         start = str_remove(genomic_location, "-.*") %>% str_remove(".*:") %>% str_trim(),
         end   = str_remove(genomic_location, ".*-")) %>%
  select(chrom, start, end, isca_region_name) %>%
  mutate(start = as.numeric(start),
         end   = as.numeric(end))


# Coding Region of Haploinsufficient Genes --------------------------------
hi_genes_coding <- refseq %>% 
  filter(transcript_type=="mRNA",
         gene_name %in% hi_genes$name) %>% 
  separate_rows(exon_starts, exon_stops, sep=",") %>% 
  mutate_at(vars(starts_with("cds") | starts_with("exon")), as.numeric) %>% 
  filter(!is.na(cds_start)) %>% 
  filter(cds_start < exon_stops,
         cds_stop > exon_starts) %>% 
  mutate(exon_starts = case_when(exon_starts < cds_start ~ cds_start,
                                 exon_starts >= cds_start ~ exon_starts),
         exon_stops = case_when(exon_stops > cds_stop ~ cds_stop,
                                exon_stops <= cds_stop ~ exon_stops)) %>% 
  select(chrom, start=exon_starts, end=exon_stops) %>% 
  bed_merge() %>% 
  bed_sorter()

# 5' Haploinsufficient Genes ----------------------------------------------
hi_genes_5p <- refseq %>%
  filter(gene_name %in% hi_genes$name,
         transcript_type == "mRNA") %>% 
  rename(cds_end = cds_stop) %>% 
  select(chrom, start, end, name, cds_start, cds_end, strand) %>% 
  mutate(start = as.character(start),
         end = as.character(end)) %>% 
  create_utrs5() %>% 
  mutate(start = as.numeric(start) + 1,
         end   = as.numeric(end))

# 3' Haploinsufficient Genes ----------------------------------------------
hi_genes_3p <- refseq %>%
  filter(gene_name %in% hi_genes$name,
         transcript_type == "mRNA") %>% 
  rename(cds_end = cds_stop) %>% 
  select(chrom, start, end, name, cds_start, cds_end, strand, gene_name) %>% 
  mutate(start = as.character(start),
         end = as.character(end)) %>% 
  create_utrs3() %>% 
  left_join(., select(refseq, gene_name, name), by = "name") %>% 
  mutate(start = case_when(strand == "+" ~ as.numeric(start),
                           strand == "-" ~ as.numeric(start) - 1),
         end   = as.numeric(end))
