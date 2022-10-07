#!/usr/bin/python

import math
import pybel
import numpy as npy

def squared_distance(coordsA, coordsB):
    """Find the squared distance between two 3-tuples"""
    sqrdist = sum( (a-b)**2 for a, b in zip(coordsA, coordsB) )
    return sqrdist
    
def rmsd(allcoordsA, allcoordsB):
    """Find the RMSD between two lists of 3-tuples"""
    deviation = sum(squared_distance(atomA, atomB) for
                    (atomA, atomB) in zip(allcoordsA, allcoordsB))
    return math.sqrt(deviation / float(len(allcoordsA)))
    
def mapToCrystal(xtal, pose):
    """Some docking programs might alter the order of the atoms in the output (like Autodock Vina does...)
     this will mess up the rmsd calculation with OpenBabel"""
    query = pybel.ob.CompileMoleculeQuery(xtal.OBMol) 
    mapper=pybel.ob.OBIsomorphismMapper.GetInstance(query)
    mappingpose = pybel.ob.vvpairUIntUInt()
    exit=mapper.MapUnique(pose.OBMol,mappingpose)
    return mappingpose[0]

    
if __name__ == "__main__":
    import sys
    
    xtal = sys.argv[1]
    poses = sys.argv[2]

    # Read crystal pose
    crystal = next(pybel.readfile("sdf", xtal))
    crystal.removeh()

    # Find automorphisms involving only non-H atoms
    mappings = pybel.ob.vvpairUIntUInt()
    bitvec = pybel.ob.OBBitVec()
    lookup = []
    for i, atom in enumerate(crystal):
        lookup.append(i)
    success = pybel.ob.FindAutomorphisms(crystal.OBMol, mappings)

    # Find the RMSD between the crystal pose and each docked pose
    xtalcoords = [atom.coords for atom in crystal]
    dockedposes = pybel.readfile("sdf", poses)
    for i, dockedpose in enumerate(dockedposes):
        dockedpose.removeh()
        mappose = mapToCrystal(crystal, dockedpose)
        mappose = npy.array(mappose)
        mappose = mappose[npy.argsort(mappose[:,0])][:,1]
        posecoords = npy.array([atom.coords for atom in dockedpose])[mappose]
        minrmsd = 999999999999
        minfitrmsd = 999999999999
        for mapping in mappings:
            automorph_coords = [None] * len(xtalcoords)
            for x, y in mapping:
                automorph_coords[lookup.index(x)] = xtalcoords[lookup.index(y)]
            mapping_rmsd = rmsd(posecoords, automorph_coords)
            if mapping_rmsd < minrmsd:
                minrmsd = mapping_rmsd
        #print("The RMSD nofit is %.2f, RMSD fit is %.2f for pose %d" % (minrmsd, minfitrmsd, (i+1)))
	print("RMSD of entry %d = %.4f" % ((i+1),minrmsd))
