#!/usr/bin/python

import pybel, sys,random,subprocess,numpy,os

files=sys.argv[1]
#files="2bsm_sorted_split"

sdrmsd="/home/sergi/work/dev/rdock/rdock_svn/bin/sdrmsd"

def create_random_ids(ngroup,maxligs):
        randset=[]
        for n in range(0,50):
          subR=[]
          for k in range(0,ngroup):
            subR.append(random.randrange(1,maxligs+1))
          randset.append(subR)
        return randset

def run_all_process(nposes):
	randomidslist=create_random_ids(nposes,1000)

	numclus=[]
	for randomids in randomidslist:
		randomids.sort()
		randomids=map(str,randomids)
		filelist=[]
		for randomid in randomids:
			filelist.append(files+randomid+".sd")
		output = pybel.Outputfile("sdf","kk.sd" ,overwrite=True)
		for file in filelist:
			readmol=pybel.readfile("sdf",file)
			output.write(readmol.next())
		output.close()
		runsd=subprocess.Popen(sdrmsd+" -t 1 ../../ligand.mol kk.sd",shell=True,stderr=subprocess.PIPE,stdout=subprocess.PIPE)
		numclus.append(len(runsd.stdout.readlines()))	
	numclus=numpy.array(numclus)
	print "Results for "+str(nposes)+" number of poses"
	print "Average clusters is: ", numclus.mean()
	print "Std deviation is: ",numclus.std()
	print ""
	os.system("rm kk.sd")


run_all_process(100) #exhaustive mode
run_all_process(50) #default mode
run_all_process(20) #htvs modes
run_all_process(10) 

