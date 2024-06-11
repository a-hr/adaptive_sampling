library(tidyverse)

summary.txt <- "/home/neuro-rna/Desktop/minKNOW/20240607_AT096_1_P2Solo/AT096/20240607_1125_P2S-02029-A_PAW47387_b8bb5cd7/sequencing_summary_PAW47387_b8bb5cd7_6d7c4c77.txt"
data <- read_delim(summary.txt)
# n10 <- unname(quantile(data$sequence_length_template, probs = .9))
n1 <- unname(quantile(data$sequence_length_template, probs = .99))

print(str_interp(c("Buffer: ", n1, "nts")))
