###This script will take all the needed data from rDock output SD file and will include it in an R variable.
#Afterwards, it should do the corresponding enrichment plots


##common features to load
library(ROCR);
library(xtable);
##load ligands and decoys
lig <- unique(read.table("../ligands/ligands.txt")[,1]);
dec <- unique(read.table("../decoys/ligands.txt")[,1]);
#dudsys <- strsplit(Sys.getenv("PWD"),"/")[[1]][6]	
args <- commandArgs(trailingOnly=TRUE);
dudsys <- args[1];
rdockprm <- "vina";
ratio <- FALSE;
#if (length(args) > 0){
#        rat_arg <- grep("ratio",args, value=TRUE)
#        if (length(rat_arg) > 0){
#                ratio <- TRUE
#        } else { ratio <- FALSE }
#
#        prm_arg <- grep("-.*",args,value=TRUE)
#        if (length(prm_arg) > 0) {
#                rdockprm <- strsplit(prm_arg,"-")[[1]][2];
#        } else { rdockprm <- "rdock_ligprep"}
#} else {
#        rdockprm <- "vina"
#        ratio <- FALSE;
#}


#folder <- paste(rdockprm,"/results",sep="");
#print (folder)


##RDOCK plots
	rdockRes <- read.table("rdock/results/dataforR_uq.txt",header=T);
        colnames(rdockRes)[1]="LigandName";

	rdockRes$IsActive <- as.numeric(rdockRes$LigandName %in% lig);
	
	predINTERuq <- prediction(rdockRes$INTER*-1, rdockRes$IsActive)
        perfINTERuq <- performance(predINTERuq, 'tpr','fpr')

###GLIDE plots
	glideRes <- read.table("glide/results/dataforR_uq.txt");
        colnames(glideRes)[1]="LigandName";
	colnames(glideRes)[2]="Scores";
        glideRes$IsActive <- as.numeric(glideRes$LigandName %in% lig);

        predSCORESglide <- prediction(glideRes$Scores*-1, glideRes$IsActive)
        perfSCORESglide <- performance(predSCORESglide, 'tpr','fpr')

##COMMON PLOTS
	pdf(paste(dudsys,"_glide_vs_rdock.pdf",sep=""))
	plot(perfINTERuq,col="blue",main=paste(dudsys,"-- Glide vs rDock"))
	abline(0,1,col="grey")
	plot(perfSCORESglide,col="green",add=TRUE)
	legend(0, 1, c("Glide", "rDock"), col = c("green","blue"), lty = c(1, 1))
	dev.off()

##SEMI LOGARITMIC

	glideLigs <- glideRes$LigandName
	rdockLigs <- rdockRes[with(rdockRes, order(INTER, LigandName)),]$LigandName
	#RDOCK AND GLIDE COMPARISON THEORETHICALS
	comp_rdock <- seq(0,1,1/length(perfINTERuq@y.values[[1]]))
        comp_rdock <- comp_rdock[c(2:length(comp_rdock))]
	comp_glide <- seq(0,1,1/length(perfSCORESglide@y.values[[1]]))
        comp_glide <- comp_glide[c(2:length(comp_glide))]
	
	#plot Glide semilog scale Enrichment	
	#y <- NULL
	#for (a in seq(1:length(glideLigs))){
	#y <- c(y,sum(lig %in% glideLigs[1:a]))
	#}
	xglideforsemilog=perfSCORESglide@x.values[[1]]
	xglideforsemilog[xglideforsemilog < 0.0005]=0.0005
	pdf(paste(dudsys,"_semilog_enr.pdf",sep=""))
	plot(xglideforsemilog,perfSCORESglide@y.values[[1]],type="l",xlab="False Positive Rate", ylab="True Positive Rate",xaxt="n", log="x", col="green",main=paste(dudsys,"-- Enrichment Comparison"))
	#add rDock Enrichment!
	xrdockforsemilog=perfINTERuq@x.values[[1]]
	xrdockforsemilog[xrdockforsemilog < 0.0005]=0.0005
	points(xrdockforsemilog, perfINTERuq@y.values[[1]],type="l",col="blue")
	axis(1, c(0,0.001,0.01,0.1,1))
	x<-seq(0,1,0.001)
	points(x,x,col="gray",type="l")
	legend("topleft", c("Glide", "rDock"), col = c("green","blue"), lty = c(1, 1),inset=0.05)
	dev.off()


###CALCULATION OF STATISTICS
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

	##GLIDE
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

	#make the matrix and export it in a latex table!
        row_data <- matrix(c(dudsys, round(auc.area_rdock,2),round(logauc.area_rdock,2), round(EF_rdock_max,2), round(EF_rdock_1,2),round(EF_rdock_20,2),dudsys, round(auc.area_glide,2),round(logauc.area_glide,2), round(EF_glide_max,2), round(EF_glide_1,2),round(EF_glide_20,2)),ncol=6,byrow=TRUE)
        rownames(row_data) <- c("rdock","glide")
        colnames(row_data) <- c("protein","AUC","logAUC", "EFmax","EF1","EF20")
	stats_tab <- as.data.frame(row_data)
	stats_latex <- xtable(stats_tab)
	print(stats_latex, type="latex", file=paste(dudsys,"_stats.tex",sep=""))

##RATIOS of rdock vs glide 
if (ratio){
	ratio_data <- matrix(c(dudsys, round(auc.area_rdock/auc.area_glide,2), round(EF_rdock_max/EF_glide_max,2), round(EF_rdock_1/EF_glide_1,2),round(EF_rdock_20/EF_glide_20,2)),ncol=6,byrow=TRUE)
	rownames(ratio_data) <- c("ratio rdock vs glide")
        colnames(ratio_data) <- c("protein","AUC", "EFmax","EF1","EF20")
	ratio_tab <- as.data.frame(ratio_data)
        ratio_latex <- xtable(ratio_tab)
        print(ratio_latex, type="latex", file=paste(dudsys,"_ratios.tex",sep=""))
	print ("Table with ratios done!")
}

##OTHER PARAM CALCULATIONS 
##RDOCK plots and statistics
#rdockprm="vina"
	if (rdockprm != "rdock_ligprep"){	
		if (rdockprm == "ligprep" || rdockprm == "time_perf_rdock" || rdockprm == "time_perf_glide"){
			newrdockRes <- read.table(paste(rdockprm,"/results/dataforR_uq.txt",sep=""));
			colnames(newrdockRes)[1]="LigandName";
			colnames(newrdockRes)[2]="INTER";
		} else if (rdockprm == "autodock" || rdockprm == "vina" ){
			newrdockRes <- read.table(paste(rdockprm,"/results/dataforR_uq.txt",sep=""),header=T);
                        colnames(newrdockRes)[1]="LigandName";
                        colnames(newrdockRes)[2]="INTER";
		} else {
			newrdockRes <- read.table(paste(rdockprm,"/results/dataforR_uq.txt",sep=""),header=T);
	                colnames(newrdockRes)[1]="LigandName";
		}
		
		newrdockRes$IsActive <- as.numeric(newrdockRes$LigandName %in% lig);
		
		newpredINTERuq <- prediction(newrdockRes$INTER*-1, newrdockRes$IsActive)
	        newperfINTERuq <- performance(newpredINTERuq, 'tpr','fpr')
	
		newcomp_rdock <- seq(0,1,1/length(newperfINTERuq@y.values[[1]]))
	        newcomp_rdock <- newcomp_rdock[c(2:length(newcomp_rdock))]
	        newauc_rdock <- performance(newpredINTERuq, "auc")
	        newauc.area_rdock <- slot(newauc_rdock, "y.values")
	        newauc.area_rdock <- newauc.area_rdock[[1]]
		newlogauc.area_rdock <- get_logAUC(newperfINTERuq@x.values[[1]],newperfINTERuq@y.values[[1]])
#compare yvalues for exact random values, x.values!! x.values is not uniform
	        #newEF_rdock <- newperfINTERuq@y.values[[1]]/newcomp_rdock
	        newEF_rdock <- newperfINTERuq@y.values[[1]]/newperfINTERuq@x.values[[1]]
		newEF_1 <- newEF_rdock[which (newperfINTERuq@x.values[[1]] > 0.01)[1]]
		newEF_20 <- newEF_rdock[which (newperfINTERuq@x.values[[1]] > 0.2)[1]]
		newEF_max <- max(newEF_rdock[newEF_rdock != 'NaN'][newEF_rdock[newEF_rdock !='NaN'] != 'Inf'])
		
		pdf(paste(dudsys,"_",rdockprm,"_glide_vs_rdock.pdf",sep=""))
	        plot(perfINTERuq,col="blue",main=paste(dudsys,"-- Glide vs rDock &",rdockprm))
	        abline(0,1,col="grey")
	        plot(perfSCORESglide,col="green",add=TRUE)
	        plot(newperfINTERuq,col="red",add=TRUE)
	        legend(0, 1, c("Glide", "rDock",rdockprm), col = c("green","blue","red"), lty = c(1, 1,1))
	        dev.off()

	        #RDOCK AND GLIDE COMPARISON THEORETHICALS
	        comp_rdock <- seq(0,1,1/length(perfINTERuq@y.values[[1]]))
	        comp_rdock <- comp_rdock[c(2:length(comp_rdock))]
	        comp_glide <- seq(0,1,1/length(perfSCORESglide@y.values[[1]]))
	        comp_glide <- comp_glide[c(2:length(comp_glide))]
	
	        #plot Glide semilog scale Enrichment    
	        #y <- NULL
	        #for (a in seq(1:length(glideLigs))){
	        #y <- c(y,sum(lig %in% glideLigs[1:a]))
	        #}
	
		xglideforsemilog=perfSCORESglide@x.values[[1]]
	        xglideforsemilog[xglideforsemilog < 0.0005]=0.0005
	        pdf(paste(dudsys,"_semilog_enr.pdf",sep=""))
	        plot(xglideforsemilog,perfSCORESglide@y.values[[1]],type="l",xlab="False Positive Rate", ylab="True Positive Rate",xaxt="n", log="x", col="green",main=paste(dudsys,"-- Enrichment Comparison"))
	        #add rDock Enrichment!
	        xrdockforsemilog=perfINTERuq@x.values[[1]]
	        xrdockforsemilog[xrdockforsemilog < 0.0005]=0.0005
	        points(xrdockforsemilog, perfINTERuq@y.values[[1]],type="l",col="blue")
        	axis(1, c(0,0.001,0.01,0.1,1))
	        x<-seq(0,1,0.001)
	        xnewrdockforsemilog=newperfINTERuq@x.values[[1]]
	        xnewrdockforsemilog[xnewrdockforsemilog < 0.0005]=0.0005
		points(xnewrdockforsemilog,newperfINTERuq@y.values[[1]],type="l",col="red")
	        points(x,x,col="gray",type="l")
	        legend("topleft", c("Glide", "rDock", rdockprm), col = c("green","blue","red"), lty = c(1, 1,1),inset=0.05)
	        dev.off()



#		newrow_data <- matrix(c(dudsys,rdockprm, round(newauc.area_rdock,2), round(max(newEF_rdock),2), round(newEF_rdock[length(newcomp_rdock)/100+EFcorr],2),round(newEF_rdock[length(newcomp_rdock)/5],2)),ncol=6,byrow=TRUE)
#	        rownames(newrow_data) <- c("rdock")
#	        colnames(newrow_data) <- c("protein","PRM file","AUC", "EFmax","EF1","EF20")
#	        newstats_tab <- as.data.frame(newrow_data)
#	        newstats_latex <- xtable(newstats_tab)
#	        print(newstats_latex, type="latex", file=paste(dudsys,"_",rdockprm,"_stats.tex",sep=""))
		
		##update all stats tex file
		#make the matrix and export it in a latex table!
        	row_data <- matrix(c(dudsys, round(auc.area_rdock,2),round(logauc.area_rdock,2), round(EF_rdock_max,2), round(EF_rdock_1,2),round(EF_rdock_20,2),dudsys, round(auc.area_glide,2),round(logauc.area_glide,2), round(EF_glide_max,2), round(EF_glide_1,2),round(EF_glide_20,2),dudsys, round(newauc.area_rdock,2),round(newlogauc.area_rdock,2), round(newEF_max,2), round(newEF_1,2),round(newEF_20,2)),ncol=6,byrow=TRUE)
	        rownames(row_data) <- c("rDock","Glide","Vina")
	        colnames(row_data) <- c("protein","AUC","logAUC", "EFmax","EF1","EF20")
	        stats_tab <- as.data.frame(row_data)
	        stats_latex <- xtable(stats_tab)
	        print(stats_latex, type="latex", file=paste(dudsys,"_all_stats.tex",sep=""))
		}
