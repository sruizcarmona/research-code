#pathway <- ("")
#decoys <- read.table("~/work/DUD/
readligands <- function(pwy,file){
	res <<- read.table(file)
	res <<- unique(res[,1])
	
	if(pwy==2){
		lig <<- read.table("../../ligands/ligands.txt")
		dec <<- read.table("../../decoys/ligands.txt")		
		}
	if(pwy==3){
                lig <<- read.table("../../../ligands/ligands.txt")
                dec <<- read.table("../../../decoys/ligands.txt")
                }
	lig <<- unique(lig[,1])
	dec <<- unique(dec[,1])
	}	

