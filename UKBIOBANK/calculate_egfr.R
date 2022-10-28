library(tidyverse)

# based on publication https://pubmed.ncbi.nlm.nih.gov/22762315/
ukb_data_clean_egfr <- ukb_data_clean %>%
    select(eid, sex = genetic_sex_f22001_0_0, starts_with("ethnic_background"), contains(c("_f21003_", "_f30700_", "_f30720_"))) %>% 
    mutate(sex = ifelse(sex == 0, "Female", "Male")) %>%
    mutate_at(vars(!c(eid, sex)),~as.character(.)) %>% 
    pivot_longer(-c(eid, sex), names_to="info", values_to="values") %>% 
    filter(!is.na(values)) %>% 
    separate(info,c("info", "insarray"),sep="(?=_[[:digit:]]_)") %>%
    separate(insarray,c(NA, "instance", "array"),sep="_") %>% 
    separate(info, "info", "_", extra="drop") %>%
    group_by(eid,instance) %>% 
    mutate(valuesok = sum(!is.na(values))) %>% 
    ungroup() %>% 
    pivot_wider(names_from = info, values_from = values) %>%
    group_by(eid) %>% 
    arrange(eid,instance,valuesok) %>% 
    filter(row_number() == 1) %>% 
    ungroup() %>% 
    select(-c(instance, array, valuesok)) %>% 
    mutate(creatinine = as.numeric(creatinine),
           cystatin = as.numeric(cystatin),
           age = as.numeric(age),
           creatinine_mg.dL = creatinine * 113.12 / 1e4,
           ethnic = case_when(
                              ethnic == "1" ~ "White",
                              ethnic == "2" ~ "Mixed",
                              ethnic == "3" ~ "Asian or Asian British",
                              ethnic == "4" ~ "Black or Black British",
                              ethnic == "5" ~ "Chinese",
                              ethnic == "6" ~ "Other ethnic group",
                              ethnic == "1001" ~ "British",
                              ethnic == "1002" ~ "Irish",
                              ethnic == "1003" ~ "Any other white background",
                              ethnic == "2001" ~ "White and Black Caribbean",
                              ethnic == "2002" ~ "White and Black African",
                              ethnic == "2003" ~ "White and Asian",
                              ethnic == "2004" ~ "Any other mixed background",
                              ethnic == "3001" ~ "Indian",
                              ethnic == "3002" ~ "Pakistani",
                              ethnic == "3003" ~ "Bangladeshi",
                              ethnic == "3004" ~ "Any other Asian background",
                              ethnic == "4001" ~ "Caribbean",
                              ethnic == "4002" ~ "African",
                              ethnic == "4003" ~ "Any other Black background",
                              TRUE ~ NA_character_,
                              )) %>%
    mutate(egfr = case_when(
        sex == "Female" & creatinine_mg.dL <= 0.7 & cystatin <= 0.8 ~ 130 * (creatinine_mg.dL/0.7)^-0.248 * (cystatin/0.8)^-0.375 * 0.995^age,
        sex == "Female" & creatinine_mg.dL <= 0.7 & cystatin >  0.8 ~ 130 * (creatinine_mg.dL/0.7)^-0.248 * (cystatin/0.8)^-0.711 * 0.995^age,
        sex == "Female" & creatinine_mg.dL >  0.7 & cystatin <= 0.8 ~ 130 * (creatinine_mg.dL/0.7)^-0.601 * (cystatin/0.8)^-0.375 * 0.995^age,
        sex == "Female" & creatinine_mg.dL >  0.7 & cystatin >  0.8 ~ 130 * (creatinine_mg.dL/0.7)^-0.601 * (cystatin/0.8)^-0.711 * 0.995^age,
        sex == "Male" & creatinine_mg.dL <= 0.9 & cystatin <= 0.8 ~ 135 * (creatinine_mg.dL/0.9)^-0.207 * (cystatin/0.8)^-0.375 * 0.995^age,
        sex == "Male" & creatinine_mg.dL <= 0.9 & cystatin >  0.8 ~ 135 * (creatinine_mg.dL/0.9)^-0.207 * (cystatin/0.8)^-0.711 * 0.995^age,
        sex == "Male" & creatinine_mg.dL >  0.9 & cystatin <= 0.8 ~ 135 * (creatinine_mg.dL/0.9)^-0.601 * (cystatin/0.8)^-0.375 * 0.995^age,
        sex == "Male" & creatinine_mg.dL >  0.9 & cystatin >  0.8 ~ 135 * (creatinine_mg.dL/0.9)^-0.601 * (cystatin/0.8)^-0.711 * 0.995^age,
        TRUE ~ NA_real_,
        )) %>% 
  mutate(egfr = if_else(ethnic %in% c("Caribbean","African","Any other Black background"),
                        round(egfr*1.08,3),
                        round(egfr,3)))

  save(ukb_data_clean_egfr, file = "preprocessed_rdas/ukb42488_egfr_220824.rda")
