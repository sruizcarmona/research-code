##this script will calculate the enrichment using R and plot the results
##it will work in GLIDE

#sdsort -f_TITLE1 glide_in_pv.sd > test.sd
#sdsort -n -s -fr_i_docking_score test.sd | sdfilter -s'_TITLE1' -f'$_COUNT == 1' | sdsort -n -f'r_i_docking_score' > final.sd




#convert maegz output to sd.. in order to make it easer to parse with sdreport tool
#system("sdconvert -imae glide_in_pv.maegz -osd glide_in_pv.sd");

#next line gets scores of all the ligands and saves them in a file called ordered_scores.txt
#system(paste("sdreport glide_in_pv.sd | grep docking | awk '{split($0,a,\"","\"","\");print a[2]}' > ordered_scores.txt"));
#system(cat("echo sdreport glide_in_pv.sd | grep docking | awk '{split($0,a,\"\\\"\");print a[2]}' > ordered_scores.txt"));

####THERE MUST BE IN THE FOLDER TWO FILES :
##	1- CONTAINING THE SCORES OF ALL THE LIGANDS
##	2- NAMES OF ALL LIGANDS

args <- commandArgs(trailingOnly=TRUE);
#dudsys <- strsplit(Sys.getenv("PWD"),"/")[[1]][6]
dudsys <- args[1];

library(ROCR);
##load ligands and decoys
lig <- unique(read.table("../../../ligands/ligands.txt")[,1]);
dec <- unique(read.table("../../../decoys/ligands.txt")[,1]);

###DO ALL plots but taking into account only 1 pose per ligand --> unique!
	#next command transforms maegz format to sd format
	#system(paste("if [ ! -e ",dudsys,"_all_results.sd ]; then $SCHRODINGER/utilities/sdconvert -imae ",dudsys,"_all_results.maegz -osd ",dudsys,"_all_results.sd; fi;",sep=""));
	
	#next command sorts all the results and gets the best pose for each ligand
	#system(paste("if [ ! -e ",dudsys,"_glide_sorted.sd ]; then sdfilter -f'$_REC != 1' ",dudsys,"_all_results.sd | sdsort -f_TITLE1 | sdfilter -s'_TITLE1' -f'$_COUNT == 1' | sdsort -n -f'r_i_docking_score' > ",dudsys,"_glide_sorted.sd; fi;",sep=""));

	#now, once we have 1 pose per ligand sorted by score... we can retrieve the names and the scores to use in R
	system(paste("if [ ! -e dataforR_uq.txt ]; then sdreport -l ",dudsys,"_glide_sorted.sd | awk '{if ($0 ~ /TITLE1/){tit=$3; tit=substr(tit,2,length(tit)-2);} if ($0 ~ /docking/){score=$3;score=substr(score,2,length(score)-2); print tit,score}}' > dataforR_uq.txt; fi;",sep=""));
        
	glideRes <- read.table("dataforR_uq.txt");
        colnames(glideRes)[1]="LigandName";
	colnames(glideRes)[2]="Scores";
        glideRes$IsActive <- as.numeric(glideRes$LigandName %in% lig);

        predSCORESglide <- prediction(glideRes$Scores*-1, glideRes$IsActive)
        perfSCORESglide <- performance(predSCORESglide, 'tpr','fpr')
        jpeg("glide_enr.jpg")
        plot(perfSCORESglide,main="Glide Scores ENR")
        abline(0,1,col="grey")
        dev.off()

	source("~/work/scripts/R/get_logAUC.R")
	auc_glide <- performance(predSCORESglide,"auc")
        auc.area_glide <- slot(auc_glide, "y.values")
        auc.area_glide <- auc.area_glide[[1]]
        logauc.area_glide <- get_logAUC(perfSCORESglide@x.values[[1]],perfSCORESglide@y.values[[1]])
#compare yvalues for exact random values, x.values!! x.values is not uniform
        #EF_glide <- perfSCORESglide@y.values[[1]]/comp_glide
        EF_glide <- perfSCORESglide@y.values[[1]]/perfSCORESglide@x.values[[1]]
        EF_glide_1 <- EF_glide[which(perfSCORESglide@x.values[[1]] > 0.01)[1]]
        EF_glide_20 <- EF_glide[which(perfSCORESglide@x.values[[1]] > 0.2)[1]]
        EF_glide_max <- max(EF_glide[2:length(EF_glide)])
        EF_glide_max <- max(EF_glide[EF_glide != 'NaN'][EF_glide[EF_glide !='NaN'] != 'Inf'])
	print(auc.area_glide)
	write(auc.area_glide,paste(dudsys,"_auc.txt",sep=""))
