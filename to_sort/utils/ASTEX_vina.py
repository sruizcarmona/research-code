#!/usr/bin/python
#this script will make vina docking of ASTEX in an automatic way
#-----------------------
#author: Sergio Ruiz Carmona
#date: 15/03/2012
#-----------------------
#this script will have to be executed from main folder of each of the systems



import sys,os,shutil

astexsys=sys.argv[1]
print 'Working on '+astexsys+' folder...'

#===================================================================
# VINA
#===================================================================

#make vina folder and needed files
os.mkdir('vina')
os.mkdir('vina/results')
os.mkdir('vina/results/logs')
os.chdir('vina')
os.system('/mds/sergi/MGLTools-1.5.6rc2/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_receptor4.py -r ../protein.mol2 -o '+astexsys+'_receptor.pdbqt')
shutil.copy('../ligand.mol','.')
shutil.copy('/home/sergi/work/scripts/files/vina_screen_local.sh','.')
os.system('babel -isd ligand.mol -opdbqt ligand.pdbqt')

#create vina_input--> vina_conf.txt
os.system('python /home/sergi/work/scripts/getcoords_VINA.py ../rdock/'+astexsys+'_rdock_cav1.grd /home/sergi/work/scripts/files/vina_conf.tmp vina_conf.txt'+astexsys)

#DOCK
print "Performing docking job..."
os.system('vina --config vina_conf.txt --ligand ligand.pdbqt --out results/out.pdbqt > results/logs/log.txt')
#echo Send to marc for running docking!
#echo ---Create queue file!!!---

#sort results according to SCORE.INTER

#=====================================================================
