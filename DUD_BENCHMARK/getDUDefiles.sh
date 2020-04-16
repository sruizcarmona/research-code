echo 'Working on DUDe files for' $1

#DECOYS files from teckel
	mkdir $1/decoys
	echo -e '\nDecoys...'
	mv $1/decoys*.* $1/decoys
	
	gunzip $1/decoys/decoys_final.sdf.gz 
	mv $1/decoys/decoys_final.sdf $1/decoys/$1_decoys.sd

	#last two lines can be done with the following one
	#this is to make results analysis using R scripts
	sdreport -t -nh $1/decoys/$1_decoys.sd | awk '{print $2}' > $1/decoys/ligands.txt

	echo -e 'Decoys files can be found in folder '$1'/decoys\n'

#LIGANDS files from teckel
#same as before but with ligands
	mkdir $1/ligands
	echo -e 'Ligands...'
        mv $1/actives* $1/ligands

	gunzip $1/ligands/actives_final.sdf.gz
	mv $1/ligands/actives_final.sdf $1/ligands/$1_ligands.sd

	sdreport -t -nh $1/ligands/$1_ligands.sd | awk '{print $2}' > $1/ligands/ligands.txt

#TARGET files from mousumi DUD output
	#downloading ligand file
	mkdir $1/targets
	mv $1/receptor.pdb $1/targets
	mv $1/crystal_ligand.mol2 $1/targets/xtal-lig.mol2 
	echo -e 'Converting ligand mol2 file (xtal-lig) to sd format (needed in rdock)\n'
	babel -imol2 $1/targets/xtal-lig.mol2 -osd $1/targets/xtal-lig.sd 2>> $1/getDUD_$1.log
	
echo -e 'Done!\n'

##folder necessary for following steps
mkdir $1/DOCKING

echo 'The next step should be the checking of the receptor and ligand files.. good luck!'
echo -e '\tcd '$1'/targets; maestro receptor.pdb'
echo -e '\nWhen the receptor and the ligand are OK, please run "prepDocking" from DOCKING folder.\n'
