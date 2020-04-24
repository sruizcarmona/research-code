#!/bin/sh
echo Working in $1 files!
#loop for all the folders in EKAL ligand folder
for folder in ../$1_*
do
	
#	mkdir $folder
#	mkdir `echo $folder | sed 's/.*\(EKAL_[0-9]*\).*/\1/'`
	rot=`echo $folder | sed 's/.*\('$1'_[0-9]*\).*/\1/'`
	mkdir $rot
	echo $rot
	#create a folder named exactly as the folder in ligands folder
	cd $rot
	#change directory to it

	#loop through all the files in each folder and create the corresponding queue file
	for file in ../../$rot/*.sd
	do
#		echo $file | sed 's/.*\('$1'_[0-9]\{3\}_split[0-9]\{2\}.sd\)/\1/'
	#	echo $file
		rfile=`echo $file | sed 's/.*\('$1'_[0-9]\{3\}_split[0-9]\{2\}.sd\)/\1/'`
#		echo $rfile
	        python $SCRIPTS/rbdock/createQin_cacyrbdock.py -t $SCRIPTS/files/rdock_cacy_tmp.q -p $rot -i $rfile -o $rfile -r rdock_filter.txt -a ../../cacy.as -m ../../cacy.mol2 -l ../../reference_bs.sdf -n $rfile -c ../../pharma_cacy.const -q ../../cacy.prm 
	        echo DONE $rot files!! 
	done	
	cd ..

done

