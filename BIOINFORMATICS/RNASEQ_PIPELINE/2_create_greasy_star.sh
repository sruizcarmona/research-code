for f in ../00_fastq_trimmed_ANALYSIS/SORTMERNA/SORTMERNA_OK/UNMERGED/*non-rRNA.PAIR1.fastq;
do
    b=`basename $f .fastq`
    echo STAR --runThreadN 8 --genomeDir /sysgen/workspace/users/sruizcarmona/WORK/REF_GENOMES/MUSMUSCULUS/UCSC_mm10/GenomeIndex/ --readFilesIn $f ${f/PAIR1/PAIR2} --outSAMtype BAM SortedByCoordinate --outFileNamePrefix STAR_ALIGNMENT/${b/.PAIR1/}_ --limitBAMsortRAM 5331604476
done
