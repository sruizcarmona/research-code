#!/usr/bin/python
#this script will make GLIDE docking of ASTEX in an automatic way
#-----------------------
#author: Sergio Ruiz Carmona
#date: 21/02/2013
#-----------------------
#this script will have to be executed from main folder of each of the systems

import sys,os,shutil,subprocess

astexsys=sys.argv[1]
print '\nWorking on '+astexsys+' folder...\n====================================\n'
os.system('babel -imol ligand.mol -osd '+astexsys+'_ligand.sd')
#===================================================================
# GLIDE
#===================================================================
os.chdir('glide')
#glide input and queue commands
#create 10 glide jobs, in order to get an output similar to rDock (1000 ligands)
for i in range(1,11):
	o_glide=subprocess.Popen(os.environ['SCRIPTS']+"/createGlideIn_astex.py -g /xpeople/sruiz/ASTEX/"+astexsys+"/glide/grid/"+astexsys+"_grid.zip -l /xpeople/sruiz/ASTEX/"+astexsys+"/"+astexsys+"_ligand.sd -f "+astexsys+"_glide.in -e -p 5001 -n 10000",shell=True)
	o_glideQ=subprocess.Popen(os.environ['SCRIPTS']+"/createQin_glide.py -t "+os.environ['SCRIPTS']+"/files/qsub_glide_template.sh -c 1 -i"+astexsys+"_glide.in -n qsub_"+astexsys+"_glide.sh -p /xpeople/sruiz/ASTEX/"+astexsys+"/glide",shell=True)

os.chdir('..')

#instructions for glide:
print("Files for running glide in marc in "+astexsys+"/glide folder.")

#===================================================================
# VINA
#===================================================================
os.chdir('vina')
os.system('babel -isd ../'+astexsys+'_ligand.sd -opdbqt '+astexsys+'_ligand_TEMP.pdbqt')
os.system('/mds/sergi/MGLTools-1.5.6rc2/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l '+astexsys+'_ligand_TEMP.pdbqt -o '+astexsys+'_ligand.pdbqt')

#create vina_input--> vina_conf.txt
os.system('python /home/sergi/work/scripts/getcoords_VINA.py ../rdock/'+astexsys+'_rdock_cav1.grd /home/sergi/work/scripts/files/vina_conf.tmp vina_conf.txt')

#DOCK
print "VINA"
#run vina 50 times, in order to get a similar output to rDock and glide (1000 ligands)
#print "Performing docking job..."
#for i in range(1,51):
#	os.system('vina --config vina_conf.txt --ligand '+astexsys+'_ligand.pdbqt --out results/'+astexsys+'_out_'+"%02i"%(i)+'.pdbqt > results/logs/'+astexsys+'_log_'+"%02i"%(i)+'.txt')

os.chdir('..')

#=====================================================================
# RDOCK
#=====================================================================
os.chdir('rdock')

print "RDOCK"
#print "Performing docking job..."
#rundock for 1000 ligands
#os.system("rbdock -i ../"+astexsys+"_ligand.sd -o results_1000/"+astexsys+"_out -r "+astexsys+"_rdock.prm -p dock.prm -n 1000 > results_1000/logs/"+astexsys+"_rdock_out.log")
#sort results according to SCORE.INTER
#print "DONE!\nSorting the results.."
#os.system("sdsort -n -f'SCORE.INTER' results_1000/"+astexsys+"_out.sd > results_1000/"+astexsys+"_out_sorted.sd")
#print "Results sorted in rdock/results_1000/"+astexsys+"_out_sorted.sd"

os.chdir('..')
