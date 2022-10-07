##once target and ligand structures have been checked and saved as ready, this script
##makes the folders that will contain the files for rdock and glide docking
##this script has to be run from DOCKING folder!!

#CHECK arguments passed and do what user wants to do:
# - files for first part (merging all ligands and creating folders)
# - rdock for all rdock calculations including grid generation
# - glide for glide steps,
# - glidefix for fixed glide grid generation to avoid nodes SCHRODINGER errors
### BY DEFAULT, no arguments passed, it will do files, rdock and glide
if [ $# -eq 0 ];
then 
	#default parameters
	files=true
	rdock=true
	glide=true
	glidefix=false
else
	#if there are some arguments, all the parameters will be false but the ones the user adds
	files=false
	rdock=false
	glide=false
	glidefix=false

	#now check which one of them user wants to do
	for  a in $* 
	do
		if [ $a == files ]; 
		then
			files=true
		elif [ $a == rdock ]; 
		then
			rdock=true
		elif [ $a == glide ]; 
		then
			glide=true
		elif [ $a == glidefix ]; 
		then
			glidefix=true
		else
			echo UNKNOWN OPTIONS, please use files, rdock, glide or glidefix!
			exit 1;
		fi;
	done;	
fi;

dudsys=$(perl -e '@F=split(/\//,$ENV{PWD});print "$F[5]\n"')

echo files $files rdock $rdock glide $glide glidefix $glidefix;

#create subfolders for rdock and glide files
	if $files; then
		echo -e "Working in \e[46m$dudsys\e[0m folder"
		echo Creating sub folders...
		mkdir glide
		mkdir glide/results
		mkdir glide/results/logs
		echo -e "\tglide"
		mkdir rdock
		echo -e "\trdock"
		#create a file with all ligands (decoys and known actives)
		cat ../decoys/*decoys.sd > $dudsys\_all_ligands.sd
		cat ../ligands/*ligands.sd >> $dudsys\_all_ligands.sd
		echo -e "Created a file with all ligands to dock...\n\t$dudsys\_all_ligands.sd"
	fi;

##files for rdock and grid generation automatically done locally
	if $rdock; then
		cd rdock
		cp /home/sergi/work/scripts/rdock/template.prm /home/sergi/work/scripts/rdock/createRBDPRMfile.py .
		#convert maegz from maestro grid checkpoint to mol2 needed in rdock
		$SCHRODINGER/utilities/mol2convert -imae ../../targets/$dudsys.maegz -omol2 ../../targets/$dudsys.mol2
		#copy ligand and target file to rdock folder
		cp ../../targets/$dudsys.mol2 $dudsys\_rdock.mol2
		cp ../../targets/xtal-lig.sd .
		
		#run rbcavity -> grid generation for rdock (locally)
		echo -e "Creating rDock grid..."
		python createRBDPRMfile.py
		rbcavity -r $dudsys\_rdock.prm -was -d > cavity.log
		cd ..
		echo -e "\trDock grid generated! See results in rdock folder"
	fi;

#files for glide and grid input
	if $glide; then
		echo -e "Creating grid inputs for glide..."
		cp ../targets/$dudsys.maegz glide/$dudsys\_rec_grid.maegz
		#get coordinates from rdock cavity and generate the input to glide with the same parameters	
		python $SCRIPTS/rdock/getcoords.py rdock/$dudsys\_rdock_cav1.grd
		#make Q input for making the grid in MARC
		#if need to correct in nodes correct for the error in NODES, 
		python $SCRIPTS/createQin_glide.py -t $SCRIPTS/files/glide_template.q -c 1 -i $dudsys\_grid.in -n $dudsys\_grid.q
		#move all files generated to glide folder
		mv $dudsys\_grid.in $dudsys\_grid.q glide
		echo -e "\tfiles can be found in glide folder"
	fi;
#do grid files 
	if $glidefix; then 
		python $SCRIPTS/createQin_glide.py -t $SCRIPTS/files/glide_template_fixed.q -c 1 -i $dudsys\_grid.in -n $dudsys\_grid.q
		mv $dudsys\_grid.q glide
                echo -e "\tfiles can be found in glide folder"

	fi;

#send instructions to the user
	echo -e "\n\nTHINGS TO DO NOW:\n"
	echo -e "Please go to MARC and generate the grid in the nodes"
	echo -e "\tscptomarc . /data/sruiz/DUD/$dudsys\n\tmarc \"cd /data/sruiz/DUD/$dudsys/glide/; queue -a $dudsys\_grid.q\""
	echo Check rDock grid is OK and similar to glide grid
	echo -e "\tpymol rdock/$dudsys\_rdock.mol2 rdock/xtal-lig.sd rdock/$dudsys\_rdock_cav1.grd"
	echo -e "\nOnce finished, run runDock.sh script!\n"

