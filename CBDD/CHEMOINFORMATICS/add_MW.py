#!/usr/bin/python

import pybel,sys

input= sys.argv[1]
fout= sys.argv[2]

inp=pybel.readfile("sdf",input)

def VinaScore(mol):
     ans = {}
     ans['MW'] = mol.molwt
     return ans

output = pybel.Outputfile("sdf", fout)
for m in inp:
    m.data.update(VinaScore(m))
    output.write(m)

output.close()

