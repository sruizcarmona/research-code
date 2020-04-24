###This script will take all the needed data from rDock output SD file and will include it in an R variable.
#Afterwards, it should do the corresponding enrichment plots

args <- commandArgs(trailingOnly=TRUE);
dudsys <- args[1]
library(ROCR);
##load ligands and decoys
lig <- unique(read.table("../../../ligands/ligands.txt")[,1]);
dec <- unique(read.table("../../../decoys/ligands.txt")[,1]);
#dudsys <- strsplit(Sys.getenv("PWD"),"/")[[1]][6]	
##ALL POSES FOR ALL LIGANDS (RAW OUTPUT)	
#	##load dataforR.txt or make it with sdreport
#	system("if [ ! -e dataforR.txt ]; then sdreport -t  *_all_results.sd | awk '{print $2,$3,$4,$5,$6,$7}' > dataforR.txt; fi");
#	allRes <- read.table("dataforR.txt",header=T);
#	colnames(allRes)[1]="LigandName";
#	
#	allRes$IsActive <- as.numeric(allRes$LigandName %in% lig);
#		
#	#####ALL RESULTS, NOT ELIMINATING REPEATED ONES
#	predINTER <- prediction(allRes$INTER*-1, allRes$IsActive)
#	perfINTER <- performance(predINTER, 'tpr','fpr')
#	
#	#predINTRA <- prediction(allRes$INTRA*-1, allRes$IsActive)
#	#perfINTRA <- performance(predINTRA, 'tpr','fpr')
#	#predTOTAL <- prediction(allRes$TOTAL*-1, allRes$IsActive)
#	#perfTOTAL <- performance(predTOTAL, 'tpr','fpr')
#	#predVDW <- prediction(allRes$VDW*-1, allRes$IsActive)
#	#perfVDW <- performance(predVDW, 'tpr','fpr')
#	
#	#par(mfrow=c(2,2))
#	plot(perfINTER,main="INTER")
#	abline(0,1)
#	#plot(perfINTRA,main="INTRA")
#	#abline(0,1)
#	#plot(perfTOTAL,main="TOTAL")
#	#abline(0,1)
#	#plot(perfVDW,main="VDW")
#	#abline(0,1)
	


###REDO ALL plots but taking into account only 1 pose per ligand --> unique!
	system(paste("if [ ! -e dataforR_uq.txt ]; then sdsort -n -s -fSCORE ",dudsys,"_all_results.sd | sdfilter -f'$_COUNT == 1' > ",dudsys,"_1poseperlig.sd; sdreport -t ",dudsys,"_1poseperlig.sd | awk '{print $2,$3,$4,$5,$6,$7}' > dataforR_uq.txt; fi",sep=""));
	uniqRes <- read.table("dataforR_uq.txt",header=T);
        colnames(uniqRes)[1]="LigandName";

	uniqRes$IsActive <- as.numeric(uniqRes$LigandName %in% lig);
	
	predINTERuq <- prediction(uniqRes$INTER*-1, uniqRes$IsActive)
        perfINTERuq <- performance(predINTERuq, 'tpr','fpr')
	jpeg(paste(dudsys,"_Rinter_enr.jpg",sep=""))
	plot(perfINTERuq,main="rDock INTER")
	abline(0,1,col="grey")
	dev.off()
###print statistics

	source("~/work/scripts/R/get_logAUC.R")
        ##RDOCK
        auc_rdock <- performance(predINTERuq, "auc")
        auc.area_rdock <- slot(auc_rdock, "y.values")
        auc.area_rdock <- auc.area_rdock[[1]]
        logauc.area_rdock <- get_logAUC(perfINTERuq@x.values[[1]],perfINTERuq@y.values[[1]])
#compare yvalues for exact random values, x.values!! x.values is not uniform
        #EF_rdock <- perfINTERuq@y.values[[1]]/comp_rdock
        EF_rdock <- perfINTERuq@y.values[[1]]/perfINTERuq@x.values[[1]]
        EF_rdock_1 <- EF_rdock[which(perfINTERuq@x.values[[1]] > 0.01)[1]]
        EF_rdock_20 <- EF_rdock[which(perfINTERuq@x.values[[1]] > 0.2)[1]]
        EF_rdock_max <- max(EF_rdock[EF_rdock != 'NaN'][EF_rdock[EF_rdock !='NaN'] != 'Inf'])
	print(auc.area_rdock)
	print(logauc.area_rdock)
	write(auc.area_rdock,file=paste(dudsys,"_auc.txt",sep=""))
	write(logauc.area_rdock,file=paste(dudsys,"_logauc.txt",sep=""))
