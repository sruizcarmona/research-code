import getopt,re,os,sys,string

def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "t:n:p:i:o:r:a:m:l:c:q:", ["template=","name=","pwy=","input=","output=","runs=","asfile=","mol2file=","lig=","const=","prm="])
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
            asfile = a.split("/")[len(a.split("/"))-1]
        elif o in ("-m", "--mol2file"):
            mol2file = a.split("/")[len(a.split("/"))-1]
        elif o in ("-l", "--lig"):
            lig = a.split("/")[len(a.split("/"))-1]
        elif o in ("-c", "--const"):
            const = a.split("/")[len(a.split("/"))-1]
        elif o in ("-q", "--prm"):
            prm = a.split("/")[len(a.split("/"))-1]
        else:
            assert False, "unhandled option"

    f = open(tmp, 'r')
    tmp_str = f.read()
    f.close()
    path='../../'

    queue_fname = name.replace('.sd','.q')
    d = {'IN_L':inp.lower(),'CONST_L':const,'PRM_L':prm,'OUT':output.replace('.sd','_out'),'NRUNS_L':runs, 'AS_L':asfile,'MOL2_L':mol2file,'LIG_L':lig,'IN':'../'+pwy+'/'+inp,'CONST':path+const,'PRM':path+prm,'NRUNS':path+runs, 'AS':path+asfile,'MOL2':path+mol2file,'LIG':path+lig}
    q_out = string.Template(tmp_str).substitute(d)
    q = open(queue_fname, 'w')
    q.write(q_out)
    q.close()

if __name__== "__main__":
    main()
