#!/usr/bin/env Rscript

library(ukbtools)
library(dplyr) # union function for dataframe

load("my_ukb_data.rda")

#Exclude individuals that:
#a- do not have genotype information
#b- Withdraw ukbiobank
#a
common_eid <- read.csv("./../individual/common_sample.txt", header=FALSE, sep=' ')
my_ukb_data_clean <- my_ukb_data[(my_ukb_data$eid %in% common_eid$V1),]

save(my_ukb_data_clean, file = "my_ukb_data_clean.rda")

