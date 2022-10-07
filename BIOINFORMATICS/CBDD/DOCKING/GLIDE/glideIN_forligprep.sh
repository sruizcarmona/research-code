#CHECK arguments passed and do what user wants to do:
# - files for first part (merging all ligands and creating folders)
# - rdock for all rdock calculations including grid generation
# - glide for glide steps,
# - glidefix for fixed glide grid generation to avoid nodes SCHRODINGER errors
### BY DEFAULT, no arguments passed, it will do files, rdock and glide
##GLIDE DOCKING##########################################
		##files needed for glide docking 
		##Parameters:
		# grid found in DUD folder in marc
		# ligands also in DUD folder
		# name stantardized for 'DUD'_glide_out.maegz
		# 100 poses, NO cutoff of -4, and (nligans*nposes) best reported
		
		#nligands is the number of ligands in the input file and nrep is the maximum of poses to write in the output
		nligands=`grep -c '$$$$' $(perl -e '@F=split(/\//,$ENV{PWD});print "$F[5]\n"')_all_ligands.sd`
		nrep=`echo $nligands*5000 | bc`
		
		#creates glide.in file to run docking
		python $SCRIPTS/createGlideIn.py -g /marc/data/sruiz/DUD/$(perl -e '@F=split(/\//,$ENV{PWD});print "$F[5]\n"')/glide/$(perl -e '@F=split(/\//,$ENV{PWD});print "$F[5]\n"')_grid.zip -l /marc/data/sruiz/DUD/$(perl -e '@F=split(/\//,$ENV{PWD});print "$F[5]\n"')/ligprep/$(perl -e '@F=split(/\//,$ENV{PWD});print "$F[5]\n"')_ligprep.maegz -f $(perl -e '@F=split(/\//,$ENV{PWD});print "$F[5]\n"')_glideligprep.in -e -p 5000 -n $nrep
		
	
		#moves both files to glide folder
		mv $(perl -e '@F=split(/\//,$ENV{PWD});print "$F[5]\n"')_glideligprep.in ligprep
	

