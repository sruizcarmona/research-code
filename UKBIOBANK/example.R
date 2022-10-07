load("my_ukb_data_clean.rda")
load("vtd_data.rda")
ls()
nrow(all_vte)
nrow(icd10)
no_icd10<-all_vte[!(all_vte$eid %in% icd10),]
no_icd10<-all_vte[!(all_vte$eid %in% icd10%eid),]
no_icd10<-all_vte[!(all_vte$eid %in% icd10$eid),]
nrow(no_icd10)
head(no_icd10$diagnoses_icd10_f41270_0_0)
icd10.names <- names(no_icd10)[grepl("diagnoses_icd10_f",names(no_icd10))]
icd10.names
sapply(icd10.names, function(x){no_icd10[,x]})
k <- sapply(icd10.names, function(x){no_icd10[,x]})
k
k[1]
k[2]
k[3]
k[[1]]
k[[2]]
head(k)
dim(k)
k[1,]
as.numeric(k[1,])
as.numeric(k[2,])
as.numeric(k[3,])
k[1,]
k <- sapply(no_icd10,function(y){sapply(icd10.names, function(x){no_icd10[y,x]})})
no_icd10$icd10s <- apply(no_icd10[ , icd10.names] , 1 , paste , collapse = "-" )
no_icd10$icd10s
no_icd10$icd10s[1]
no_icd10$noncancer_illness_code_selfreported_f20002_0_0[1]
no_icd10$noncancer_illness_code_selfreported_f20002_0_1[1]
noncancer.names <- names(no_icd10)[grepl("noncancer_illness_code_selfreported_f",names(no_icd10))]
noncancer.names
no_icd10$noncancers <- apply(no_icd10[ , noncancer.names] , 1 , paste , collapse = "-" )
dim(no_icd10)
no_icd10[1,c(13314,13315)]
no_icd10[2,c(13314,13315)]
no_icd10[1,c(13314,13315)]
no_icd10[1000,c(13314,13315)]
no_icd10[1,c(1,13314,13315)]
no_icd10[1,c(11,13314,13315)]
no_icd10[1,c(1,13314,13315)]
no_icd10$age_at_recruitment_f21022_0_0[1]
savehistory(file="SergioRodrigoThursday.R")
