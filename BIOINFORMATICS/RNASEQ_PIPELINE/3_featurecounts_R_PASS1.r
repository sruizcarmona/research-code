library(Rsubread)
#bam_files <- readTargets("bam_files")
# to remove the 2 problematic files --> [c(-15,-31)]
bam_files <- Sys.glob("../STAR_ALIGNMENT/*.bam")
annotext <- Sys.glob("/sysgen/raw/external/DomainBioinfo/JennyOoi/mouse_lncRNA_resources/genes.91_with_chr_IDs.gtf")
# first pass (ensembl)
#gene IDS
fcounts_ensembl <- featureCounts(files=bam_files,annot.ext=annotext,isGTFAnnotationFile=TRUE,GTF.featureType="exon",GTF.attrType="gene_id",isPairedEnd=TRUE,nthreads=32,strandSpecific=2)
#GENE NAMES
#fcounts_ensembl <- featureCounts(files=bam_files,annot.ext="/projects/sysgen/BioinformaticsPlatform/JennyOoi/mouse_lncRNA_resources/genes.91_with_chr_IDs.gtf",isGTFAnnotationFile=TRUE,GTF.featureType="exon",GTF.attrType="gene_name",isPairedEnd=TRUE,nthreads=8)
#fcounts_ensembl <- featureCounts(files=bam_files,annot.ext="/home/sruizcarmona/WORK/REF_GENOMES/MUSMUSCULUS/UCSC_mm10/genes.gtf",isGTFAnnotationFile=TRUE,GTF.featureType="exon",GTF.attrType="gene_name",isPairedEnd=TRUE,nthreads=8)
saveRDS(fcounts_ensembl, file = "fcounts.JENNYGTF.stranded2.rds")

