import pyMDMix as pm
import numpy

##getcoords
##########################################
import sys,os

file=sys.argv[1]
f=open(file,"r")
lines=f.readlines()
f.close()

dists=[float(el) for el in (lines[2].rstrip().split()[:3])]
coords=[float(el) for el in (lines[4].rstrip().split()[1:])]

center=[(dists[0]+coords[0])/2]
center.append((dists[1]+coords[2])/2)
center.append((dists[2]+coords[4])/2)

origin=[coords[0]/2.,coords[2]/2.,coords[4]/2.]
counts= numpy.array(dists)*2+1
##########################################

a=numpy.array(map(float,open(file).read().split()[20:]))
mCounts=counts[0]*counts[1]*counts[2]
d=a.reshape(counts[0],counts[1],counts[2],order="F")

header="#MDMIX_RAW_AVG MAM_N\n#Time: Fri Oct  3 16:47:27 2014\n#Source:\nobject 1 class gridpositions counts %i %i %i\norigin  %.2f  %.2f  %.2f\ndelta 0.5   0   0\ndelta 0   0.5   0\ndelta 0   0   0.5\nobject 2 class gridconnections counts %i %i %i\nobject 3 class array type double rank 0 items %i data follows\n"

g = pm.NewGrid(dimensions=(1,2,3), origin=(1,2,3))
g.update(d)
dxname=file.split(".")[0]+".dx"
dxf = open(dxname,'w')
dxf.write(header%(counts[0],counts[1],counts[2],origin[0],origin[1],origin[2],counts[0],counts[1],counts[2],counts[0]*counts[1]*counts[2]))
count=0
for data in g.data.flat:
	if count==3: dxf.write('\n'); count=0
	dxf.write('%6.3f\t'%(float(data)))	
	count+=1

dxf.write('\n')
dxf.close()
