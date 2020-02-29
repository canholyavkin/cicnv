query_parser <- function(x) {
  custom_target <- x %>% str_remove_all(",")
  custom_chr    <- str_remove(custom_target, ":.*") %>% paste0("chr",.)
  custom_start  <- str_remove(custom_target, ".*: ") %>% str_remove(" .*") %>% as.numeric()
  custom_end    <- str_remove(custom_target, ".*- ") %>% as.numeric()
  return(tibble::tribble(~chrom, ~start, ~end, custom_chr, custom_start, custom_end))
}

loss_1 <- function(x) {
  query = query_parser(x)
  ol_pc_regions = bed_intersect(query, protein_coding_regions)
  ol_hi_regions = bed_intersect(query, hi_regions)
  if (nrow(ol_pc_regions) > 0 | nrow(ol_hi_regions) > 0) {
    print("The region contains protein-coding or other known functionally important elements. (Score: 0.00 - Continue evaluation")
  } else("The region Does NOT contain protein-coding or any known functionally important elements. (Score: -0.60)")
}

loss_2a <- function(x) {
  query   <- trbl_interval(~ chrom, ~ start, ~ end,
                           x[[1]], as.numeric(x[[2]]), as.numeric(x[[3]]))
  int_hi_genes <- bed_intersect(query, hi_genes) %>%
    filter(.overlap == end.y - start.y)
  
  int_hi_regions <- bed_intersect(query, hi_regions) %>%
    filter(.overlap == end.y - start.y)
  
  if_else(nrow(int_hi_genes) > 0 | nrow(int_hi_regions) > 0, 1, 0)
}

loss_2b <- function(x) {
  query   <- trbl_interval(~ chrom, ~ start, ~ end,
                           x[[1]], as.numeric(x[[2]]), as.numeric(x[[3]]))
  int_hi_genes <- bed_intersect(query, hi_genes) %>%
    filter(.overlap < end.y - start.y)
  
  int_hi_regions <- bed_intersect(query, hi_regions) %>%
    filter(.overlap < end.y - start.y)
  
  if_else(nrow(int_hi_genes) > 0 | nrow(int_hi_regions) > 0, T, F)
}

loss_2c1 <- function(x) {
  query <- query_parser(x)
  ol_3p_regions <- bed_intersect(query, hi_genes_3p)
  if (nrow(ol_3p_regions) == 0) {   # If query has no overlap with 3P of HI
    ol_5p_regions = bed_intersect(query, hi_genes_5p)
    if (nrow(ol_5p_regions) == 0) {
      print("FALSE. The region has no overlap with 5' of a haploinsuficient gene.")
    }
  } else {
    print(paste0("FALSE. ",
                 "The region has overlap with 3' of a haploinsuficient gene (",
                 paste(unique(ol_3p_regions$gene_name.y), collapse = ", "),
                 ")."))
  }
}