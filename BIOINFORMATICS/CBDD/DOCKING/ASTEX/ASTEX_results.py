#!/usr/bin/python
#this script will make rDock, glide and vina results analysis of ASTEX in an automatic way
#-----------------------
#author: Sergio Ruiz Carmona
#date: 13/03/2012
#-----------------------

#this script will have to be executed from main folder of each of the systems
import sys,os,pybel,random
astexsys=sys.argv[1]

#======================
# FUNCTIONS
#======================
import rpy2
from rpy2 import robjects

def create_R_hist(selected,astexsys):
	R=rpy2.robjects
	results=[]
	for a in selected:
		results.append(float(a[0][2]))
	R.r.assign('R_res',results)
	R.r('R_cols=c(258,515,362,404,555)')
	if max(results) > 10:
	        R.r('R_breaks=c(0,2,4,6,8,max(as.numeric(R_res)))')
	else:
	        R.r('R_breaks=c(0,2,4,6,8,10)')
	R.r('pdf("'+astexsys+'_rmsd_hist.pdf")')
	R.r('hist(as.numeric(R_res),breaks=R_breaks,col=colors()[R_cols],main="",xlab="RMSD (A)",freq=TRUE,ylim=c(0,100))')
	R.r['dev.off']()

#read output and create a list with each one of the ligands
def get_ligsinfo(astexsys):
	ligsout=pybel.readfile('sdf',astexsys+'_out_sorted.sd')
	ligs =[]
	for a in ligsout:
	  ligs.append(a)
	return ligs

#call pybel_rmsd script and print out rmsd in a file, then read and save it
def get_rms_data(astexsys,ligname):
	os.system('/home/sergi/work/scripts/utils/pybel_rmsd.py '+ligname+' '+astexsys+'_out_sorted.sd > '+astexsys+'_out_rmsd.txt')
	rmsf=open(astexsys+'_out_rmsd.txt','r')
	rms=rmsf.readlines()
	rmsf.close()
	return rms

#create 100 sets of 50 ids stored in groups into randset variable
def create_random_ids(ngroup,maxligs):
	randset=[]
	for n in range(0,100):
	  subR=[]
	  for k in range(0,ngroup):
	    subR.append(random.randrange(0,maxligs))
	  randset.append(subR)
	return randset

#create list with id, score and rmsd for each ligand
def get_scores_and_rmsd(sdfield,ligsfile,rms):
	d=[]
	for i,lig in enumerate(ligsfile):
	  rmsd=rms[i].rstrip().split()[-1]
	  d.append([i+1,lig.data[sdfield],rmsd])
	return d

#search random ids from randset and get data
def sort_selected_ligs(randset,ligdata):
	sel=[]
	for subr in randset:
	  subsel=[]
	  for ind in subr:
	    subsel.append(ligdata[ind])
	    subsel.sort()
	  sel.append(subsel)
	return sel

#get first molecule in each group and print each rmsd into a file
def get_rmsd_and_print(selected,astexsys):
	out=open(astexsys+'_hist_data.txt','w')
	for a in selected:
	  out.write(str(float(a[0][2])))
	  out.write('\n')
	out.close()

#=====================================================================
print "\nWorking on "+astexsys+" folder...\n"

#===================================================================
# RDOCK
#===================================================================

#sort results according to SCORE.INTER
#print "\n==========RDOCK============="
#print "Sorting the results.."
#os.chdir("rdock/results_1000")
#os.system("sdsort -n -f'SCORE.INTER' "+astexsys+"_out.sd > "+astexsys+"_out_sorted.sd") 
#print "Results sorted in rdock/results_1000/"+astexsys+"_out_sorted.sd"

#rdockligs=get_ligsinfo(astexsys)
#rdockrms=get_rms_data(astexsys,"../ligand.mol")
#rdockrandset=create_random_ids(50,len(rdockligs)-1)
#rdockligdata=get_scores_and_rmsd("SCORE.INTER",rdockligs,rdockrms)
#rdockselected=sort_selected_ligs(rdockrandset,rdockligdata)
#get_rmsd_and_print(rdockselected,astexsys)
#create_R_hist(rdockselected,astexsys)

#print "DONE!\n"
#os.chdir("../..")

# GLIDE
#=====================================================================
#
print "==========GLIDE============="
os.chdir("glide/results")
os.system("$SCHRODINGER/utilities/sdconvert -imae "+astexsys+"_glide_lib.maegz -osd "+astexsys+"_out_sorted.sd")

glideligs=get_ligsinfo(astexsys)
gliderms=get_rms_data(astexsys,"../ligand.mol")
gliderandset=create_random_ids(len(glideligs)/10+1,len(glideligs)-1)
glideligdata=get_scores_and_rmsd("r_i_docking_score",glideligs,gliderms)
glideselected=sort_selected_ligs(gliderandset,glideligdata)
get_rmsd_and_print(glideselected,astexsys)
create_R_hist(glideselected,astexsys)

#print "DONE!\n"
#os.chdir("../..")
###=====================================================================
## VINA 
##=====================================================================
##
#print "==========VINA=============="
#os.chdir("vina/results/")
##take all the results and combine them in 1 file
#os.system("cat *[0-9].pdbqt > "+astexsys+"_out_all.pdbqt")
#os.system("babel -ipdbqt "+astexsys+"_out_all.pdbqt -osd "+astexsys+"_out_all.sd")
#os.system("vina_addscores.py "+astexsys+"_out_all.sd "+astexsys+"_out_scores.sd")
#os.system("sdsort -n -f'VINA_SCORE' "+astexsys+"_out_scores.sd > "+astexsys+"_out_sorted.sd")
#
#vinaligs=get_ligsinfo(astexsys)
#vinarms=get_rms_data(astexsys,"ligand_OK.mol")
#vinarandset=create_random_ids(50,len(vinaligs)-1)
#vinaligdata=get_scores_and_rmsd("VINA_SCORE",vinaligs,vinarms)
#vinaselected=sort_selected_ligs(vinarandset,vinaligdata)
#get_rmsd_and_print(vinaselected,astexsys)
#create_R_hist(vinaselected,astexsys)
#
#print "DONE!\n\n"
#os.chdir("../..")
###=====================================================================
