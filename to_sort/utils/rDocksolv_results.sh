##this script should be runned in folder DOCKING...
#it will make all the corresponding results processing for both rDock and glide..
#it should find a results folder in glide and rDock with file in it: DUD_all_results.maegz in case of glide and DUD_all_results.sd in case of rDock!

###RDOCK!!

	echo -e '\n\nThis script will process rDock (using dock_solv prm file) results\n'

	 
	cd rdock_solv/results/
	if [ ! -e $(perl -e '@F=split(/\//,$ENV{PWD});print "$F[5]\n"')_all_results.sd ]; then echo You must have a file called $(perl -e '@F=split(/\//,$ENV{PWD});print "$F[5]\n"')_all_results.sd in rdock folder to continue..; exit; fi;
	Rscript ~/work/scripts/R/rDock_process_results.R 2>> ../../$(perl -e '@F=split(/\//,$ENV{PWD});print "$F[5]\n"')_R_process.log >> ../../$(perl -e '@F=split(/\//,$ENV{PWD});print "$F[5]\n"')_R_process.log


	cd ../../
## COMPARISON PLOTS!!! and latex table with statistics
	
	Rscript ~/work/scripts/R/DUD_process_all.R 2>> $(perl -e '@F=split(/\//,$ENV{PWD});print "$F[5]\n"')_R_process.log >> $(perl -e '@F=split(/\//,$ENV{PWD});print "$F[5]\n"')_R_process.log

