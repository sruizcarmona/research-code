#!/usr/bin/python
import numpy, sys

mol2file=sys.argv[1]

o=[item.split() for item in open(mol2file).readlines()]
k=[]
for i in o:
 if len(i) > 9:
  k.append(float(i[9]))

k=numpy.array(k)

print "min",k.min()
print "max",k.max()
print "mean",k.mean()
print "sd",k.std()
