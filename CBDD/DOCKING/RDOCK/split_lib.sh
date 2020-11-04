#!/bin/sh

#obtain ligands from path and for each file, gunzip, split into 10 different files and save it in 1 folder in working directory
#ls $1
for file in $1/$2*
 do
	#echo $file | sed -e 's/.*['$2'_]//' -e 's/.sd.gz//'
	#echo $file
	mkdir $2_$(echo $file | sed 's/.*\([0-9]\{3\}\).*/\1/')
	cd $2_$(echo $file | sed 's/.*\([0-9]\{3\}\).*/\1/')
	gunzip $file
	sdsplit -500 -o$2_$(echo $file | sed 's/.*\([0-9]\{3\}\).*/\1/')_split $(echo $file | sed  's/.sd.gz/.sd/')
	gzip $(echo $file | sed  's/.sd.gz/.sd/')
	#echo $file | sed  's/.sd.gz/.sd/'	
	for splfile in $2_$(echo $file | sed 's/.*\([0-9]\{3\}\).*/\1/')_split[0-9].sd
	do
		mv $splfile $(echo $splfile | sed 's/split/split0/')
	        #mv $file ${file:s/clean_set_3D_/clean_set_3D_00/}

	done

	cd ..
done

