##once target and ligand structures have been checked and saved as ready, this script
##makes the folders that will contain the files for rdock and glide docking
##this script has to be run from DOCKING folder!!

#CHECK arguments passed and do what user wants to do:
# - files for first part (merging all ligands and creating folders)
# - rdock for all rdock calculations including grid generation
# - glide for glide steps,
# - glidefix for fixed glide grid generation to avoid nodes SCHRODINGER errors
### BY DEFAULT, no arguments passed, it will do files, rdock and glide

dudsys=$1

#echo files $files rdock $rdock glide $glide glidefix $glidefix;


##########################
#  RDOCK 
##########################

#create subfolders for rdock and glide files
echo -e "Working in \e[46m$dudsys\e[0m folder"
echo Creating sub folders...
mkdir glide
mkdir glide/logs
mkdir glide/results
mkdir glide/results/logs
echo -e "\tglide"
mkdir rdock
echo -e "\trdock"
#create a file with all ligands (decoys and known actives)
#cat ../decoys/*decoys.sd > $dudsys\_all_ligands.sd
#cat ../ligands/*ligands.sd >> $dudsys\_all_ligands.sd
#echo "Created a file with all ligands to dock...\n\t"$dudsys"_all_ligands.sd"

##files for rdock and grid generation automatically done locally
cd rdock
cp /home/sergi/work/scripts/rdock/template.prm .
#convert maegz from maestro grid checkpoint to mol2 needed in rdock
#$SCHRODINGER/utilities/mol2convert -imae ../../targets/$dudsys.maegz -omol2 ../../targets/$dudsys.mol2
#copy ligand and target file to rdock folder
cp ../../targets/$dudsys.mol2 $dudsys\_rdock.mol2
cp ../../targets/xtal-lig.sd .

#run rbcavity -> grid generation for rdock (locally)
echo -e "Creating rDock grid..."
python /home/sergi/work/scripts/rdock/createRBDPRMfile_fixdud.py $dudsys
rbcavity -r $dudsys\_rdock.prm -was -d > cavity.log
cd ..
echo -e "\trDock grid generated! See results in rdock folder"

###########################
# GLIDE
###########################

#files for glide and grid input
echo -e "Creating grid inputs for glide..."
cp ../targets/$dudsys.maegz glide/$dudsys\_rec_grid.maegz
#get coordinates from rdock cavity and generate the input to glide with the same parameters	
python $SCRIPTS/rdock/getcoords.py rdock/$dudsys\_rdock_cav1.grd $dudsys
#make Q input for making the grid in MARC
#if need to correct in nodes correct for the error in NODES, 
python $SCRIPTS/createQin_glide.py -t $SCRIPTS/files/qsub_glide_template.sh -c 1 -i $dudsys\_grid.in -n qsub_$dudsys\_grid.sh -p /xpeople/sruiz/DUD/$dudsys/glide
#move all files generated to glide folder
mv $dudsys\_grid.in qsub_$dudsys\_grid.sh glide
#echo -e "\tfiles can be found in glide folder"
###########################
# VINA
###########################

#make folders and copy needed files
echo $dudsys with VINA
#echo Making folders and copying needed files....
mkdir vina
mkdir vina/results vina/results/logs vina/results/streams vina/ligs_sd vina/ligs_pdbqt
cp $SCRIPTS/files/vina_screen_local.sh vina

#split all ligands 1 by 1 and save them in ligs_sd
echo -n Splitting ligands and saving them one by one in vina/ligs_sd folder...
sdsplit -1 -ovina/ligs_sd/$dudsys\_lig $dudsys\_ligprep.sdf > vina/prep_docking.log
nligs=`grep -c '$$$$' $dudsys\_ligprep.sdf `

#fix numbers for be correctly sorted by name
for f in vina/ligs_sd/$dudsys\_lig[0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$dudsys\_lig/$dudsys\_lig0000/); done
for f in vina/ligs_sd/$dudsys\_lig[0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$dudsys\_lig/$dudsys\_lig000/); done
if [ $nligs -gt 99 ]; then
	for f in vina/ligs_sd/$dudsys\_lig[0-9][0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$dudsys\_lig/$dudsys\_lig00/); done
fi;
if [ $nligs -gt 999 ]; then
        for f in vina/ligs_sd/$dudsys\_lig[0-9][0-9][0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$dudsys\_lig/$dudsys\_lig0/); done
fi;
echo -e "\t\e[1;32mDone\e[0m"

#convert all ligands to pdbqt using babel
echo -n Converting all ligands to pdbqt...
for lig in vina/ligs_sd/*; do
        b=`basename $lig .sd`;
        babel -isd $lig -opdbqt vina/ligs_pdbqt/$b.pdbqt 2>> vina/babel_sdtopdbqt.log;
done;
echo -e "\t\t\t\t\t\e[1;32mDone\e[0m"

#create vina_input--> vina_conf.txt
echo -n Creating Vina input...
python $SCRIPTS/getcoords_VINA.py rdock/$dudsys\_rdock_cav1.grd $SCRIPTS/files/vina_conf.tmp vina/vina_conf.txt $dudsys
echo -e "\t\t\t\t\t\t\t\e[1;32mDone\e[0m"

#convert receptor pdb to pdbqt
echo -n Copying receptor from prepared before...
#/mds/sergi/MGLTools-1.5.6rc2/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_receptor4.py -r ../targets/$dudsys.mol2 -o vina/$dudsys\_receptor.pdbqt >> vina/prep_docking.log
cp old_ligprep/vina/$dudsys\_receptor.pdbqt vina
echo -e "\t\t\t\t\e[1;32mDone\e[0m"
##########################################

#send instructions to the user
echo -e "\n\nTHINGS TO DO NOW:\n"
echo -e "Please go to MARC and generate the grid in the nodes"
echo -e "\tscptomarc . /xpeople/sruiz/DUD/$dudsys\n\tmarc \"cd /xpeople/sruiz/DUD/$dudsys/glide/; qsub qsub_"$dudsys"_grid.sh\""
echo Check rDock grid is OK and similar to glide grid
echo -e "\tpymol rdock/"$dudsys"_rdock.mol2 rdock/xtal-lig.sd rdock/"$dudsys"_rdock_cav1.grd\n"

####
# RUNDOCK.sh
####

#CHECK arguments passed and do what user wants to do:
# - files for first part (merging all ligands and creating folders)
# - rdock for all rdock calculations including grid generation
# - glide for glide steps,
# - glidefix for fixed glide grid generation to avoid nodes SCHRODINGER errors
### BY DEFAULT, no arguments passed, it will do files, rdock and glide

##RDOCK###################################################
#makes folders for the results and the splitted ligands (if more than 200)
mkdir rdock/results
mkdir rdock/results/logs
mkdir rdock/split_ligands
#first of all, if the ligands are in a sdfile with more than 200 ligands, split it into different files
#otherwise, just make a copy of this sd file to the folder, for making easy following steps
#if [ $(grep -c '$$$$' $dudsys\_all_ligands.sd) -gt 200 ]
#for ligprep ligands
if [ $(grep -c '$$$$' $dudsys\_ligprep.sdf) -gt 200 ]
then 
	sdsplit -200 -ordock/split_ligands/$dudsys\_split $dudsys\_ligprep.sdf > runDock_$dudsys.log
#	echo The ligands have been splitted into 200 molecules sd files, they can be found in rdock/split_ligands 
else
	cp $dudsys\_ligprep.sdf rdock/split_ligands
fi

nfiles=`ls -1 rdock/split_ligands/$dudsys\_split*.sd | wc -l` 
#add 0s to files for sorting
for f in rdock/split_ligands/$dudsys\_split[0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$dudsys\_split/$dudsys\_split000/); done
if [ $nfiles -gt 9 ]; then
	for f in rdock/split_ligands/$dudsys\_split[0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$dudsys\_split/$dudsys\_split00/); done
fi;
if [ $nfiles -gt 99 ]; then
	for f in rdock/split_ligands/$dudsys\_split[0-9][0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$dudsys\_split/$dudsys\_split0/); done
fi;

#foreach file in rdock split_ligands.. run createQin and save it in rdock folder.
#cp $SCRIPTS/files/rdock_filter.txt rdock #copy filter txt to running folder
cd rdock/split_ligands/
#parameters:
#template.q in files, pathway to 
for file in *; 
	do
	python $SCRIPTS/rdock/createQin.py -t $SCRIPTS/files/qsub_rdock_template.sh -p /xpeople/sruiz/DUD/$dudsys/rdock/$file -i $dudsys\_rdock.prm -r 100 -a $dudsys\_rdock.as -m $dudsys\_rdock.mol2 -l xtal-lig.sd -s dock.prm -n $file;
	done
mv qsub_*.sh ../
cd ../../

cp $SCRIPTS/addtoQ.csh rdock
	
#echo Files for rdock can be found in its folder.
echo To run rDock in marc:
echo -e "\tscptomarc rdock /xpeople/sruiz/DUD/$dudsys\n\tmarc \"cd /xpeople/sruiz/DUD/$dudsys/rdock; ./addtoQ.csh\"\n"
##next step is copying to marc and running both glide and rdock in there

##GLIDE #########################################
##files needed for glide docking 
##Parameters:
# grid found in DUD folder in marc
# ligands also in DUD folder
# name stantardized for 'DUD'_glide_out.maegz
# 100 poses, NO cutoff of -4, and (nligands*nposes) best reported
		
#nligands is the number of ligands in the input file and nrep is the maximum of poses to write in the output
#nligands=`grep -c '$$$$' $dudsys\_all_ligands.sd`
#ligprep is performed to all starting ligands
#nligands=`grep -c '$$$$' $dudsys\_ligprep.sdf`
#nrep=`echo $nligands*5000 | bc`

mkdir glide/input_files

#for each ligandfile splitted for rdock, create a job for running with glide	
for ligfilename in rdock/split_ligands/*;
do	
	ligfile=`basename $ligfilename`	
	ligname=`basename $ligfilename .sd`
	#creates glide.in file to run docking
	python $SCRIPTS/createGlideIn.py -g /xpeople/sruiz/DUD/$dudsys/glide/results/$dudsys\_grid.zip -l /xpeople/sruiz/DUD/$dudsys/rdock/split_ligands/$ligfile -f glide/input_files/$ligname\_glide.in -e -p 5000 -n 1000000 -o
done;

#for each file created above, create a queue input file (one cpu each) steps of 5 cpus at the same time.	
for infile in glide/input_files/*.in;
do
	inlig=`basename $infile`
	lig_n=`basename $infile .in`
	#creates q input file to submit in marc (5 cpus)
	python $SCRIPTS/createQin_glide.py -t $SCRIPTS/files/qsub_glide_template.sh -c 1 -i $inlig -n glide/input_files/qsub_$lig_n.q -p /xpeople/sruiz/DUD/$dudsys/glide/input_files
done
#moves both files to glide folder

#sort of instructions to the user
echo "Files for running glide in marc named "$dudsys"_glide.in qsub_"$dudsys"_glide.sh (using 5CPUS), to run in marc:"
echo -e "\tscptomarc \"glide/"$dudsys"_glide.in glide/qsub_"$dudsys"_glide.sh\" /xpeople/sruiz/DUD/$dudsys/glide/\n\tmarc \"cd /xpeople/sruiz/DUD/$dudsys/glide/; qsub qsub_"$dudsys"_glide.sh\"\n"

######################################
# VINA
######################################
#create Q inputs for marc with 8cpus
#echo -n Creating queue input files for running VINA in the nodes...
mkdir vina/q_files
python $SCRIPTS/vina_Qin_DUD.py $dudsys $SCRIPTS/files/qsub_vina_serial_tmp.sh
#echo -e "\t\t\t\e[1;32mDone\e[0m"

echo For starting VINA docking in marc:
echo -e "\tscptomarc \"vina/q_files vina/start_vina.sh\" /xpeople/sruiz/DUD/$dudsys/vina"
echo -e "\tmarc \"cd /xpeople/sruiz/DUD/$dudsys/vina;sh start_vina.sh;\""
