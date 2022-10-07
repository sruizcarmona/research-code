#!/usr/bin/env Rscript

source("ukb_functions.R")

load("my_ukb_data_clean.rda") 
#data()
#ls() : to see dataframes loaded

####################################################################################################
#ICD-10 codes issues:
#M250 -->does not exists y itself. There are many subgroups --> We include them all
#S064 -->does not exists y itself. There are 2 subgroups --> We include them all
#S065 -->does not exists y itself. There are 2 subgroups --> We include them all
#S066 -->does not exists y itself. There are 2 subgroups --> We include them all
#S260 -->does not exists y itself. There are 2 subgroups --> We include them all
#S271 -->does not exists y itself. There are 2 subgroups --> We include them all

#H31.41x --> H314 exist but "hemorrhage/bledding subtype does not exits" --> We DO NOT include it
#H35.73x --> H357 "" "" "" "" --> NOT INCLUDED
#H44.81x --> H448 "" "" "" "" --> NOT INCLUDED
#H47.02x --> H470 "" "" "" "" --> NOT INCLUDED
#Similar decision taken for codes: 
#H61.12x, K22.11, K29.21, K29.31, K29.41, K29.51, K29.61,
#K29.71, K29.81, K29.91, K31.811, K50.011, K50.111, K50.811, K50.911,
#K51.011, K51.211, K51.311, K51.411, K51.511, K51.811, K51.911,
#K55.21, K57.01, K57.11, K57.13, K57.21, K57.31, K57.33, K57.41,
#K57.51, K57.53, K57.81, K57.91, K57.93


#Not found
#S06.34xx, S06.35xx, S06.36xx, S06.37xx, S06.38xx
#H05.23x, M79.81
####################################################################################################

icd_codes <- c("D62","D683","D698","D699",
							 "H113","H210","H313","H356","H431","H450","H922",				 
							 "I230","I312","I600","I601","I602","I603","I604",
							 "I605","I606","I607","I608","I609","I610","I611",
							 "I612","I613","I614","I615","I616","I618","I619",
							 "I620","I621","I629","I850","I983",
							 "J942",	 
							 "K226","K250","K252","K254","K256","K260","K262",
							 "K264","K266","K270","K272","K274","K276","K280",
							 "K282","K284","K286","K290","K625","K661","K762",
							 "K920","K921","K922",
							 "M2500","M2501","M2502","M2503","M2504","M2505",
							 "M2506","M2507","M2508","M2509",
							 "N020","N021","N022","N023","N024","N025","N026",
							 "N027","N028","N029","N421","N837","N897","N920",
							 "N921","N923","N924","N925","N930","N938","N939",
							 "N950",
							 "O717",
							 "R040","R041","R042","R048","R049","R31","R58",
							 "S0640","S0641","S0650","S0651","S0660","S0661",
							 "S2600","S2601","S2710","S2711",
							 "T792")

bledding_icd10 <- extract_diagnose_icd10(my_ukb_data_clean, icd_codes)


save(bledding_icd10, file = "bleeding_icd10_data.rda")




