#!/usr/bin/python

import numpy
a=numpy.array(map(float,[item.split()[1] for item in open("WAT_0/prot_Bfact.txt").read().split("\n")[:-1]]))
b=numpy.array(map(float,[item.split()[1] for item in open("WAT_1/prot_Bfact.txt").read().split("\n")[:-1]]))
c=(a+b)/2
cw=map(str,c.tolist())

out=open("avg_bfact.txt","w")
out.write("\n".join(cw))
out.write("\n")
out.close()
