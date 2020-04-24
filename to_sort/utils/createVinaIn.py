import sys
import getopt,os,time,re

def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "g:r:f:x:y:z:c:", ["grid=","receptor=","file=","xcoord=","ycoord=","zcoord=","center="])
    except getopt.GetoptError, err:
        print str("%.5f" % err) 
        sys.exit(2)
    grid="undef"
    file="undef"
    receptor="undef"
    xcoord="default"
    ycoord="default"
    zcoord="default"
    cnt="undef"
    for o,a in opts:
        if o in ("-g","--grid"):
	    grid = a
	elif o in ("-r","--receptor"):
	    receptor = a
	elif o in ("-f", "--file"):
            file = a
	elif o in ("-x", "--xcoord"):
            xcoord = a
	elif o in ("-y", "--ycoord"):
            ycoord = a
	elif o in ("-z", "--zcoord"):
            zcoord = a
	elif o in ("-c", "--center"):
            cnt = a.split()
        else:
            assert False, "unhandled option"
    if file == "undef":
        print "\nERROR, you have to define the output file.\n"
        sys.exit()
    if receptor == "undef":
        print "\nERROR, you have to define the receptor input file.\n"
        sys.exit()
    if xcoord=="default":
	inner="default"
    else:
	inner=[]
	inner.append(str(int(float(xcoord)-5)))
	inner.append(str(int(float(ycoord)-5)))
	inner.append(str(int(float(zcoord)-5)))
    f=open(file,"w") 

    f.write("USECOMPMAE YES\n")
    f.write("INNERBOX ")
    if inner == "default":
	f.write("10, 10, 10")
    else:
	f.write(inner[0])
	f.write(", ")
	f.write(inner[1])
	f.write(", ")
	f.write(inner[2])
    if xcoord =="default":
	xcoord=30.00000
	ycoord=30.00000
	zcoord=30.00000
    f.write("\nACTXRANGE ")
    f.write(xcoord)
    f.write("\nACTYRANGE ")
    f.write(ycoord)
    f.write("\nACTZRANGE ")
    f.write(zcoord)
    if cnt == "undef":
        print "\nERROR, you have to define the grid center.\n"
        sys.exit()
    else:
    	f.write("\nGRID_CENTER "+cnt[0]+", "+cnt[1]+", "+cnt[2])
    f.write("\nOUTERBOX ")
    f.write(xcoord)
    f.write(", ")
    f.write(ycoord)
    f.write(", ")
    f.write(zcoord)
    f.write("\nGRIDFILE ")
    f.write(grid)
    f.write("\nRECEP_FILE ")
    f.write(receptor)
    f.write("\n")
    f.close()

if __name__== "__main__":
    main()
