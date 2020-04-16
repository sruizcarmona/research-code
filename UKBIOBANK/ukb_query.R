#!/usr/bin/env Rscript

library(ukbtools)
library(dplyr) # union function for dataframe

#my_ukb_data <- ukb_df("ukb41165", path = "/baker/datasets/ukb55469/main_dataset/formated")
#my_ukb_key <- ukb_df_field("ukb41165", path = "/baker/datasets/ukb55469/main_dataset/formated")
load("my_ukb_data.rda") #both are in the main_dataset/query_area
load("my_ukb_key.rda")

#check for self-reported cases given a disease code
compute_self_reported <- function(my_data, code) {
	col <-"noncancer_illness_code_selfreported_f20002_0_0"
	data <- my_data[(my_data[[col]] == code) & (!is.na(my_data[[col]])), ]
	for (i in 0:3) {  #max 3
		for (a in 0:33) {  #max 33
			col <- paste("noncancer_illness_code_selfreported_f20002",i,a,sep="_")
			aux_d <- my_data[(my_data[[col]] == code) & (!is.na(my_data[[col]])), ]
			data <- union(data, aux_d)
		}
	}
	return(data)
}

#check for treatment or medication
compute_treatment_medication <- function(my_data, code) {
  col <-"treatmentmedication_code_f20003_0_0"
  data <- my_data[(my_data[[col]] == code) & (!is.na(my_data[[col]])), ]
  for (i in 0:3) {  #max 3
    for (a in 0:47) {  #max 47
      col <- paste("treatmentmedication_code_f20003",i,a,sep="_")
      aux_d <- my_data[(my_data[[col]] == code) & (!is.na(my_data[[col]])), ]
      data <- union(data, aux_d)
    }
  }
  return(data)
}

#venous thromboembolic disease code 1068
#pulmonary embolism +/- dvt code 1093
#deep venous thrombosis (dvt)  code 1094
#atrial fibrillation code 1471
#clotting disorder/excessive bleeding code 1445
vtd <- compute_self_reported(my_ukb_data, 1068)
af <- compute_self_reported(my_ukb_data, 1471)
nrow(vtd)
save(vtd,..., file = "output.rda")


#check for medication
# ex.	warfarin  code 1140888266
vtd_warfarin <-compute_treatment_medication(vtd, 1140888266)



