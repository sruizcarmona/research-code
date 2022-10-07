library(dplyr)
library(stringr)

load('/baker/datasets/ukb55469/R_workspace/210721ukb_data_clean.rda')
k <- read.table('input/selected_fields.txt',stringsAsFactors=F,sep="\t")
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

save(my_ukb_data,file='rda/noonan_my_ukb_data_selfields.rda')
