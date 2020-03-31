#!/usr/bin/python
import Biskit,numpy,sys
pdbfile=sys.argv[1]
bffile=sys.argv[2]
outfile=sys.argv[3]

a=Biskit.PDBModel(pdbfile)
bf=[float(item.split()[0]) for item in open(bffile).read().split("\n")[:-1]]
bfn=numpy.array(bf)
a['temperature_factor']=bfn
a.writePdb(outfile)
