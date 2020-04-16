###This script will take all the needed data from rDock output SD file and will include it in an R variable.
#Afterwards, it should do the corresponding enrichment plots

args <- commandArgs(trailingOnly=TRUE);
dudsys <- args[1];

library(ROCR);
##load ligands and decoys
lig <- unique(read.table("../../../ligands/ligands.txt")[,1]);
dec <- unique(read.table("../../../decoys/ligands.txt")[,1]);
#dudsys <- strsplit(Sys.getenv("PWD"),"/")[[1]][6]	
#folder <- strsplit(Sys.getenv("PWD"),"/")[[1]][8]
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
	system(paste("if [ ! -e dataforR_uq.txt ]; then sdsort -n -s -f'VINA_SCORE' ",dudsys,"_all_results.sd | sdfilter -s'_TITLE1' -f'$_COUNT == 1' | sdsort -n -f'VINA_SCORE' > ",dudsys,"_1pose_sorted.sd; sdreport -t'VINA_SCORE' ",dudsys,"_1pose_sorted.sd | awk '{print $2,$3}' > dataforR_uq.txt; fi",sep=""));
	uniqRes <- read.table("dataforR_uq.txt",header=T);
        colnames(uniqRes)[1]="LigandName";

	uniqRes$IsActive <- as.numeric(uniqRes$LigandName %in% lig);
	
	predINTERuq <- prediction(uniqRes$VINA_SCORE*-1, uniqRes$IsActive)
        perfINTERuq <- performance(predINTERuq, 'tpr','fpr')
	jpeg(paste(dudsys,"_Rvina_enr.jpg",sep=""))
	plot(perfINTERuq,main="vina SCORE kcal/mol")
	abline(0,1,col="grey")
	dev.off()
	
	newauc_rdock <- performance(predINTERuq, "auc")
        newauc.area_rdock <- slot(newauc_rdock, "y.values")
        newauc.area_rdock <- newauc.area_rdock[[1]]
	print(newauc.area_rdock)
	write(newauc.area_rdock,paste(dudsys,"_auc.txt",sep=""))
