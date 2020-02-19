# Packages ----------------------------------------------------------------
library(valr)
library(dplyr)
library(stringr)

# Data Import & Cleaning --------------------------------------------------
rd <- read_bed("./data/raw/sample_interval.bed", n_fields = 4) %>%
  mutate(chrom = ifelse(str_detect(chrom,"chr"), chrom, paste0("chr",chrom)))


custom_target <- "1: 870,854 - 871,078" %>% str_remove_all(",")
custom_chr    <- str_remove(custom_target, ":.*") %>% paste0("chr",.)
custom_start  <- str_remove(custom_target, ".*: ") %>% str_remove(" .*") %>% as.numeric()
custom_end    <- str_remove(custom_target, ".*- ") %>% as.numeric()

rd <- tibble::tribble(
  ~chrom, ~start, ~end, custom_chr, custom_start, custom_end,
)

protein_coding_regions <- read_bed("./data/reference/protein_coding_regions.bed.gz", 
                                   n_fields = 4)

fevid_1 <- function(x) {
  target <- trbl_interval(~ chrom, ~ start, ~ end, 
                          x[[1]], as.numeric(x[[2]]), as.numeric(x[[3]]))
  bed_intersect(target, protein_coding_regions) %>% nrow() != 0
}


rd %>% 
  mutate(ev1 = apply(rd, 1, function(x) fevid_1(x)))
