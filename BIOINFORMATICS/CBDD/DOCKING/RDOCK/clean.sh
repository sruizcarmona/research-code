#!/bin/sh
vndr=$1
sdout=$vndr\_raw_hits.sd

if [ -e ${sdout} ]; then
  echo ARE YOU SURE YOU WANT TO DO THIS
  echo ${sdout} already exists
  echo To rerun the script remove ${sdout} manually first
  exit
fi

echo All pre-sorted SD files in ./out/ will be concatenated and sorted by SCORE.INTER into a single file ${sdout}
echo All log and out files will be packed in separated tar.gz files to remove intermediate files.

#sorting all pre-sorted files 
cat ./out/*_sorted.sd | sdsort -n -f'SCORE.INTER' | sdfilter -f'$_COUNT == 1' > ${sdout}
echo Each block of consecutive records per ligand have been presorted by SCORE ready for filtering and manual inspection

#log files
echo Packing log files in log_files_raw.tar.gz...
#tar -czf log_files_raw.tar.gz log/
echo DONE
#sd files
echo Packing all SD files in out_files_raw.tar.gz...
tar -czf out_files_raw.tar.gz out/
echo DONE
echo You may now safely remove the ./log/ and ./out/ directories if you wish to save disk space

