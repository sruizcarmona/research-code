
#Source code used to extract all the data that may be required for VTE projects

#source("./../scripts/ukb_functions.R")
#load("./../ukb_data_clean.rda")

#diagnosis codes
#AF
#	1471	atrial fibrillation
#VTE:
#	1068	venous thromboembolic disease (cases that may not being dvt)
#	1093	pulmonary embolism +/- dvt
# 1094  deep venous thrombosis (dvt)
self_reported_codes_vte <- c("1068","1093","1094")

vte_self_reported <- extract_self_reported_nc(my_data=ukb_data_clean, 
																							codes=self_reported_codes_vte,
																							visit=NULL)
#icd VTE codes
icd10_codes_vte <- c("I260","I269","I801","I802","I808","I822")

vte_icd10 <- extract_diagnose_icd10(my_data=ukb_data_clean, 
																		codes=icd10_codes_vte) 


save(vte_self_reported, vte_icd10, file="vte_data.rda")

#VTE experiments sets:
#1- Self-reported AND with icd10 codes 
vte_sr_and_icd10 <- vte_icd10[(vte_icd10$eid %in% vte_self_reported$eid),]
#2- Only with icd10 codes 
#vte_icd10
#3- Self-reported OR with icd10 codes
vte_sr_or_icd10 <- union(vte_icd10, vte_self_reported)

#Compute anticoagulants
#Treatment/medicament codes:
# code	name	samples_in_ukb_page
#	1140888266	warfarin 				5682
# 1140909770	acenocoumarol 	7
#	1140861702	phenindione 		17
#	1140861588	enoxaparin 			17
# 1140888204	dalteparin 			3
# 1140888206	tinzaparin 			13
#Total: 5275 (in our data)
anticoagulant_tm <- extract_treatment_medication(ukb_data_clean, c("1140888266", "1140909770", "1140861702", "1140861588", "1140888204", "1140888206"))
#ICD10 Codes:
#	T455	T45.5 Anticoagulants
# T457	T45.7 Anticoagulant antagonists, vitamin K and other coagulants
#	Z921	Z92.1 Personal history of long-term (current) use of anticoagulants
# Y443	Y44.3 Anticoagulant antagonists, vitamin K and other coagulants (therapeutic use)
# Y442	Y44.2 Anticoagulants (therapeutic use)
#Total: 16746 (in our data)
anticoagulant_icd10 <- extract_diagnose_icd10(ukb_data_clean, c("T455", "T457", "Z921", "Y443", "Y442"))

#autocoagulant_icd10_and_tm <- anticoagulant_icd10[(anticoagulant_icd10$eid %in% anticoagulant_tm$eid),]
#Total: 4092

save(anticoagulant_icd10, anticoagulant_tm, file="anticoagulant_data.rda")


#Step 1: Compute intersectio between VTE cases and anticoaugulant
#
#check dates of icd10 code was diagnoses 
#date_of_first_inpatient_diagnosis_icd10_f41280
#####

####

