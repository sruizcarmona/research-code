#!/usr/bin/Rscript
#command args
args <- commandArgs(trailingOnly=TRUE);
mol2file <- args[1];
wasfile <- args[2];
outfile <- args[3];

#get info from mol2
a <- readLines(mol2file)
#init 4 variables for mol2
mol2_aNames <- NULL
mol2_rNames <- NULL
mol2_rIDs <- NULL
mol2_weights <- NULL

for (line in a){
	if(nchar(line) > 80){
		mol2_aNames <- c(mol2_aNames,as.character(sapply(list(unlist(strsplit(line," "))[unlist(strsplit(line," ")) != ""]), "[", c(2,8)))[1])
		mol2_rNames <- c(mol2_rNames,as.character(sapply(list(substring(as.character(sapply(list(unlist(strsplit(line," "))[unlist(strsplit(line," ")) != ""]),"[",c(2,8)))[2],1:4,3:6)),"[",c(1,4)))[1])
		mol2_rIDs <- c(mol2_rIDs,as.character(sapply(list(substring(as.character(sapply(list(unlist(strsplit(line," "))[unlist(strsplit(line," ")) != ""]),"[",c(2,8)))[2],1:4,3:6)),"[",c(1,4)))[2])
		mol2_weights <- c(mol2_weights, strsplit(line," ")[[1]][length(unlist(strsplit(line," ")))])
	}
}

#get info from -was rbcavity option
b <- readLines(wasfile)
#init 3 variables for was file
was_aNames <- NULL
was_rNames <- NULL
was_rIDs <- NULL
for (line in b){
	if (nchar(line) > 100 && length(unlist(strsplit(line,","))) == 12){
		was_aNames <- c(was_aNames,unlist(strsplit(line,","))[7])	
		was_rNames <- c(was_rNames,unlist(strsplit(line,","))[5])	
		was_rIDs <- c(was_rIDs,unlist(strsplit(line,","))[6])	
	}
}

#loop in was lengtht to find atoms in 
plot_x <- NULL
plot_y <- NULL
axis_x <- NULL
for (i in c(1:length(was_aNames))){
	#jump to next atom if it is not a polar atom (also H are not needed as they have the same value than the bound atom)
	if (grepl("^[CHS]",was_aNames[i],perl=TRUE)){
		next
	}#if not polar continue
	for (j in c(1:length(mol2_aNames))){ 
		if (was_aNames[i] == mol2_aNames[j] && was_rNames[i] == mol2_rNames[j] && was_rIDs[i] == mol2_rIDs[j]){
			plot_x <- c(plot_x, paste(was_aNames[i],was_rNames[i],was_rIDs[i],sep="_"))
			plot_y <- c(plot_y, as.numeric(mol2_weights[j]))
			axis_x <- c(axis_x, was_rIDs[i])
		}#if check mol2 and was atom is the same
	}#for length mol2
}#for length was

pdf(outfile)

plot(c(1:length(plot_y)),plot_y,pch=16,main=paste(mol2file,"Cavity mol2 Weighting"),xlab="Receptor Residue", xaxt="n",ylab="mol2 Weight",ylim=c(1,1.15*max(plot_y)))
axis(side=1,at=c(1:length(plot_y)),lab=axis_x,cex.axis=0.6)
text(c(1:length(plot_y))+0.3,plot_y,lab=plot_x,srt=90,cex=0.7,pos=3,offset=2.2)

dev.off()



