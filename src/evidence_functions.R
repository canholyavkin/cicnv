loss_1 <- function(x) {
  query   <- trbl_interval(~ chrom, ~ start, ~ end, 
                           x[[1]], as.numeric(x[[2]]), as.numeric(x[[3]]))
  ifelse(nrow(bed_intersect(query, protein_coding_regions)) > 0 | 
           nrow(bed_intersect(query, hi_regions)) > 0 , 0, -0.6)
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

loss_2c <- function(x) {
  query   <- trbl_interval(~ chrom, ~ start, ~ end,
                           x[[1]], as.numeric(x[[2]]), as.numeric(x[[3]]))
  int_hi_genes_5p <- bed_intersect(query, hi_genes_5p) %>%
    mutate(complete_overlap = (.overlap == end.y - start.y))
  
  if_else(any(int_hi_genes_5p$complete_overlap), 1, 0.45)
}
