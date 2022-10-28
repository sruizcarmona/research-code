library(dplyr)
library(stringr)

load('/baker/datasets/ukb55469/R_workspace/220520_ukb_data_clean.rda')
k <- read.table('pref_columns.txt',stringsAsFactors=F,sep="\t")
sum.patterns <- paste0("f",as.character(unique(k$V1)),"_\\d")
sum.fields <- unlist(sapply(sum.patterns,function(x){names(ukb_data_clean)[str_detect(names(ukb_data_clean),x)]}))
# this line doesnt work well with duplicated sum.fields
#diab_ukb <- diab_ukb[,c('eid',sum.fields)]

my_ukb_data <- ukb_data_clean %>% select(eid,
                                one_of(sum.fields),
                                # for the adjudicated variables
                                starts_with("dm_"), 
                                starts_with("fc1_"), 
                                starts_with("fc2_"), 
                                starts_with("rule_"), 
                                starts_with("fc3_"), 
                                starts_with("sr_"))
ukb_data_clean <- my_ukb_data
save(ukb_data_clean, file='../preprocessed_rdas/221021_ukb_data_clean_pref_columns.rda')
