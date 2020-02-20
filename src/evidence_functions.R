loss_1 <- function(x) {
  query   <- trbl_interval(~ chrom, ~ start, ~ end, 
                           x[[1]], as.numeric(x[[2]]), as.numeric(x[[3]]))
  ifelse(nrow(bed_intersect(query, protein_coding_regions)) > 0 | 
           nrow(bed_intersect(query, known_hi_regions)) > 0 , 0, -0.6)
}

# loss_2a <- function(x) {
#   query   <- trbl_interval(~ chrom, ~ start, ~ end, 
#                            x[[1]], as.numeric(x[[2]]), as.numeric(x[[3]]))
#   bed_intersect(query, haploinsufficient_genes) %>% 
#     filter(.overlap == end.y - start.y) %>% 
#     {if_else(nrow(.)>0, 1, 0)}
# }
# 
# loss_2b <- function(x) {
#   query   <- trbl_interval(~ chrom, ~ start, ~ end, 
#                            x[[1]], as.numeric(x[[2]]), as.numeric(x[[3]]))
#   bed_intersect(query, haploinsufficient_genes) %>% 
#     filter(.overlap < end.y - start.y) %>% 
#     {if_else(nrow(.)>0, 1, 0)}
# }