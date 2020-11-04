#!/usr/bin/python
#this script will make GLIDE docking of ASTEX in an automatic way
#-----------------------
#author: Sergio Ruiz Carmona
#date: 21/02/2013
#-----------------------
#this script will have to be executed from main folder of each of the systems

import sys,os,shutil,subprocess

aptsys=sys.argv[1]
print '\nWorking on '+aptsys+' folder...\n====================================\n'
#===================================================================
# RDOCK
#===================================================================
#make rdock folder and needed files
os.mkdir('rdock')
os.mkdir('rdock/results')
os.mkdir('rdock/results/logs')
os.chdir('rdock')

#create Grid
print("\n=========== RDOCK ===========\n")
print("Creating rDock grid...")
o_cavity=os.system("rbcavity -r "+aptsys+"_rdock.prm -was -d > cavity.log")

#DOCK
print("Performing docking job...")
o_rdock=os.system("rbdock -i ligand.mol -o results/"+aptsys+"_out -r "+aptsys+"_rdock.prm -p dock.prm -n 1000 > results/logs/"+aptsys+"_rdock_out.log")

#sort results according to SCORE.INTER
print("DONE!\nSorting the results..")
o_sdsort=os.system("sdsort -n -f'SCORE.INTER' results/"+aptsys+"_out.sd > results/"+aptsys+"_out_sorted.sd")
print("Results sorted in rdock/results/"+aptsys+"_out_sorted.sd")
os.chdir("..")

#===================================================================
# GLIDE
#===================================================================
print ("Creating all folders and copying necessary files...")
#make glide folder and needed files
os.mkdir('glide')
os.mkdir('glide/results')
os.mkdir('glide/results/logs')
os.mkdir('glide/grid/')
os.chdir('glide')

shutil.copy('../'+aptsys+'_lig-min.sd','.')
shutil.copy('../'+aptsys+'_min.mol2','.')
#convert receptor to maegz format
mol2convert_com="$SCHRODINGER/utilities/mol2conver -imol2 "+aptsys+"_min.mol2 -omae "+aptsys+".maegz"
os.system(mol2convert_com)

print("Creating grid and glide inputs...")
##get coordinates from rdock cavity and generate the input to make the grid with the same parameters   
o_grid=os.system(os.environ['SCRIPTS']+"/rdock/getcoords_ASTEX.py ../rdock/"+aptsys+"_rdock_cav1.grd "+aptsys)
o_gridQ=os.system(os.environ['SCRIPTS']+"/createQin_glide.py -t "+os.environ['SCRIPTS']+"/files/qsub_glide_template.sh -c 1 -i "+aptsys+"_grid.in -n qsub_"+aptsys+"_grid.sh -p /xpeople/sruiz/APTAMERS_RNA/"+aptsys+"/glide/grid")
shutil.copy("qsub_"+aptsys+"_grid.sh","grid")
shutil.copy(aptsys+"_grid.in","grid")

#print instructions to user:
##SEND grid job to nodes
print("\n\nTHINGS TO DO NOW:\n")
print("Please go to MARC and generate the grid in the nodes")
print("\tscptomarc . /xpeople/sruiz/APTAMERS_RNA/"+aptsys+"\n\tmarc \"cd /xpeople/sruiz/APTAMERS_RNA/"+aptsys+"/glide/grid/; qsub qsub_"+aptsys+"_grid.sh\"")

#glide input and queue commands
o_glide=subprocess.Popen(os.environ['SCRIPTS']+"/createGlideIn_astex.py -g /xpeople/sruiz/APTAMERS_RNA/"+aptsys+"/glide/grid/"+aptsys+"_grid.zip -l /xpeople/sruiz/APTAMERS_RNA/"+aptsys+"/"+aptsys+"_ligand-min.sd -f "+aptsys+"_glide.in -e -p 5000 -n 10000 -c 10000",shell=True)
o_glideQ=subprocess.Popen(os.environ['SCRIPTS']+"/createQin_glide.py -t "+os.environ['SCRIPTS']+"/files/qsub_glide_template.sh -c 1 -i"+aptsys+"_glide.in -n qsub_"+aptsys+"_glide.sh -p /xpeople/sruiz/APTAMERS_RNA/"+aptsys+"/glide ",shell=True)

os.chdir('..')

#instructions for glide:
print("Files for running glide in marc named "+aptsys+"_glide.in and qsub_"+aptsys+"_glide.sh (using 1CPU), to run in marc:")
print("\tscptomarc \"glide/"+aptsys+"_glide.in glide/qsub_"+aptsys+"_glide.sh\" /xpeople/sruiz/APTAMERS_RNA/"+aptsys+"/glide/\n\tmarc \"cd /xpeople/sruiz/APTAMERS_RNA/"+aptsys+"/glide/; qsub qsub_"+aptsys+"_glide.sh\"\n")

os.chdir('..')

##===================================================================
## VINA
##===================================================================
#os.chdir('vina')
#os.system('babel -isd ../'+aptsys+'_ligand-min.sd -opdbqt '+aptsys+'_ligand-min_TEMP.pdbqt')
#os.system('/mds/sergi/MGLTools-1.5.6rc2/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l '+aptsys+'_ligand-min_TEMP.pdbqt -o '+aptsys+'_ligand-min.pdbqt')
#
##create vina_input--> vina_conf.txt
#os.system('python /home/sergi/work/scripts/getcoords_VINA.py ../rdock/'+aptsys+'_rdock_cav1.grd /home/sergi/work/scripts/files/vina_conf.tmp vina_conf.txt')
#
##DOCK
#print "VINA"
##run vina 50 times, in order to get a similar output to rDock and glide (1000 ligands)
##print "Performing docking job..."
##for i in range(1,51):
##	os.system('vina --config vina_conf.txt --ligand '+aptsys+'_ligand-min.pdbqt --out results/'+aptsys+'_out_'+"%02i"%(i)+'.pdbqt > results/logs/'+aptsys+'_log_'+"%02i"%(i)+'.txt')
#
#os.chdir('..')
#
##=====================================================================
## RDOCK
##=====================================================================
#os.chdir('rdock')
#
#print "RDOCK"
##print "Performing docking job..."
##rundock for 1000 ligands
##os.system("rbdock -i ../"+aptsys+"_ligand-min.sd -o results_1000/"+aptsys+"_out -r "+aptsys+"_rdock.prm -p dock.prm -n 1000 > results_1000/logs/"+aptsys+"_rdock_out.log")
##sort results according to SCORE.INTER
##print "DONE!\nSorting the results.."
##os.system("sdsort -n -f'SCORE.INTER' results_1000/"+aptsys+"_out.sd > results_1000/"+aptsys+"_out_sorted.sd")
##print "Results sorted in rdock/results_1000/"+aptsys+"_out_sorted.sd"
#
#os.chdir('..')
