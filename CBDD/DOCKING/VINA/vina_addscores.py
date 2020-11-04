#!/usr/bin/python

import pybel,sys

input= sys.argv[1]
fout= sys.argv[2]

inp=pybel.readfile("sdf",input)

def VinaScore(mol):
     ans = {}
     ans['VINA_SCORE'] = mol.data['REMARK'].split()[2]
     return ans

output = pybel.Outputfile("sdf", fout,overwrite=True)
for m in inp:
    m.data.update(VinaScore(m))
    output.write(m)

output.close()

