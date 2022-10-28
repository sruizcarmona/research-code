#!/usr/bin/env Rscript
rm(list = ls())
library(data.table)
library(dplyr) # union function for dataframe

# Load the main data: change to the version that you are cleaning YYMMDDukb_data
load("220520_ukb_data.rda")


# Exclude individuals with no genotyped or imputed data information
imp_ind <- fread('/baker/datasets/ukb55469/Genetic_data/Imputation/Bgen/ukb55469_imp_chr1_v3_s487296.sample', header=FALSE)
geno_ind <- fread('/baker/datasets/ukb55469/Genetic_data/Genotype/Plink/ukb55469_cal_chr1_v2_s488264.fam', header=FALSE)
ukb_data_clean <- ukb_data[(ukb_data$eid %in% imp_ind$V1) & 
													 (ukb_data$eid %in% geno_ind$V1), ]


# Remove individuals that have withdraw the ukbiobank
# load last withdraw data available
wd_ind <- fread('/baker/datasets/ukb55469/Individuals_withdrawn/w55469_20210809.csv', header=FALSE)


ukb_data_clean <- ukb_data_clean[!(ukb_data_clean$eid %in% wd_ind$V1), ]

#Generate the ukb_data_clean
save(ukb_data_clean, file = paste0(format(as.Date(Sys.Date()),format="%y%m%d"),"_ukb_data_clean.rda"))


#Generate the ukb_exome_clean
ex_ind <- fread('/baker/datasets/ukb55469/Genetic_data/Exome/Plink_OQFE/ukb23155_c1_b0_v1_s200632.fam', header=FALSE)
ukb_exome_clean <- ukb_data_clean[ukb_data_clean$eid %in% ex_ind$V1, ]

save(ukb_exome_clean, file = paste0(format(as.Date(Sys.Date()),format="%y%m%d"),"_ukb_exome_clean.rda"))

