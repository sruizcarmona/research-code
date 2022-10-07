###
# supporting summary plot functions
###
library(cowplot)
library(ggplot2)
library(dplyr)
library(tidytext)

summary_continuous <- function(indata=diab_ukb,field,fillvar="sex",fillname="Sex", boxcol=c("white","black"),
                               rel_heights = c(6,3,3,2.5),
                               type,xlab,ylab,leg_pos,xlim=c(NA,NA),ylim=c(NA,NA)) {
  pdata <- indata %>%
    select(eid,one_of(fillvar),contains(field)) %>%
    pivot_longer(!c(eid,one_of(fillvar)),names_to="names",values_to="value") %>%
    separate(names,c(NA,"rep"),field) %>%
    separate(rep,c("ins","array"),"_") %>%
    filter(!is.na(value)) %>%
    mutate_if(is.ordered,as.character) %>%
    mutate(value=if_else(!is.na(value) & value < 0,
                         ifelse(is.numeric(value),
                                ifelse(is.integer(value),
                                       NA_integer_,
                                       NA_real_),
                                NA_character_),
                         value)) %>%
    filter(!is.na(value)) %>%
    group_by(eid) %>%
    mutate(value=mean(value)) %>%
    filter(row_number() == n()) %>%
    ungroup()
  
  if (fillvar == "sex"){
    # fix sex levels
    levels(pdata$sex) <- c("Female","Male")
  }
  
  if (fillvar == "diab_age_group"){
    # fix sex levels
    levels(pdata$diab_age_group) <- c("< 44", "45 < 54", "55 < 64", "65 < 74", "75 >")
    pdata$diab_age_group <- droplevels(pdata$diab_age_group)
  }
  
  #for colors
  fewpal="Dark"
  if(fillvar=="stroke" | fillvar=="m_infarction") {
    fewpal="Medium"
  }

  p1 <- ggplot(pdata,aes(x=value)) +
    geom_density(aes_string(fill=fillvar,col=fillvar),alpha=0.4,cex=1) +
    labs(x="", y="Density",
         fill=fillname, col=fillname) +
    theme_bw() +
    scale_color_few(fewpal) +
    scale_fill_few(fewpal) +
    scale_y_continuous(breaks = scales::pretty_breaks(8),limits=ylim) +
    scale_x_continuous(breaks = scales::pretty_breaks(8),limits=xlim) +
    theme(legend.position=leg_pos,
          legend.title = element_text(size=10),
          legend.text = element_text(size=9),
          legend.key.size = unit(0.9,"line"),
          # legend.background = element_rect(fill="transparent"),
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank(),
          plot.margin = margin(t=6, r=6, b=-11, l=6,"pt"),
          panel.grid.major.y = element_blank(),
          panel.grid.minor.y = element_blank(),
          panel.grid.major.x = element_line(colour = "gray",size=0.1))

  p2 <- ggplot(pdata,aes_string(x=fillvar,y="value")) +
    geom_point(aes_string(fill=fillvar,col=fillvar),alpha=0.5,cex=1) +
    geom_boxplot(aes_string(fill=fillvar,col=fillvar),alpha=0.5,cex=1) +
    labs(x="", y="",
         fill=fillname, col=fillname) +
    theme_bw() +
    scale_color_few(fewpal) +
    scale_fill_few(fewpal) +
    stat_summary(fun=mean,
                 color=boxcol,
                 geom="label",  cex=2.5, alpha=0.8,
                 vjust=0.5, aes_string(fill=fillvar,label="round(..y.., digits=1)")) +
    scale_y_continuous(breaks = scales::pretty_breaks(8)) +
    coord_flip(ylim=xlim) +
    scale_x_discrete(limits = rev(levels(pdata[[fillvar]]))) +
    theme(legend.position="none",
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          plot.margin = margin(t=0, r=6, b=6, l=6,"pt"),
          # axis.text.x=element_text(angle = 10,hjust=1),
          panel.grid.major.y = element_blank(),
          panel.grid.major.x = element_line(colour = "gray",size=0.1))

  p1all <- ggplot(pdata %>% mutate(kk="All"),aes(x=value)) +
    geom_density(aes(col=kk,fill=kk),alpha=0.5,cex=1) +
    labs(x="", y="",
         fill="", col="") +
    theme_bw() +
    scale_color_few(fewpal) +
    scale_fill_few(fewpal) +
    scale_y_continuous(breaks = scales::pretty_breaks(8),limits=ylim) +
    scale_x_continuous(breaks = scales::pretty_breaks(8),limits=xlim) +
    theme(legend.position=leg_pos-c(0.015,0.1),
          legend.title = element_blank(),
          legend.text = element_text(size=8),
          legend.key.size = unit(0.8,"line"),
          # legend.background = element_rect(fill="transparent"),
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank(),
          panel.grid.major.y = element_blank(),
          panel.grid.minor.y = element_blank(),
          plot.margin = margin(t=0, r=6, b=-10, l=6,"pt"),
          panel.grid.major.x = element_line(colour = "gray",size=0.1))

  p2all <- ggplot(pdata %>% mutate(kk="all"),aes(x=kk,y=value)) +
    geom_point(aes(fill=kk,col=kk),alpha=0.5,cex=1) +
    geom_boxplot(aes(fill=kk,col=kk),alpha=0.5,cex=1) +
    labs(x="", y=xlab,
         fill=fillname, col=fillname) +
    theme_bw() +
    scale_color_few(fewpal) +
    scale_fill_few(fewpal) +
    stat_summary(fun=mean,
                 color=c("white"),
                 geom="label",  cex=2.5, alpha=0.8,
                 vjust=0.5, aes(fill=kk, label=round(..y.., digits=1))) +
    scale_y_continuous(breaks = scales::pretty_breaks(8)) +
    coord_flip(ylim=xlim) +
    scale_x_discrete(limits = "all") +
    theme(legend.position="none",
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          plot.margin = margin(t=0, r=6, b=6, l=6,"pt"),
          # axis.text.x=element_text(angle = 10,hjust=1),
          panel.grid.major.y = element_blank(),
          panel.grid.major.x = element_line(colour = "gray",size=0.1))

  p <- plot_grid(p1,p2,p1all,p2all,
                 ncol=1, rel_heights = rel_heights)
  return(p)
}

#######################
summary_discrete <- function(indata=diab_ukb, field, fillvar="diab_age_group", fillname="Sex",
                             type, xlab, ylab, leg_pos, xlim=c(NA,NA),ylim=c(NA,NA)) {
  
  pdata <- indata %>% 
    select(eid,one_of(fillvar),contains(field)) %>% 
    pivot_longer(!c(eid,one_of(fillvar)),names_to="names",values_to="value") %>%  
    separate(names,c(NA,"rep"),field) %>%
    separate(rep,c("ins","array"),"_") %>% 
    filter(!is.na(value)) %>%
    mutate_if(is.ordered,as.character) %>% 
    mutate(value=if_else(!is.na(value) & value < 0,
                         ifelse(is.numeric(value),
                                ifelse(is.integer(value),
                                       NA_integer_,
                                       NA_real_),
                                NA_character_),
                         value)) %>%
    filter(!is.na(value)) %>% 
    group_by(eid) %>%
    filter(row_number() == n()) %>% 
    ungroup() %>% 
    select_if(~sum(!is.na(.)) > 0) %>% 
    select_if(~sum(!.=="") > 0) %>% 
    count(.data[[fillvar]],value) %>% 
    group_by(value) %>% 
    mutate(perc=round(n/sum(n)*100,1)) %>% 
    ungroup()
  
  if(type == "yesno") {
    pdata <- pdata %>% mutate(value=factor(value,levels=c("Yes","No"))) 
  }
  
  if(type=="deathcount"){
    pdata <- pdata %>% 
      group_by(.data[[fillvar]]) %>% summarise(n=sum(n),.groups = "drop") %>% mutate(value="Yes")
  }
  
  #for colors
  fewpal="Dark"
  if(fillvar=="stroke" | fillvar=="m_infarction") {
    fewpal="Medium"
  }
  
  plot <- ggplot(pdata,aes_string(x="value",y="n",fill=fillvar)) +
    # geom_bar(stat="identity",position="dodge",width=0.8,aes(fill=sex),alpha=1,cex=1) +
    geom_bar(stat="identity",width=0.7,
             alpha=1,cex=1,position=position_dodge(0.8)) +
    labs(x=xlab, y=ylab,
         fill=fillname, col=fillname) +
    theme_bw() + 
    scale_color_few(fewpal) +
    scale_fill_few(fewpal) + 
    theme(legend.position=leg_pos,
          legend.title = element_text(size=10),
          legend.text = element_text(size=9),
          legend.key.size = unit(0.9,"line"),
          # legend.background = element_rect(fill="transparent"),
          # axis.text.y = element_blank(),
          # axis.ticks.y = element_blank(),
          # axis.text.x = element_blank(),
          # axis.ticks.x = element_blank(),
          # plot.margin = margin(t=6, r=6, b=-11, l=6,"pt"),
          panel.grid.major.x = element_line(colour = "gray",size=0.1))
  
  if(type == "num"){
    plot <- plot +
      scale_x_continuous(breaks = scales::pretty_breaks(8),limits=xlim) +
      scale_y_continuous(breaks = scales::pretty_breaks(8),limits=ylim)
  }
  
  if (type == "yesno") {
    plot <- plot +
      geom_text(position=position_dodge(0.8),
                aes(label=n),vjust=c(-3.5,-3.5,1.6,1.6),cex=3) +
      geom_text(position=position_dodge(0.8),vjust=c(-1.8,-1.8,3,3), cex=3,
                aes(label=paste0("(",perc,"%)")))
  }
  
  return(plot)
}

#######################
summary_discrete_mirror <- function(indata=diab_ukb, field, groupvar="diab_age_group", 
                                    fillvar="diab_age_group", fillname="Sex",
                                    vjustn=c(-3.5,-3.5,1.6,1.6), vjustperc=c(-1.8,-1.8,3,3),
                                    xvar="value", type, xlab, ylab, leg_pos, xlim=c(NA,NA),ylim=c(NA,NA)) {
  
  pdata <- indata %>% 
    select(eid,one_of(groupvar),contains(field)) %>% 
    pivot_longer(!c(eid,one_of(groupvar)),names_to="names",values_to="value") %>%  
    separate(names,c(NA,"rep"),field) %>%
    separate(rep,c("ins","array"),"_") %>% 
    # filter(!is.na(value)) %>%
    mutate_if(is.ordered,as.character) %>% 
    # mutate(value=if_else(is.numeric(value) && !is.na(value) && value < 0,
    #                      ifelse(is.numeric(value),
    #                             ifelse(is.integer(value),
    #                                    NA_integer_,
    #                                    NA_real_),
    #                             NA_character_),
    #                      value)) %>%
    # filter(!is.na(value)) %>% 
    group_by(eid) %>%
    filter(row_number() == n()) %>% 
    ungroup() %>% 
    select_if(~sum(!is.na(.)) > 0) %>% 
    # select_if(~sum(!.=="") > 0) %>% 
    count(.data[[groupvar]],value) %>% 
    group_by(.data[[groupvar]]) %>% 
    mutate(perc=round(n/sum(n)*100,1)) %>% 
    ungroup()
  
  if(type == "yesno") {
    pdata <- pdata %>% mutate(value=factor(value,levels=c("Yes","No"))) 
  }
  
  if(type=="deathcount"){
    pdata <- pdata %>% 
      group_by(.data[[groupvar]]) %>% summarise(n=sum(n),.groups = "drop") %>% mutate(value="Yes")
  }
  
  if (type == "ipaq") {
    pdata <- pdata %>% 
      mutate(value=factor(value,levels=c("low","moderate","high")))
  }
  
  #for colors
  fewpal="Dark"
  if(fillvar=="stroke" | fillvar=="m_infarction") {
    fewpal="Medium"
  }
  
  plot <- ggplot(pdata,aes_string(x=xvar,y="n",fill=fillvar)) +
    # geom_bar(stat="identity",position="dodge",width=0.8,aes(fill=sex),alpha=1,cex=1) +
    geom_bar(stat="identity",width=0.7,
             alpha=1,cex=1,position=position_dodge(0.8)) +
    labs(x=xlab, y=ylab,
         fill=fillname, col=fillname) +
    theme_bw() + 
    scale_y_continuous(breaks = scales::pretty_breaks(8),limits=ylim) +
    scale_color_few(fewpal) +
    scale_fill_few(fewpal) + 
    theme(legend.position=leg_pos,
          legend.title = element_text(size=10),
          legend.text = element_text(size=9),
          legend.key.size = unit(0.9,"line"),
          # legend.background = element_rect(fill="transparent"),
          # axis.text.y = element_blank(),
          # axis.ticks.y = element_blank(),
          # axis.text.x = element_blank(),
          # axis.ticks.x = element_blank(),
          # plot.margin = margin(t=6, r=6, b=-11, l=6,"pt"),
          panel.grid.major.x = element_line(colour = "gray",size=0.1))
  
  if(type == "num"){
    plot <- plot +
      scale_x_continuous(breaks = scales::pretty_breaks(8),limits=xlim)
  }
  
  if (type == "yesno") {
    plot <- plot +
      scale_fill_paletteer_d("awtools::mpalette") +
      geom_text(position=position_dodge(0.8),
                aes(label=n),vjust=vjustn,cex=2.5) +
      geom_text(position=position_dodge(0.8),vjust=vjustperc, cex=2.5,
                aes(label=paste0("(",perc,"%)")))
  }
  
  if (type == "ipaq") {
    plot <- plot +
      scale_fill_viridis_d(option = "plasma", na.value = "grey80") +
      geom_text(position=position_dodge(0.8),
                aes(label=n),vjust=vjustn,cex=2.5) +
      geom_text(position=position_dodge(0.8),vjust=vjustperc, cex=2.5,
                aes(label=paste0("(",perc,"%)")))
  }
  
  return(plot)
}

#######################
summary_discrete_multiple <- function(indata=diab_ukb, field, fillvar="sex", fillname="Sex",
                                      type, xlab, ylab, title="", subtitle="", 
                                      leg_pos, xlim=c(NA,NA), ylim=c(NA,NA)) {
  pdata <- indata %>% 
    select(eid, contains(field)) %>% 
    pivot_longer(!c(eid), names_to="names", values_to="value") %>%  
    separate(names, c(NA, "rep"), field) %>%
    separate(rep, c("ins", "array"), "_") %>% 
    filter(!is.na(value)) %>%
    mutate_if(is.ordered, as.character) %>% 
    mutate(value=if_else(!is.na(value) & value < 0,
                         ifelse(is.numeric(value),
                                ifelse(is.integer(value),
                                       NA_integer_,
                                       NA_real_),
                                NA_character_),
                         value)) %>%
    count(value) %>% 
    mutate(perc=round(n/sum(n)*100,1))
  
  # select only top 10
  if(type == "top") {
    pdata <- pdata %>% 
      arrange(-n) %>% 
      top_n(10, n) %>% 
      left_join(ICD, by = c("value" = "coding_L4")) %>%
      mutate(summary=paste0(substr(meaning_L3,5,200),"; ", substr(meaning_L4,7,200)))
    pdata[pdata$value == "I10",4:21] <- ICD[ICD$coding_L3 == "I10",] %>% 
      select(-coding_L4) %>% 
      mutate(summary=substr(meaning_L3,5,200))
    pdata <- pdata %>% 
      arrange(n) %>% 
      mutate(value=factor(value,levels=pdata$value)) %>% 
      mutate(summary=factor(summary,levels=summary))
  }
  
  #for colors
  fewpal="Dark"
  if(fillvar=="stroke" | fillvar=="m_infarction") {
    fewpal="Medium"
  }
  
  plot <- ggplot(pdata,aes(x=summary, y=n, fill=n, label=value)) +
    geom_bar(stat="identity",width=0.7,
             alpha=1,cex=1,position=position_dodge(0.8)) +
    labs(x=xlab, y=ylab, title=title, subtitle=subtitle,
         fill=fillname, col=fillname) +
    theme_bw() + 
    scale_x_discrete(labels=function(x) stringr::str_wrap(str_trunc(x,95), width = 50)) +
    coord_flip() +
    geom_text(col="black",hjust=c(rep(-0.2,9),1.2)) +
    scale_color_few(fewpal) +
    scale_fill_few(fewpal) + 
    theme(legend.position=leg_pos,
          legend.title = element_text(size=10),
          legend.text = element_text(size=9),
          legend.key.size = unit(0.9,"line"),
          # legend.background = element_rect(fill="transparent"),
          # axis.text.y = element_blank(),
          # axis.ticks.y = element_blank(),
          axis.text.y = element_text(size = 8),
          # axis.ticks.x = element_blank(),
          # plot.margin = margin(t=6, r=6, b=-11, l=6,"pt"),
          panel.grid.major.x = element_line(colour = "gray",size=0.1))
  
  if(type == "num"){
    plot <- plot +
      scale_x_continuous(breaks = scales::pretty_breaks(8),limits=xlim) +
      scale_y_continuous(breaks = scales::pretty_breaks(8),limits=ylim)
  }
  
  if(type == "top"){
    plot <- plot +
      scale_color_viridis_c() +
      scale_fill_viridis_c()
  }
  
  return(plot)
}


##########################
# facet (ONLY ONE OPTION PER INDIVIDUAL)
summary_facetbysex <- function(indata=diab_ukb,field,type,
                               fillvar,fillname,xlab,
                               ylab,leg_pos,xlim=c(NA,NA),ylim=c(NA,NA)) {
  pdata <- indata %>% 
    select(eid,sex,contains(field)) %>% 
    pivot_longer(!c(eid,sex),names_to="names",values_to="value") %>%  
    separate(names,c(NA,"rep"),field) %>%
    mutate_if(is.ordered,as.character) %>% 
    mutate(rep=as.numeric(str_remove(rep,"_0"))+1,
           value=if_else(!is.na(value) & value < 0,
                         ifelse(is.numeric(value),NA_integer_,NA_character_),
                         value)
    ) %>% 
    filter(!is.na(value)) %>% 
    group_by(eid) %>%
    filter(row_number() == n()) %>% 
    ungroup() %>% 
    count(sex,value)
  
  if(type=="death") {
    pdata <- pdata %>% 
      group_by(sex) %>% arrange(sex,-n) %>% top_n(10) %>% ungroup() %>% 
      mutate(value=reorder_within(value,-n,sex))
  }
  
  if (type == "ipaq") {
    pdata <- pdata %>% 
      mutate(value=factor(value,levels=c("low","moderate","high")))
  }
  
  if(type == "alcohol") {
    pdata <- pdata %>% 
      mutate(value=factor(value,
                          levels=c("Prefer not to answer","Daily or almost daily",
                                   "Three or four times a week","Once or twice a week",
                                   "One to three times a month","Special occasions only","Never")))
    levels(pdata$value) <- c("N/A","Daily","3-4/week","1-2/week","1-3/month","Occas.","Never")
  }
  plot <- ggplot(pdata,aes(x=value,y=n)) +
    # geom_bar(stat="identity",width=0.7,aes_string(fill=fillvar),
    #          alpha=1,cex=1,position=position_dodge(0.8)) +
    geom_col(width=0.7,aes_string(fill=fillvar)) +
    # geom_col(aes(x=pregnancy_group,y=n,fill=value),position=position_dodge(0.8),width = 0.7) +
    labs(x=xlab, y=ylab, fill=fillname) +
    scale_x_reordered() +
    theme_few() +
    scale_fill_viridis_d(option = "plasma") +
    scale_y_continuous(breaks = scales::pretty_breaks(8)) +
    facet_wrap(~sex, scales="free_x") +
    theme(legend.position=leg_pos,
          legend.title = element_text(size=10),
          legend.text = element_text(size=9),
          legend.key.size = unit(0.9,"line"),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank(),
          panel.grid.major.y = element_line(colour = "gray",size=0.1),
          # legend.background = element_rect(fill="transparent"),
          # axis.text.y = element_blank(),
          # axis.ticks.y = element_blank(),
          # plot.margin = margin(t=6, r=6, b=-11, l=6,"pt"),
          # panel.grid.major.x = element_line(colour = "gray",size=0.1)
          # panel.grid.major.x = element_line(colour = "gray",size=0.1))
    )
  
  if(type == "death") {
    plot <- plot +
      theme_few() +
      scale_fill_few("Dark") +
      theme(axis.text.x = element_text(angle = 45,hjust = 1),
            axis.ticks.x = element_line())
  }
  
  if(type == "num"){
    plot <- plot +
      scale_x_continuous(breaks = scales::pretty_breaks(8),limits=xlim) +
      scale_y_continuous(breaks = scales::pretty_breaks(8),limits=ylim)
  }
  
  return(plot)
}

##########################
# facet (ONLY ONE OPTION PER INDIVIDUAL)
summary_facet <- function(indata = diab_ukb, field, type, boxcol="black", vjustn = 1.8, vjustperc = 4.1,
                          xvar = "value", yvar = "n",
                          fillvar, fillname, xlab, facet, facet_row=1, facet_scale="free_y",
                          ylab, leg_pos, xlim=c(NA,NA), ylim=c(NA,NA), pbreaks=5) {
  pdata <- indata %>% 
    select(eid,one_of(facet),contains(field)) %>% 
    pivot_longer(!c(eid,one_of(facet)),names_to="names",values_to="value") %>%  
    separate(names,c(NA,"rep"),field) %>%
    separate(rep, c("ins", "array"), "_") %>% 
    mutate_if(is.ordered,as.character) %>% 
    # mutate(value=if_else(!is.na(value) & value < 0,
    #                      ifelse(is.numeric(value), NA_integer_, NA_character_),
    #                      value)
    # ) %>% 
    filter(!is.na(value)) %>% 
    group_by(eid) %>%
    filter(row_number() == 1) %>% 
    ungroup() %>% 
    count(.data[[facet]],value) %>% 
    group_by(.data[[facet]]) %>% 
    mutate(perc=round(n/sum(n)*100,1)) %>% 
    ungroup()
    
  
  if(type=="death") {
    pdata <- pdata %>% 
      group_by(.data[[facet]]) %>% arrange(.data[[facet]],-n) %>% top_n(10) %>% ungroup() %>% 
      mutate(value=reorder_within(value,-n,.data[[facet]]))
  }
  
  if (type == "ipaq") {
    pdata <- pdata %>% 
      mutate(value=factor(value,levels=c("low","moderate","high")))
  }
  
  if(type == "alcohol") {
    pdata <- pdata %>% 
      mutate(value=factor(value,
                          levels=c("Prefer not to answer","Daily or almost daily",
                                   "Three or four times a week","Once or twice a week",
                                   "One to three times a month","Special occasions only","Never")))
    levels(pdata$value) <- c("N/A","Daily","3-4/week","1-2/week","1-3/month","Occas.","Never")
  }
  
  if(type == "yesno") {
    pdata <- pdata %>% mutate(value=factor(value,levels=c("Yes","No"))) 
  }
  
  if(type == "disc") {
    pdata <- pdata %>% 
      mutate(value=factor(value, levels=sort(unique(value))))
  }
  
  plot <- ggplot(pdata,aes(x=get(xvar), y=get(yvar), fill=get(fillvar))) +
    geom_col(width=0.7) +
    labs(x=xlab, y=ylab, fill=fillname) +
    scale_y_continuous(breaks = scales::pretty_breaks(pbreaks),limits=ylim) +
    theme_few() +
    scale_fill_viridis_d(option = "plasma") +
    facet_wrap(sym(facet), scales=facet_scale, nrow=facet_row) +
    theme(legend.position=leg_pos,
          legend.title = element_text(size=10),
          legend.text = element_text(size=9),
          legend.key.size = unit(0.9,"line"),
          # axis.text.x = element_blank(),
          # axis.ticks.x = element_blank(),
          panel.grid.major.y = element_line(colour = "gray",size=0.1),
          # legend.background = element_rect(fill="transparent"),
          # axis.text.y = element_blank(),
          # axis.ticks.y = element_blank(),
          # plot.margin = margin(t=6, r=6, b=-11, l=6,"pt"),
          # panel.grid.major.x = element_line(colour = "gray",size=0.1)
          # panel.grid.major.x = element_line(colour = "gray",size=0.1))
    )
  # plot postprocess
  if (type == "yesno"){
    plot <- plot +
      scale_fill_paletteer_d("awtools::mpalette") +
      geom_text(position=position_dodge(width=0.9), vjust = vjustn, 
                col=boxcol,
                aes(label=n), cex=3) +
      geom_text(position=position_dodge(width = 0.9), vjust = vjustperc, 
                col=boxcol,
                aes(label=paste0("(",perc,"%)")), cex=2.3)
  }
  
  if (type == "alcohol") {
    plot <- plot +
      theme(axis.text.x = element_blank(),
            axis.ticks.x = element_blank())
  }
  
  if(type == "death") {
    plot <- plot +
      scale_x_reordered() +
      scale_fill_few("Dark") +
      theme(axis.text.x = element_text(angle = 45,hjust = 1,size=8),
            axis.ticks.x = element_line())
  }
  
  if(type == "num"){
    plot <- plot +
      scale_x_continuous(breaks = scales::pretty_breaks(pbreaks),limits=xlim) +
      scale_y_continuous(breaks = scales::pretty_breaks(pbreaks),limits=ylim)
  }
  
  if(type == "disc"){
    plot <- plot +
      scale_fill_few("Dark")
  }
  
  return(plot)
}

###### extra functions
theme_few_src <- function(){
  theme_few() +
    theme(panel.grid.major.y = element_line(colour = "gray",size=0.1),
          panel.grid.major.x = element_line(colour = "gray",size=0.1))
}

plot_grid_title <- function(p1,p2,label="") {
  grid_title <- ggdraw() + 
    draw_label(
      label,
      fontface = 'bold',
      x = 0,
      hjust = 0
    ) +
    theme(
      # add margin on the left of the drawing canvas,
      # so title is aligned with left edge of first plot
      plot.margin = margin(0, 0, 0, 12)
    )
  if( label == "") {
    plot_grid(p1, p2, nrow=1)
  } else {
  plot_grid(grid_title,
            plot_grid(p1, p2, nrow=1),
            ncol = 1, rel_heights = c(0.1,1))
  }
}
