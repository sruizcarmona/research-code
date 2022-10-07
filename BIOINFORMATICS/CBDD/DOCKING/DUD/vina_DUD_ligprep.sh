#this script will generate DUD inputs for vina 
#has to be called from DOCKING folder
#flag for running the docking

#======================================
#========= AUTODOCK/VINA ==============
#======================================

dudsys=sys.argv[1]

#flags: (only one)
#prep for prepare all folders and input files
#marc for generating all q_files to run in marc
#dock for running in maria


	#make folders and copy needed files
	echo Working with $dudsys!
	echo Making folders and copying needed files....
	mkdir vina
	mkdir vina/results vina/results/logs vina/results/streams vina/ligs_sd vina/ligs_pdbqt 
	
	#split all ligands 1 by 1 and save them in ligs_sd
	echo -n Splitting ligands and saving them one by one in vina/ligs_sd folder...
	sdsplit -1 -ovina/ligs_sd/$dudsys\_lig ligprep/$dudsys\_ligprep.sd > vina/prep_docking.log
	nligs=`grep -c '$$$$' $dudsys\_all_ligands.sd `
	for f in vina/ligs_sd/$dudsys\_lig[0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$dudsys\_lig/$dudsys\_lig000/); done
	for f in vina/ligs_sd/$dudsys\_lig[0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$dudsys\_lig/$dudsys\_lig00/); done
	if [ $nligs -gt 99 ]; then 
		for f in vina/ligs_sd/$dudsys\_lig[0-9][0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$dudsys\_lig/$dudsys\_lig0/); done
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
	python $SCRIPTS/getcoords_VINA.py rdock/$dudsys\_rdock_cav1.grd $SCRIPTS/files/vina_conf.tmp vina/vina_conf.txt
	echo -e "\t\t\t\t\t\t\t\e[1;32mDone\e[0m"
	
	#convert receptor pdb to pdbqt
	echo -n Converting receptor from pdb to pdbqt format...
	/mds/sergi/MGLTools-1.5.6rc2/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_receptor4.py -r ../targets/final.pdb -o vina/$dudsys\_receptor.pdbqt >> vina/prep_docking.log
	echo -e "\t\t\t\t\e[1;32mDone\e[0m"

	#create Q inputs for marc with 8cpus
	echo -n Creating queue input files for running in the nodes...
	mkdir vina/q_files
	python $SCRIPTS/vina_Qin.py $dudsys vina/qsub_vina_tmp.sh
	echo -e "\t\t\t\e[1;32mDone\e[0m"
	
	echo Write this to start the docking:
	echo -e "\tscptomarc vina /xpeople/sruiz/DUD/$dudsys"
	echo -e "\tmarc \"cd /xpeople/sruiz/DUD/$dudsys/vina;sh start_vina.sh;\""
