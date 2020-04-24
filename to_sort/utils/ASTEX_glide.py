#!/usr/bin/python
# 

#this script will make GLIDE docking of ASTEX in an automatic way
#-----------------------
#author: Sergio Ruiz Carmona
#date: 29/08/2012
#-----------------------
#this script will have to be executed from main folder of each of the systems

import sys,os,shutil,subprocess

astexsys=sys.argv[1]
print '\nWorking on '+astexsys+' folder...\n====================================\n'

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

#copy all needed files from source folder
shutil.copy('../ligand.mol','.')
shutil.copy('../protein.mol2',astexsys+".mol2")

print("Converting protein to glide format and run preparation wizard...")
#convert mol2 protein to maestro format and remove dummy atoms using maestro script
maestro_script="""entryimport  format=mol2
entryimport \""""+astexsys+""".mol2\"
delete (atom.mtype Du)
entryexport  format=maegz
entryexport \""""+astexsys+"""_forPrepWiz.maegz\"
quit
quit  confirm=false
prefer  savescratchproject=false"""

mae_file=open("removeDU.maestro","w")
mae_file.write(maestro_script)
mae_file.close()

mae_run=os.system("$SCHRODINGER/maestro -nosplash -c removeDU.maestro 2> /dev/null")

#run prepwizard as follows:
#prepwizard -noepik -noprotassign -noimpref <INPUT>.maegz <OUTPUT>.maegz -WAIT
prepw_command="$SCHRODINGER/utilities/prepwizard -noepik -noprotassign -noimpref "+astexsys+"_forPrepWiz.maegz "+astexsys+".maegz -NOJOBID -WAIT >& /dev/null"
os.system(prepw_command)

print("Creating grid and glide inputs...")
##get coordinates from rdock cavity and generate the input to make the grid with the same parameters   
o_grid=os.system(os.environ['SCRIPTS']+"/rdock/getcoords_ASTEX.py ../rdock/"+astexsys+"_rdock_cav1.grd "+astexsys)
o_gridQ=os.system(os.environ['SCRIPTS']+"/createQin_glide.py -t "+os.environ['SCRIPTS']+"/files/qsub_glide_template.sh -c 1 -i "+astexsys+"_grid.in -n qsub_"+astexsys+"_grid.sh -p /xpeople/sruiz/APTAMERS_RNA/"+astexsys+"/glide/grid")
shutil.copy("qsub_"+astexsys+"_grid.sh","grid")
shutil.copy(astexsys+"_grid.in","grid")

#print instructions to user:
##SEND grid job to nodes
print("\n\nTHINGS TO DO NOW:\n")
print("Please go to MARC and generate the grid in the nodes")
print("\tscptomarc . /xpeople/sruiz/APTAMERS_RNA/"+astexsys+"\n\tmarc \"cd /xpeople/sruiz/APTAMERS_RNA/"+astexsys+"/glide/grid/; qsub qsub_"+astexsys+"_grid.sh\"")

#########
#DOCKING##
##########

#glide input and queue commands
o_glide=subprocess.Popen(os.environ['SCRIPTS']+"/createGlideIn_astex.py -g /xpeople/sruiz/APTAMERS_RNA/"+astexsys+"/glide/grid/"+astexsys+"_grid.zip -l /xpeople/sruiz/APTAMERS_RNA/"+astexsys+"/ligand.mol -f "+astexsys+"_glide.in -e -p 5000 -n 10000",shell=True)
o_glideQ=subprocess.Popen(os.environ['SCRIPTS']+"/createQin_glide.py -t "+os.environ['SCRIPTS']+"/files/qsub_glide_template_MPI.sh -c 5 -i"+astexsys+"_glide.in -n qsub_"+astexsys+"_glide.sh -p /xpeople/sruiz/APTAMERS_RNA/"+astexsys+"/glide",shell=True)

os.chdir('..')

#instructions for glide:
print("Files for running glide in marc named "+astexsys+"_glide.in and qsub_"+astexsys+"_glide.sh (using 5CPUS), to run in marc:")
print("\tscptomarc \"glide/"+astexsys+"_glide.in glide/qsub_"+astexsys+"_glide.sh\" /xpeople/sruiz/APTAMERS_RNA/"+astexsys+"/glide/\n\tmarc \"cd /xpeople/sruiz/APTAMERS_RNA/"+astexsys+"/glide/; qsub qsub_"+astexsys+"_glide.sh\"\n")




