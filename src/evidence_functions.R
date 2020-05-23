query_parser <- function(x) {
  custom_target <- x %>% str_remove_all(",") %>% str_remove_all(" ")
  custom_chr    <- str_remove(custom_target, ":.*") %>% paste0("chr",.)
  custom_start  <- str_remove(custom_target, ".*\\:") %>% str_remove("-.*") %>% as.numeric()
  custom_end    <- str_remove(custom_target, ".*-") %>% str_remove_all("loss|gain") %>% as.numeric()
  return(tibble::tribble(~chrom, ~start, ~end, custom_chr, custom_start, custom_end))
}

bed_sorter <- function(x) {
  x %>% 
    dplyr::mutate(chrom = factor(chrom, levels = paste0("chr",c(1:22,"X","Y")))) %>% 
    dplyr::arrange(chrom, start) %>% 
    return()
}

loss_1 <- function(x) {
  query = query_parser(x)
  ol_pc_regions = bed_intersect(query, protein_coding_regions) # Checks >1bp overlaps with protein coding genes
  ol_hi_regions = bed_intersect(query, hi_regions) # Checks >1bp overlaps with functionally important elements
  if (nrow(ol_pc_regions) > 0) {
    print("TRUE. The region contains protein-coding genes. (Score: 0.00 - Continue evaluation)")
  } else if (nrow(ol_hi_regions) > 0) {
    print("TRUE. The region contains known functionally important elements. (Score: 0.00 - Continue evaluation)")
  } else("FALSE. The region Does NOT contain protein-coding or any known functionally important elements. (Score: -0.60)")
}

loss_2a <- function(x) {
  query = query_parser(x)
  int_hi_genes = bed_intersect(query, hi_genes) %>%
    filter(.overlap == end.y - start.y)
  int_hi_regions = bed_intersect(query, hi_regions) %>%
    filter(.overlap == end.y - start.y)
  if (nrow(int_hi_genes) > 0) {
    print("TRUE. Complete overlap of an established haploinsuccificient gene. (Score: 1.00)")
  } else if (nrow(int_hi_regions > 0)) {
    print("TRUE. Complete overlap of an established haploinsuccificient genomic region. (Score: 1.00)")
  } else("FALSE. NO overlap of an established haploinsuccificient gene/genomic region. (Score: 0.00)")
}

loss_2b <- function(x) {
  query = query_parser(x)
  int_hi_genes <- bed_intersect(query, hi_genes) %>%
    filter(.overlap < end.y - start.y)
  int_hi_regions <- bed_intersect(query, hi_regions) %>%
    filter(.overlap < end.y - start.y)
  if (nrow(int_hi_genes) > 0 | nrow(int_hi_regions)) {
    print("TRUE. Partial overlap of an established HI genomic region. (Score: 0.00 - Continue evaluation)")
  } else("FALSE. NO partial overlap of an established HI gene/genomic region. (Score: 0.00)")
}

loss_2c <- function(x) {
  query = query_parser(x)
  ol_3p_regions     = bed_intersect(query, hi_genes_3p)
  ol_5p_regions     = bed_intersect(query, hi_genes_5p)
  ol_coding_regions = bed_intersect(query, hi_genes_coding)
  if (nrow(ol_3p_regions) == 0 & nrow(ol_5p_regions) != 0) { 
    if (nrow(ol_coding_regions) != 0) {
      print("TRUE. The region has overlap with 5' end with coding sequence of a haploinsuficient gene and 3' end NOT involved. (Score: 0.90)")
    } else if (nrow(ol_coding_regions) == 0){
      print("TRUE. The region has overlap with 5' end WITHOUT coding sequence of a haploinsuficient gene and 3' end NOT involved. (Score: 0.45)")
  } else if (nrow(ol_3p_regions) != 0 & nrow(ol_5p_regions) == 0) {
    print(paste0("FALSE. The region has NO overlap with 5' end of a haploinsuficient. (Score: 0.00)"))
  } else if (nrow(ol_3p_regions) != 0 & nrow(ol_5p_regions) != 0) {
    print(paste0("TRUE. The region has overlap with 5' end with a haploinsuficient gene BUT 3' end involved. (Score: 0.90)"))
  }
  }
}
