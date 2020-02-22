# Packages ----------------------------------------------------------------
library(valr)
library(dplyr)
library(stringr)
source("./src/evidence_functions.R")
source("./src/create_db.R")

# Data Import & Cleaning --------------------------------------------------
rd <- read_bed("./data/raw/sample_interval.bed", n_fields = 4) %>%
  mutate(chrom = ifelse(str_detect(chrom,"chr"), chrom, paste0("chr",chrom)))

custom_target <- "1: 27,020,254 - 27,022,634" %>% str_remove_all(",")
custom_chr    <- str_remove(custom_target, ":.*") %>% paste0("chr",.)
custom_start  <- str_remove(custom_target, ".*: ") %>% str_remove(" .*") %>% as.numeric()
custom_end    <- str_remove(custom_target, ".*- ") %>% as.numeric()
rd            <- tibble::tribble(~chrom, ~start, ~end, custom_chr, custom_start, custom_end,)

rd %>% 
  mutate(loss_1  = apply(rd, 1, function(x) loss_1(x)),
         loss_2a = apply(rd, 1, function(x) loss_2a(x)),
         loss_2b = apply(rd, 1, function(x) loss_2b(x)),
         loss_2c = apply(rd, 1, function(x) loss_2c(x)))
