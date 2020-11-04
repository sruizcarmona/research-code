#!/usr/bin/python
import getopt,os,sys

def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "g:ioehl:f:p:c:n:", ["grid=","ligand=","file=","poses=","cvcutoff=","number="])
    except getopt.GetoptError, err:
        print str(err) 
        sys.exit(2)
    grid="undef"
    file="undef"
    ligand="undef"
    poses=1
    exhaustive=False
    cvcutoff=0
    number="default"
    resinteraction = False
    precision="default"
    outtype="default"
    for o,a in opts:
        if o in ("-g","--grid"):
	    grid = a
	elif o == "-i":
	    resinteraction= True
	elif o in ("-l","--ligand"):
	    ligand = a
	elif o in ("-f", "--file"):
            file = a
	elif o in ("-p", "--poses"):
            poses = a
	elif o in ("-c", "--cvcutoff"):
            cvcutoff = float(a)
	elif o == "-h":
            precision = "HTVS"
	elif o == "-e":
            exhaustive = True
	elif o == "-o":
            outtype = "ligandlib"
	elif o in ("-n","--number"):
	    number=int(a)
        else:
            assert False, "unhandled option"
    if grid == "undef":
	print "\nERROR, no path for -g option is defined.\nGRID output file is necessary!\n"
	sys.exit()
    if file == "undef":
        print "\nERROR, you have to define the output file.\n"
        sys.exit()
    if ligand == "undef":
        print "\nERROR, you have to define the receptor file\n"
        sys.exit()
	
    f=open(file,"w")

    if resinteraction: f.write("WRITE_RES_INTERACTION YES\n")
    if exhaustive: f.write("EXPANDED_SAMPLING YES\n")
    f.write("USECOMPMAE YES\n")
    if poses != 1:
	f.write("POSTDOCK_NPOSE ")
    	f.write(str(poses))
    	f.write("\nPOSES_PER_LIG ")
    	f.write(str(poses))
    	f.write("\n")
    if number != "default":
	f.write("NREPORT ")
	f.write(str(number))
	f.write("\n")
    f.write("RINGCONFCUT 2.500000\n")
    f.write("POSE_OUTTYPE ligandlib\n")
    if cvcutoff != 0:
	f.write("CV_CUTOFF ")
    	f.write(str(cvcutoff))
    	f.write("\n")
    f.write("GRIDFILE ")
    f.write(grid)
    f.write("\nLIGANDFILE ")
    f.write(ligand)
    if precision == "HTVS": f.write("\nPRECISION HTVS")
    if outtype == "ligandlib": f.write("\nPOSE_OUTTYPE ligandlib")
    

    f.close()

if __name__== "__main__":
    main()
