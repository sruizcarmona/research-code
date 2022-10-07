#!/usr/bin/env Rscript

library(ukbtools)
library(dplyr) # union function for dataframe

#change ukb*** for your code
ukb_41165 <- ukb_df("ukb41165", path="/baker/datasets/ukb55469/phenotype_traits/main_data")
ukb_41165_key <- ukb_df_field("ukb41165", path="/baker/datasets/ukb55469/phenotype_traits/main_data")

#load other projects if required

#merge all the projects into one
#common_col_11_16 <- intersect(names(ukb_41165), names(ukb_41691))
#ukb_data <- ukb_df_full_join(ukb_41165, ukb_41691, by=common_col_11_16)
#.... repeat for each new dataset to be added
#save data
save(ukb_data, file = "ukb_data_all.rda")
#save(ukb_key, file = "ukb_key_all.rda")


#method_of_recording_time_when_noncancer_illness_first_diagnosed_f20013_2_26

