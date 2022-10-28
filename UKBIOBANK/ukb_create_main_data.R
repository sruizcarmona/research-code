#!/usr/bin/env Rscript

library(ukbtools)
library(dplyr) # union function for dataframe

#change ukb*** for your code
ukb_path <- "/baker/datasets/ukb55469/Keys_and_raw_data/220510_ukb51754/"
ukb_basket <- "ukb51754"

#ukb_data <- ukb_df("ukb49108", path = "/baker/datasets/ukb55469/Keys_and_raw_data/211022ukb49108/")
#ukb_key <- ukb_df_field("ukb49108", path="/baker/datasets/ukb55469/Keys_and_raw_data/211022ukb49108")
ukb_data <- ukb_df(ukb_basket, path = ukb_path)
ukb_key <- ukb_df_field(ukb_basket, path = ukb_path)


#load other projects if required

#merge all the projects into one
#common_col_11_16 <- intersect(names(ukb_41165), names(ukb_41691))
#ukb_data <- ukb_df_full_join(ukb_41165, ukb_41691, by=common_col_11_16)
#.... repeat for each new dataset to be added
#save data
save(ukb_data, file = paste0(format(as.Date(Sys.Date()),format="%y%m%d"),"_ukb_data.rda"))
save(ukb_key, file = paste0(format(as.Date(Sys.Date()),format="%y%m%d"),"_ukb_key.rda"))

