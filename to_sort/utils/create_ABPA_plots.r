#!/usr/bin/Rscript
args <- commandArgs(trailingOnly=TRUE);
dudsys <- args[1];
filesys <- args[2]

#read file and get systems
sys <- as.character(read.table(filesys)[,1])
#create variables for plotting
x <- c(1:5)
mainlabs <- c("ASA","SLOPE","ASA+SLOPE","CONTROL")
xlabels <- c(1,2,3,5,10)

pdf(file=paste(dudsys,"_summary.pdf",sep=""))
#pdf(width=800,height=600,file=paste(dudsys,"_summary.pdf",sep=""))
#define par output
par(oma=c(2,2,3,2))
par(mgp=c(2.3,0.7,0))
par(mar=c(4,4,2,0))
par(mfrow=c(2,2))

#plot 3 first groups of parameters
for (n in c(1,2,3)) {
	blist <- NULL
	clist <- NULL
	for (i in sys[(n*5-4):(n*5)]){blist=c(blist,read.table(file.path(i,paste(dudsys,"_auc.txt",sep="")))[,1])}
	for (j in sys[(n*5-4):(n*5)]){clist=c(clist,read.table(file.path(j,paste(dudsys,"_logauc.txt",sep="")))[,1])}
	plot(x,blist,type="o",pch=16,ylim=c(0,1),xaxt="n",col="blue",main=mainlabs[n],ylab= if (n %% 2 == 1) "AUC/logAUC" else "",xlab=if (n %/% 1.5 == 2) "Weighting Factor" else "",cex.lab=1.5)
	text(x,blist, labels=round(blist,2), cex= 0.8, pos=3,col="blue")
	axis(1,at=c(1:5),labels=xlabels)
	points(x,clist,type="o",pch=16,col="darkorange2")
	text(x,clist, labels=round(clist,2), cex= 0.8, pos=3,col="darkorange2")
}

#add control to plots
x <- c(1:4)
blist <- NULL
clist <- NULL
controllabs <- c("ALL 3","ALL 5","NOs 3","NOs 5")
for (i in sys[16:19]){blist=c(blist,read.table(file.path(i,paste(dudsys,"_auc.txt",sep="")))[,1])}
for (j in sys[16:19]){clist=c(clist,read.table(file.path(j,paste(dudsys,"_logauc.txt",sep="")))[,1])}
plot(x,blist,type="o",pch=16,ylim=c(0,1),xaxt="n",col="blue",main=mainlabs[4],ylab= "",xlab="Weighting Factor",cex.lab=1.5)
text(x,blist, labels=round(blist,2), cex= 0.8, pos=3,col="blue")
axis(1,at=c(1:4),labels=controllabs)
points(x,clist,type="o",pch=16,col="darkorange2")
text(x,clist, labels=round(clist,2), cex= 0.8, pos=3,col="darkorange2")
title(dudsys,outer=TRUE)

dev.off()
