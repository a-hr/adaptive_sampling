library(tidyverse)

buffer.size <- 9721
bed.file <- "adaptive_sampling_jun24.bed"

data <- read_delim(bed.file, col_names = F)
data %>%
    mutate(
        X2 = X2 - buffer.size,
        X3 = X3 + buffer.size
    ) %>%
    write_delim(
        file = str_interp(c("buffer_", bed.file)), 
        na = "",
        delim = "\t",
        col_names = F
    )
