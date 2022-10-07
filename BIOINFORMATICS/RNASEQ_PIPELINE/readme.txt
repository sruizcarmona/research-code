steps:

sortmerna
- to remove rrna et al
- merge all the reads before!! Otherwise it can remove some reads from one of the 2 reads and then STAR gets crazy about the errors.
- and then "unmerge", so STAR runs with correct PAIR1 and PAIR2 files for the alignment.
- ATTENTION: sometimes a bug appears here and adds empty lines (https://www.biostars.org/p/314858/), fix by removing those lines and STAR will run properly and the lib size will be correct.

STAR
- Continue with STAR after all sortmerna jobs have finished (with merged reads).
- Standard STAR alignment, with BAM output sorted by coordinate
- Using as reference mm10 from UCSC as built in previous projects.

featurecounts
- I will use featurecounts to count mapped reads in the mm10 genome.
- As input, it takes the bam file from STAR and the reference GTF for the genome.

DE analysis in R
- I like DESeq2
- Other software, see markdown report for details (e.g. biotype, gsea, lncrna, etc)
