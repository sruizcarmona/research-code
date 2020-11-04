##RDOCK###################################################
#create new folder for rdock docking
dudsys=$(perl -e '@F=split(/\//,$ENV{PWD});print "$F[5]\n"')
	#makes folders for the results and the splitted ligands (if more than 200)
	mkdir rdock_solv
	mkdir rdock_solv/results
	mkdir rdock_solv/split_ligands
	#first of all, if the ligands are in a sdfile with more than 200 ligands, split it into different files
	#otherwise, just make a copy of this sd file to the folder, for making easy following steps
	
	#foreach file in rdock split_ligands.. run createQin and save it in rdock folder.
	cp $SCRIPTS/files/rdock_filter.txt rdock_solv #copy filter txt to running folder
	cp rdock/*_rdock.* rdock/xtal-lig.sd rdock_solv
	cp rdock/split_ligands/* rdock_solv/split_ligands
	cd rdock_solv/split_ligands/
	#parameters:
	#template.q in files, pathway to 
	for file in *; 
		do
		python $SCRIPTS/rdock/createQin.py -t $SCRIPTS/files/rdock_tmp_DUD.q -p $file -i $dudsys\_rdock.prm -r 100 -a $dudsys\_rdock.as -m $dudsys\_rdock.mol2 -l xtal-lig.sd -s dock_solv.prm -n $file;
		done
	mv *.q ../
	cd ../../

	cp $SCRIPTS/addtoQ.csh rdock_solv

	echo Files for rdock can be found in its folder.
	echo To run it in marc:
	echo -e "\tscptomarc rdock_solv /data/sruiz/DUD/$dudsys\n\tmarc \"cd /data/sruiz/DUD/$dudsys/rdock_solv; ./addtoQ.csh\"\n"
	##next step is copying to marc and running both glide and rdock in there

