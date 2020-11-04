##this script should be runned in folder DOCKING...
#it will make all the corresponding results processing for both rDock and glide..
#it should find a results folder in glide and rDock with file in it: DUD_all_results.maegz in case of glide and DUD_all_results.sd in case of rDock!

dudsys=$1

###GLIDE processing
	#change working directory
	
	cd glide/results/
	if [ ! -e $dudsys\_all_results.maegz -a ! -e $dudsys\_all_results.sd -a ! -e $dudsys\_all_results.sd.gz ]; 
	then 
		echo Check your files in the folder! You should have: $dudsys\_all_results.maegz in it!! ...finishing script...; 
		exit;
	else
		if [ ! -e $dudsys\_all_results.sd -a ! -e $dudsys\_all_results.sd.gz -a ! -e $dudsys\_glide_sorted.sd ];
		then
			echo Converting $dudsys\_all_results.maegz to SD format!
			$SCHRODINGER/utilities/sdconvert -imae $dudsys\_all_results.maegz -osd $dudsys\_all_results.sd
			echo Converted $dudsys\_all_results.maegz to SD format!
			#echo Eliminating first record as it is the receptor...
			#sdfilter -f'$_REC != 1' $dudsys\_all_results.sd > nofirst.sd
	                #mv nofirst.sd $dudsys\_all_results.sd
		else
			echo You already have all the results in SD format..skipping this step!
		fi;
	
	fi;

##Now you should have in the folder the results in SD format.. so what we have to do is to eliminate the first record (it is the receptor!)
# It will be be applied at the same time that it sorts all the results by name..it will get the best pose of each ligand and will again sort all the poses by score!
	if [ ! -e $dudsys\_glide_sorted.sd ]; 
	then 
 		echo Getting the best pose of all the ligands and sorting everything by docking score...
		echo This may take a long time, please be patient!!
	
###SDsort for all ligands is very memory consuming.. so this will create a provisional folder to store the provisional splitted files in order to speed it up

		nligs=`grep -c '$$$' $dudsys\_all_results.sd`
		if [ $nligs -gt 20000 ]
		then 
			mkdir provisional
			sdsplit -20000 -oprovisional/$dudsys\_split $dudsys\_all_results.sd &>> ../../$dudsys\_R_process.log
			
##now it will go to the folder and sort everyhing by title...then it will get the first pose of all the repeated ones..
			cd provisional
			for file in *
			do
				sdsort -f'_TITLE1' $file | sdsort -n -s -f'r_i_docking_score'| sdfilter -s'_TITLE1' -f'$_COUNT == 1' > $file'_sorted'
			done
##concatenate all _sorted files into one.. it should be 4 times smaller than the first one --> less problems with memory and repeat sorting and filtering!!
			cat *_sorted >> prov_split_sorted.sd
			sdsort -f'_TITLE1' prov_split_sorted.sd | sdsort -n -s -f'r_i_docking_score' | sdfilter -s'_TITLE1' -f'$_COUNT == 1' | sdsort -n -f'r_i_docking_score' > $dudsys\_glide_sorted.sd	

#finally.. we sort all the records by score
#sdsort -n -f'r_i_docking_score' ache_filteredbyTitle.sd > ache_all_filtsort.sd 
#the last step is to move the final sd file to the original folder and remove the partial results

			mv $dudsys\_glide_sorted.sd ..
			cd ..
			rm -r provisional/					
		else
			sdsort -f'_TITLE1' $dudsys\_all_results.sd | sdsort -n -s -f'r_i_docking_score' | sdfilter -s'_TITLE1' -f'$_COUNT == 1' | sdsort -n -f'r_i_docking_score' > $dudsys\_glide_sorted.sd
		fi;				
		
		#sdfilter -f'$_REC != 1' $dudsys\_all_results.sd | sdsort -f_TITLE1 | sdfilter -s'_TITLE1' -f'$_COUNT == 1' | sdsort -n -f'r_i_docking_score' > $dudsys\_glide_sorted.sd;
	else
		echo You already have all the results sorted..skipping this step!
	fi;

	echo Job done! Now it is turn of R..

####R scripts to be loaded here!
	Rscript ~/work/scripts/R/glide_process_results.R $dudsys &>> ../../$dudsys\_R_process.log 
	echo You can find the results in glide/results folder. There must be a jpg file with the enrichment plot!
	cd ../../

#==============================================================================================================================================0
###RDOCK!!

	echo -e '\n\nNow it will process rDock results\n'
	cd rdock/results/
	if [ ! -e $dudsys\_all_results.sd -a ! -e dataforR_uq.txt ];
	then 
		echo You must have a file called $dudsys\_all_results.sd in rdock folder to continue..;
		exit;
	fi;
	Rscript ~/work/scripts/R/rDock_process_results.R $dudsys &>> ../../$dudsys\_R_process.log 
	cd ../../

###########################################
## VINA
###########################################
	echo -e '\n\nNow it will process Vina results\n'
	cd vina/results/
	if [ ! -e $dudsys\_all_results.sd -a ! -e dataforR_uq.txt ];
	then
		echo Processing vina results '('converting from pdbqt to sd and adding field with score')'...
		if [ ! -e $dudsys\_lig00001_out.pdbqt ]; then echo You must have the vina output pdbqt files in vina/results!!; exit; fi;
		mkdir pdbqt sd_noscore
		mv *.pdbqt pdbqt/
		for file in pdbqt/*; do b=`basename $file .pdbqt`; babel -ipdbqt $file -osd $b.sd 2>> ../../$dudsys\_R_process.log; done; 
		mv *.sd sd_noscore/
		for file in sd_noscore/*; do b=`basename $file _out.sd`; $SCRIPTS/utils/vina_addscores.py $file $b\_score.sd; done;
		cat *score.sd >> $dudsys\_all_results.sd
		gzip *score.sd
		mkdir sd_scored
		mv *score.sd.gz sd_scored/
		gzip sd_noscore/*.sd
		echo Done!
	fi;
	echo File with all results called vina/results/$dudsys\_all_results.sd
	echo Proceeding with R analysis...
	Rscript ~/work/scripts/R/vina_process_results.R $dudsys &>> ../../$dudsys\_R_process.log
	
	cd ../../
#=========================================================
#=========================================================
###NEW FOLDERS USING OTHER PRM files or other parameters!!
#=========================================================
#=========================================================
#
#	if [ $# -ne 0 ];
#	then
##Ask user if folder is OK
#	if [ $1 != "rdock" ];
#	then
#		echo working in folder $dudsys/DOCKING/$1, is it ok?
#		select check in y n
#		do 		 
#			case $check in
#				'y' ) 
#					folder=$1
#					break
#					;;
#				'n' ) 
#					echo -n 'Please insert the name of the folder:'
#					read folder
#					break
#					;;
#				* )
#					echo Incorrect option, try again please...  
#					;;
#			esac
#		done
#
#		cd $folder/results/
##if results are glide outputs
##===============================================================================
##GLIDE TYPE FOLDER
#		if [ -e $dudsys\_*ligprep.maegz -o -e $dudsys\_*timeperf.maegz ];
#		then
###Same as in glide section
#			if [ ! -e $dudsys\_all_results.sd ];
#                	then
#                        	$SCHRODINGER/utilities/sdconvert -imae $dudsys\_*.maegz -osd $dudsys\_all_results.sd
#	                        echo Converted $dudsys glide results from maegz to SD format!
#	                        echo Eliminating first record as it is the receptor...
#	                        sdfilter -f'$_REC != 1' $dudsys\_all_results.sd > nofirst.sd
#	                        mv nofirst.sd $dudsys\_all_results.sd
#	                else
#        	                echo You already have all the results in SD format..skipping this step!
#	                fi;
#			if [ ! -e $dudsys\_glide_sorted.sd ];
#        		then
#		                echo Getting the best pose of all the ligands and sorting everything by docking score...
#		                echo This may take a long time, please be patient!!
#
#                		nligs=`grep -c '$$$' $dudsys\_all_results.sd`
#		                if [ $nligs -gt 20000 ]
#		                then
#                		        mkdir provisional
#		                        sdsplit -20000 -oprovisional/$dudsys\_split $dudsys\_all_results.sd 2>> ../../$dudsys\_R_process.log
#                        		cd provisional
#		                        for file in *
#		                        do
#                		                sdsort -f'_TITLE1' $file | sdfilter -s'_TITLE1' -f'$_COUNT == 1' > $file'_sorted'
#		                        done
#                        		cat *_sorted >> prov_split_sorted.sd
#		                        sdsort -f'_TITLE1' prov_split_sorted.sd | sdsort -n -s -f'r_i_docking_score' | sdfilter -s'_TITLE1' -f'$_COUNT == 1' | sdsort -n -f'r_i_docking_score' > $dudsys\_glide_sorted.sd
#                        		mv $dudsys\_glide_sorted.sd ..
#        	                	cd ..
#	        	                rm -r provisional/
#	                	else
#        	                	sdsort -f'_TITLE1' $dudsys\_all_results.sd | sdsort -n -s -f'r_i_docking_score' | sdfilter -s'_TITLE1' -f'$_COUNT == 1' | sdsort -n -f'r_i_docking_score' > $dudsys\_glide_sorted.sd
#                		fi;
#
#        		else
#                		echo You already have all the results sorted..skipping this step!
#        		fi;
#
#        		echo Job done! Now it is turn of R..
#			Rscript ~/work/scripts/R/glide_process_results.R 2>> ../../$dudsys\_R_process.log >> ../../$dudsys\_R_process.log
#		        echo You can find the results in $1/results folder. There must be a jpg file with the enrichment plot!
#		fi;
##=======================================================================================
## VINA
##=========================================================
##		if [ $folder == 'vina' ];
##		then
##			if [ ! -e $dudsys\_all_results.sd ];
##			then
##				echo Processing vina results '('converting from pdbqt to sd and adding field with score')'...
##				if [ ! -e $dudsys\_lig0001_out.pdbqt ]; then echo You must have the vina output pdbqt files in $folder/results!!; exit; fi;
##				mkdir pdbqt sd_noscore
##				mv *.pdbqt pdbqt/
##				for file in pdbqt/*; do b=`basename $file .pdbqt`; babel -ipdbqt $file -osd $b.sd 2>> ../../$dudsys\_R_process.log; done; 
##				mv *.sd sd_noscore/
##				for file in sd_noscore/*; do b=`basename $file _out.sd`; $SCRIPTS/utils/vina_addscores.py $file $b\_score.sd; done;
##				cat *score.sd >> $dudsys\_all_results.sd
##				gzip *score.sd
##				mkdir sd_scored
##				mv *score.sd.gz sd_scored/
##				gzip sd_noscore/*.sd
##				echo Done!
##			fi;
##			echo File with all results called $folder/results/$dudsys\_all_results.sd
##			echo Proceeding with R analysis...
##			Rscript ~/work/scripts/R/vina_process_results.R 2>> ../../$folder\_$dudsys\_R_process.log >> ../../$folder\_$dudsys\_R_process.log
##			
##		else 
##			if [ ! -e $dudsys\_all_results.sd ]; 
##			then 				
##				echo You must have a file called $dudsys\_all_results.sd in rdock $folder to continue..; 
##				echo Execute the following command to do so, and then re-run this script:
##				echo cat $folder/results/*.sd '>>' $folder/results/$dudsys\_all_results.sd
##				echo gzip $folder/results/*out.sd '&'
##				exit;
##			fi;
##		        Rscript ~/work/scripts/R/rDock_process_results.R 2>> ../../$folder\_$dudsys\_R_process.log >> ../../$folder\_$dudsys\_R_process.log
##		fi;
##		cd ../../
#	fi;
#	fi;
#
#============================================================
#add stats in latex
## COMPARISON PLOTS!!! and latex table with statistics
	#echo $folder
	Rscript ~/work/scripts/R/DUD_process_all.R $dudsys &>> $dudsys\_R_process.log 

