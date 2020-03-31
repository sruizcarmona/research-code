echo 'Retrieving DUD files for' $1

#DECOYS files from teckel
##AS TECKEL is not working.. fixed it to download it from webpage
	mkdir $1/decoys
	echo -e '\nDecoys...'
	#scp -P 31415 sergi@161.116.198.176:work/DUD/dud_decoys2006/$1_decoys.mol2.gz $1/decoys
	wget http://dud.docking.org/r2/databases/dud_decoys2006/$1_decoys.mol2.gz 2> $1/getDUD_$1.log
	mv $1_decoys.mol2.gz $1/decoys
	
	#unzip them and convert them to sd format
	gunzip $1/decoys/$1_decoys.mol2.gz 2>> $1/getDUD_$1.log
	babel -imol2 $1/decoys/$1_decoys.mol2 -osd $1/decoys/$1_decoys.sd 2>> $1/getDUD_$1.log
	#$SCHRODINGER/utilities/sdconvert -isd $1/decoys/$1_decoys.sd -omae $1/decoys/$1_decoys.maegz

	#sdreport $1/decoys/$1_decoys.sd | grep 'TITLE1 ' > sd.txt
	#perl -e 'open(IN,"sd.txt"); while(<IN>){ chomp; @line=split(" ",$_); $name=$line[2]; print substr($name,1,-1); print"\n"} close(IN);' > ligands.txt

	#last two lines can be done with the following one
	#this is to make results analysis using R scripts
	sdreport -t -nh $1/decoys/$1_decoys.sd | awk '{print $2}' > ligands.txt
	mv ligands.txt $1/decoys/
	#rm sd.txt

	echo -e '\nDecoys files can be found in folder '$1'/decoys\n'


#LIGANDS files from teckel
##also fixed to download it from webpage
#same as before but with ligands
	mkdir $1/ligands
	echo -e '\nLigands...'
	#scp -P 31415 sergi@161.116.198.176:work/DUD/dud_ligands2006/$1_ligands.mol2.gz $1/ligands
	wget http://dud.docking.org/r2/databases/dud_ligands2006/$1_ligands.mol2.gz 2>> $1/getDUD_$1.log
        mv $1_ligands.mol2.gz $1/ligands

	gunzip $1/ligands/$1_ligands.mol2.gz 2>> $1/getDUD_$1.log
	babel -imol2 $1/ligands/$1_ligands.mol2 -osd $1/ligands/$1_ligands.sd 2>> $1/getDUD_$1.log
	#$SCHRODINGER/utilities/sdconvert -isd $1/ligands/$1_ligands.sd -omae $1/ligands/$1_ligands.maegz
	#sdreport $1/ligands/$1_ligands.sd | grep 'TITLE1 ' > sd.txt
	#perl -e 'open(IN,"sd.txt"); while(<IN>){ chomp; @line=split(" ",$_); $name=$line[2]; print substr($name,1,-1); print"\n"} close(IN);' > ligands.txt
	sdreport -t -nh $1/ligands/$1_ligands.sd | awk '{print $2}' > ligands.txt
	mv ligands.txt $1/ligands/
	#rm sd.txt

#TARGET files from mousumi DUD output
	#downloading ligand file
	wget http://dud.docking.org/r2/targets/$1/xtal-lig.mol2 2>> $1/getDUD_$1.log
	mv xtal-lig.mol2 $1/targets/
	echo -e '\nConverting ligand mol2 file (xtal-lig) to sd format (needed in rdock)\n'
	babel -imol2 $1/targets/xtal-lig.mol2 -osd $1/targets/xtal-lig.sd 2>> $1/getDUD_$1.log
	
	echo -e '\nMoving all targets files that are useless to a folder\n'
	mkdir $1/targets/useless
	mv $1/targets/* $1/targets/useless 2>> $1/getDUD_$1.log
	cp $1/targets/useless/final.pdb $1/targets/useless/xtal-lig.sd $1/targets
	
echo 'Done!'

##folder necessary for following steps
mkdir $1/DOCKING

echo 'The next step should be the checking of the receptor and ligand files.. good luck!'
echo -e '\tcd '$1'/targets; maestro final.pdb'
echo -e '\n\nWhen the receptor and the ligand are OK, please run "prepDocking" from DOCKING folder.\n\n'
