#!/usr/bin/env Rscript

source("ukb_functions.R")


load("my_ukb_data_clean.rda") 
#data()
#ls() : to see dataframes loaded

#Select all self reported cases
#venous thromboembolic disease code 1068
#pulmonary embolism +/- dvt code 1093
#deep venous thrombosis (dvt)  code 1094
all_vte <- extract_self_reported_nc(my_ukb_data_clean, c("1068","1093","1094"))
#vtd <- extract_self_reported_nc(all_vte, "1068")
#dvt_pe <- extract_self_reported_nc(all_vte, "1093")
#dvt <- extract_self_reported_nc(all_vte, "1094")

#extract individuals given their ICD codes
icd10 <- extract_diagnose_icd10(my_ukb_data_clean, c("I260","I269","I801","I802", "I808", "I822"))

common_eid <- intersect(all_vte$eid, icd10$eid)

vte_icd10 <- (all_vte %>% filter(eid %in% common_eid))

#check for medication
#ORAL
#	Warfarin  1140888266
#	Acenocoumarol 1140909770
#	Phenindione 1140861702
#Injectable
# Enoxaparin 1140861588
# Dalteparin 1140888204
# Tinzaparin 1140888206
anti_coa <- extract_treatment_medication(vte_icd10, c("1140888266","1140909770","1140861702", "1140861588","1140888204","1140888206"))

#anti_coa_icd <- extract_diagnose_icd10(vte_icd10, c("T455","T457","Y442","Y443","Z921","D683"))

save(all_vte, icd10, vte_icd10, anti_coa, anti_coa_icd, file = "vtd_data.rda")

######  Interseet with other diases ex: previously computed bleeding cases #####
load("bleeding_icd10_data.rda")
common_eid <- intersect(anti_coa$eid, bledding_icd10$eid)
anti_coa_ble <- anti_coa
anti_coa_ble$bleeding <- (anti_coa$eid %in% common_eid)
anti_coa_ble$bleeding <- as.numeric(anti_coa_ble$bleeding)

#Example how to extract biomarkers for the first visis. biomarkers_value is contained in ukb_functions.R
bio_visit0 <- paste(biomarkers_value,"_0_0",sep="")
biomarkers_of_anti_coa_ble <- extract_columns_by_names(anti_coa_ble, c(bio_visit0,"bleeding"))

