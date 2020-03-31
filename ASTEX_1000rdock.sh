#this script will make rDock and glide docking of ASTEX in an automatic way
#-----------------------
#author: Sergio Ruiz Carmona
#date: 01/02/2012
#-----------------------

#this script will have to be executed from main folder of each of the systems

astexsys=`basename $PWD`
echo Working on $astexsys folder...

#first of all, transform protein.mol2(found in all folders) to a readable file, e.g. with the name of the ASTEX system.
#babel -imol2 protein.mol2 -omol2 $astexsys.mol2 2> $astexsys\_babel.log

#===================================================================
# RDOCK
#===================================================================

#make rdock folder and needed files
mkdir  rdock/results_1000
mkdir rdock/results_1000/logs
#cp /home/sergi/work/scripts/rdock/template.prm /home/sergi/work/scripts/rdock/create_ASTEX_PRMfile.py rdock
cd rdock 
#cp ../ligand.mol .
#cp ../$astexsys.mol2 $astexsys\_rdock.mol2
#python create_ASTEX_PRMfile.py

#create Grid
echo -e "\n=========== RDOCK ===========\n"
#echo -e "Creating rDock grid..."
#rbcavity -r $astexsys\_rdock.prm -was -d > cavity.log

#DOCK
echo -e "Performing docking job..."
rbdock -i ligand.mol -o results_1000/$astexsys\_out -r $astexsys\_rdock.prm -p dock.prm -n 1000 > results_1000/logs/$astexsys\_rdock_out.log
#echo Send to marc for running docking!
#echo ---Create queue file!!!---

#sort results according to SCORE.INTER
echo -e "DONE!\nSorting the results.."
sdsort -n -f'SCORE.INTER' results_1000/$astexsys\_out.sd > results_1000/$astexsys\_out_sorted.sd 
echo -e "Results sorted in rdock/results/"$astexsys"_out_sorted.sd"
cd ..

#=====================================================================
# GLIDE
#=====================================================================
#
#echo -e "\n=========== GLIDE ===========\n"
##make glide folder and needed files
#mkdir -p glide/results/logs
#cp ligand.mol glide
#$SCHRODINGER/utilities/mol2convert -imol2 protein.mol2 -omae glide/protein.maegz
#echo -e "Creating grid inputs for glide..."
#
##get coordinates from rdock cavity and generate the input to glide with the same parameters   
#python $SCRIPTS/rdock/getcoords_ASTEX.py rdock/$astexsys\_rdock_cav1.grd
#python $SCRIPTS/createQin_glide.py -t $SCRIPTS/files/glide_template_fixed.q -c 1 -i $astexsys\_grid.in -n $astexsys\_grid.q
##move all files generated to glide folder
#mv $astexsys\_grid.in $astexsys\_grid.q glide
#echo -e "\tfiles can be found in glide folder"
#
#echo -e "\n\nTHINGS TO DO NOW:\n"
#echo -e "Please go to MARC and generate the grid in the nodes"
#echo -e "\tscptomarc . /data/sruiz/ASTEX/$astexsys\n\tmarc \"cd /data/sruiz/ASTEX/$astexsys/glide/; queue -a $astexsys\_grid.q\""
##once is finished... run glide DOCKING!!!
#
#python $SCRIPTS/createGlideIn.py -g /marc/data/sruiz/ASTEX/$astexsys/glide/$astexsys\_grid.zip -l /marc/data/sruiz/ASTEX/$astexsys/ligand.mol -f $astexsys\_glide.in -e -p 5000 -n 10000
#python $SCRIPTS/createQin_glide.py -t $SCRIPTS/files/glide_template_fixed.q -c 5 -i $astexsys\_glide.in -n $astexsys\_glide.q
#mv $astexsys\_glide.in $astexsys\_glide.q glide
#echo "Files for running glide in marc named $astexsys\_glide.in $astexsys\_glide.q (using 5CPUS), to run in marc:"
#echo -e "\tscptomarc \"glide/$astexsys\_glide.in glide/$astexsys\_glide.q\" /data/sruiz/ASTEX/$astexsys/glide/\n\tmarc \"cd /data/sruiz/ASTEX/$astexsys/glide/; queue -a $astexsys\_glide.q -c 5\"\n"
#
#
##=====================================================================
