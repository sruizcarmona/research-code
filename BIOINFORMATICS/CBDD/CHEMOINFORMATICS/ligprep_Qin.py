import getopt,re,os,sys,string

def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "t:n:c:i:j:", ["template=","name=","cpus=","input=","job="])
    except getopt.GetoptError, err:
        print str("%.5f" % err) 
        sys.exit(2)
    name = 'default'
    cpus='default'
    inp = 'default' 
    job='default'

    for o,a in opts:
        if o in ("-t","--template"):
            tmp = a
        elif o in ("-n","--name"):
            name = a
        elif o in ("-c", "--cpus"):
            cpus = a
        elif o in ("-i", "--input"):
            inp = a
	elif o in ("-j", "--job"):
	    job = a
        else:
            assert False, "unhandled option"
   
    if job == 'default':
	print 'Please choose one option for JOB -j (glide or ligprep for docking or ligprep input files, respectively)'
	sys.exit()

    dudlist=sorted(os.listdir('.'))

    if job == 'glide':
	fileterm='_glideligprep.q'
	folder='glide'
	cpus=5

    if job == 'ligprep':
	fileterm='_ligprep.q'
	folder='ligprep'

    f = open(tmp, 'r')
    tmp_str = f.read()
    f.close()


    a=0;
    for dudsys in dudlist:
	name=dudsys+fileterm
	ligin='/marc/data/sruiz/DUD/'+dudsys+'/'+dudsys+'_all_ligands.sd'
        ligout=dudsys+'_ligprep.maegz'
	nextdud=dudlist[a+1]
        next='cd ../../'+nextdud+'/ligprep; queue -a '+nextdud+fileterm

	inp=dudsys+'_glideligprep.in'

        d = {'NJOBS':cpus,'IN':inp,'SCHRODINGER':'$SCHRODINGER','LIG_IN':ligin,'LIG_OUT':ligout,'NEXT_LIGJOB':next}
        q_out = string.Template(tmp_str).substitute(d)
        q = open(name, 'w')
        q.write(q_out)
        q.close()
	
	if a < len(dudlist)-2:	
	    a=a+1


if __name__== "__main__":
    main()
