#!/usr/bin/python

import getopt,re,os,sys,string

def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "t:n:c:i:p:x:", ["template=","name=","cpus=","input=","pathDIR=","next="])
    except getopt.GetoptError, err:
        print str("%.5f" % err) 
        sys.exit(2)

    pathDIR='default'
    nextparam='default'

    for o,a in opts:
        if o in ("-t","--template"):
            tmp = a
        elif o in ("-n","--name"):
            name = a
        elif o in ("-c", "--cpus"):
            cpus = a
        elif o in ("-i", "--input"):
            inp = a
        elif o in ("-p", "--pathDIR"):
            pathDIR = a
        elif o in ("-x", "--next"):
            nextparam = a
        else:
            assert False, "unhandled option"
    f = open(tmp, 'r')
    tmp_str = f.read()
    f.close()
    dudsys=inp.split('_')[0]

    #avoid errors when "input_files" is not in job.. for example in grid generation
    if pathDIR.find("input_files") != -1:
	    outdir=pathDIR.replace('input_files','results')
    else:
	outdir=pathDIR+"/results"
    
    ##check if split is in jobfile to avoid errors (glide jobs use this script and only have 1 file)
    if inp.find("split") != -1:
	if inp.count('_') == 3:
		nlig=int(inp.split('_')[2].split('split')[1])
	else:
		nlig=int(inp.split('_')[1].split('split')[1])
    else:
	nlig=0
		
    nextlig=nlig+5

    if nextlig < 10:
	strnextlig="000"+str(nextlig)
    elif nextlig < 100:
	strnextlig="00"+str(nextlig)
    elif nextlig < 1000:
	strnextlig="0"+str(nextlig)
    else:
	strnextlig=str(nextlig)

    #avoid creating next files for grid jobs
    if nlig==0:
	next="#NO NEXT JOB"
    else:
	next="qsub /xpeople/sruiz/DUD/"+dudsys+"/glide/input_files/qsub_"+dudsys+"_split"+strnextlig+"_glide.q"

    #if nextparam is defined
    if nextparam != "default":
	next=nextparam

    d = {'outDIR':outdir, 'NJOBS':cpus,'IN':inp,'SCHRODINGER':'$SCHRODINGER','file':'$file','SCRATCHDIR':'$SCRATCHDIR', 'NEXT':next,'DIR':pathDIR,'ST_LINE':'$','MPICH2_ROOT':'$MPICH2_ROOT','PATH':'$PATH','JOB_ID':'$JOB_ID','SGE_TASK_ID':'$SGE_TASK_ID'}
    q_out = string.Template(tmp_str).substitute(d)
    q = open(name, 'w')
    q.write(q_out)
    q.close()

if __name__== "__main__":
    main()
