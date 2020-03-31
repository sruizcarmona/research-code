#!/usr/bin/python
#script for moving and rotating a ligand

import pybel,sys,random

def rotate(inp,out):
	mol=pybel.readfile("sdf",inp).next()
	
	v=pybel.ob.vector3(random.randrange(0,10),random.randrange(0,10),random.randrange(0,10))
	mol.OBMol.Translate(v)

	matrix = pybel.ob.matrix3x3()
	matrix.RotAboutAxisByAngle(pybel.ob.vector3(1,1,1), 90)
	my_array = pybel.ob.doubleArray(9)
	matrix.GetArray(my_array)
	mol.OBMol.Rotate(my_array)
	
	
	output = pybel.Outputfile("sdf",out)
	output.write(mol)
	output.close()

if __name__ == '__main__':
	input=sys.argv[1]
	output=sys.argv[2]
	rotate(input,output)


	

