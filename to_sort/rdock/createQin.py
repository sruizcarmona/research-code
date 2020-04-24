import getopt,re,os,sys,string

def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "t:s:n:p:i:o:r:a:m:l:", ["template=","scoremat=","name=","pwy=","input=","output=","runs=","asfile=","mol2file=","lig="])
    except getopt.GetoptError, err:
        print str("%.5f" % err)
        sys.exit(2)

    for o,a in opts:
        if o in ("-t","--template"):
            tmp = a
        elif o in ("-n","--name"):
            name = a
        elif o in ("-p", "--pwy"):
            pwy= a
        elif o in ("-i", "--input"):
            inp = a
        elif o in ("-o", "--output"):
            output = a
        elif o in ("-r", "--runs"):
            runs = a
        elif o in ("-a", "--asfile"):
            asfile = a
        elif o in ("-m", "--mol2file"):
            mol2file = a
        elif o in ("-s", "--scoremat"):
            scoremat = a
        elif o in ("-l", "--lig"):
            lig = a
        else:
            assert False, "unhandled option"

    f = open(tmp, 'r')
    tmp_str = f.read()
    f.close()
    dir='/'.join(pwy.split("/")[:-1])
    ligname=pwy.split("/")[-1]

    queue_fname = "qsub_"+name.replace('.sd','.sh')
    d = {'IN':inp,'PWY_R':'split_ligands/'+ligname,'FILE':ligname,'OUT':ligname.replace('.sd','_out'),'SCMAT':scoremat,'NRUNS':runs, 'AS':asfile,'MOL2':mol2file,'LIG':lig,'NAME':'kname','QUEUE':'serial','OUT_STREAM':'kout', 'ERR_STREAM':'kerr','SCRATCHDIR':'$SCRATCHDIR','DIR':dir,'file':'$file','ST_LINE':'$','MPICH2_ROOT':'$MPICH2_ROOT','PATH':'$PATH','JOB_ID':'$JOB_ID','SGE_TASK_ID':'$SGE_TASK_ID', 'RBT_ROOT':'$RBT_ROOT', 'PATH':'$PATH'}
    q_out = string.Template(tmp_str).substitute(d)
    q = open(queue_fname, 'w')
    q.write(q_out)
    q.close()

if __name__== "__main__":
    main()
