library(xtable);
library(ROCR);
dudsys <- strsplit(Sys.getenv("PWD"),"/")[[1]][6]

########RDOCK 
	uniqRes <- read.table("rdock/results/dataforR_uq.txt",header=T);
	colnames(uniqRes)[1]="LigandName";
	lig <- unique(read.table("../ligands/ligands.txt")[,1]);
	uniqRes$IsActive <- as.numeric(uniqRes$LigandName %in% lig);
	
	predINTERuq <- prediction(uniqRes$INTER*-1, uniqRes$IsActive)
	perfINTERuq <- performance(predINTERuq, 'tpr','fpr')


	comp <- seq(0,1,1/length(perfINTERuq@y.values[[1]]))
	comp <- comp[c(2:length(comp))]

	auc <- performance(predINTERuq, "auc")
	auc.area <- slot(auc, "y.values") 
	auc.area <- auc.area[[1]]

	EF <- perfINTERuq@y.values[[1]]/comp

	row_data <- matrix(c(dudsys, round(auc.area,2), round(max(EF),2), round(EF[length(comp)/100],2),round(EF[length(comp)/5],2)),ncol=5,byrow=TRUE)
	rownames(row_data) <- "rdock"
	colnames(row_data) <- c("protein","AUC", "EFmax","EF1","EF20")


####GLIDE





	stats_tab <- as.data.frame(row_data)

stats_xtab <- xtable(stats_tab)

print(stats_xtab, type="latex", file="rdock_stats.tex")

