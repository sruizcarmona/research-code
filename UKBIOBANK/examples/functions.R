coalesce_by_column <- function(df) {
  return(coalesce(df[1], df[2]))
}
# https://stackoverflow.com/questions/45515218/combine-rows-in-data-frame-containing-na-to-make-complete-row

k %>%
  mutate_if(is.numeric, as.character) %>%
  mutate_if(is.Date,as.character) %>%
  pivot_longer(-eid,values_drop_na = T) %>%
  separate(name,into=c("type","visit_n","array_n"),sep="_",convert=T) %>%
  mutate(visit_n=visit_n+1,array_n=paste0("med_",array_n+1)) %>%
  pivot_wider(values_from = value, names_from = type)  %>%
  mutate(date=visit) %>%
  select(-visit) %>%
  pivot_wider(names_from = array_n,values_from = med) %>%
  group_by(eid,visit_n) %>%
  summarise_all(coalesce_by_column) %>%
  ungroup()
