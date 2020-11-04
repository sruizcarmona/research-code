#!/usr/bin/python
import sys,os

file=sys.argv[1]
aptsys=sys.argv[2]
f=open(file,"r")
lines=f.readlines()
f.close()

dists=[float(el) for el in (lines[2].rstrip().split()[:3])]
coords=[float(el) for el in (lines[4].rstrip().split()[1:])]

center=[(dists[0]+coords[0])/2]
center.append((dists[1]+coords[2])/2)
center.append((dists[2]+coords[4])/2)

os.system("python $SCRIPTS/createGridIn.py -g "+aptsys+"_grid.zip -r /xpeople/sruiz/APTAMERS_RNA/"+aptsys+"/"+aptsys+".maegz -f "+aptsys+"_grid.in -c \""+str('%.5f' % center[0])+" "+str('%.5f' % center[1])+" "+str('%.5f' % center[2])+"\" -x "+str('%.5f' % dists[0])+" -y "+str('%.5f' % dists[1])+" -z "+str('%.5f' % dists[2]))
