library(plotrix)
pdf("kk.pdf", width=8)
 vgridlab<-
  c("Jul","Aug","Sep","Oct","Nov","Dec","Jan","Feb","Mar","Apr")
 info2<-list(labels=c("Virtual Screening","Docking Program Validation","Experimental Validation","High Throughput Protocol","Characterization of Active Compounds", "Database Management","Selection of more Interfaces"),
  starts=c(1.1,2.1,3.1,7.1,8.1,6.1,9.1),
  ends=c(9.0,6.5,8.1,9.9,10.9,10.9,10.9))
 gantt.chart(info2,vgridlab=vgridlab,vgridpos=1:10,taskcolors="black")
dev.off()
