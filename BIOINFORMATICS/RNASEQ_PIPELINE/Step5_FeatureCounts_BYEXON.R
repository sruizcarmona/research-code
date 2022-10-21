#----------------------------------------------------------------
# Obtain Counts using FeatureCounts 
#----------------------------------------------------------------
featureCounts -p -C -B -Q 10 -T 10 -t exon -g exon_id -a /home/sruizcarmona/WORKSPACE/WORK/REF_GENOMES/MUSMUSCULUS/UCSC_mm10/genes.gtf \
-o FeatureCounts/MuscleMouse_counts_byexon.txt ../StarAlignment/*bamAligned.sortedByCoord.out.bam

featureCounts -p -C -B -Q 10 -T 10 -t exon -g exon_id -a  \
-o FeatureCounts/mm10_ensembl_counts_byexon.txt ../StarAlignment/*bamAligned.sortedByCoord.out.bam

featureCounts -p -C -B -Q 10 -T 10 -t exon -g exon_id --extraAttributes gene_name,gene_id,exon_number \
-a /home/sruizcarmona/WORKSPACE/WORK/REF_GENOMES/MUSMUSCULUS/ensembl/Mus_musculus.GRCm38.100.gtf \
-o FeatureCounts/mm10_ensembl_byexon.txt \
../StarAlignment/*.bamAligned.sortedByCoord.out.bam

featureCounts -f -p -C -B -Q 10 -T 10 -t exon -g gene_id \
-a  /home/sruizcarmona/WORKSPACE/WORK/REF_GENOMES/MUSMUSCULUS/UCSC_mm10/genes.gtf \
-o test_all.txt ../StarAlignment/*bam
