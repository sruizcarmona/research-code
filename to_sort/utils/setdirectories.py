#! /usr/bin/python
# Initialization script. It will create required directory structure.
# Make symbolic link to the trajectory path, topology and reference PDB files.
import os
import sys
import distutils.dir_util as du
import distutils.file_util as fu

import Biskit as bi
import numpy as npy

# Check and parse arguments
if len(sys.argv) < 5: sys.exit("USAGE: setdirectories.py topologyFile pdbFile mdPath dirName")
topFile = os.path.abspath(sys.argv[1])
pdbFile = os.path.abspath(sys.argv[2])
trajPath = os.path.abspath(sys.argv[3])
dirName = sys.argv[4]
rootPath = os.path.dirname(sys.argv[0]) + os.sep

# Create directory tree and symbolik links
du.create_tree(dirName, ['pdbs/', 'sasa/', 'pca/', 'mdpocket/', 'desc/', 'mdmix/'])
os.chdir(dirName)
os.symlink(trajPath, 'raw_traj')
os.symlink(topFile, os.path.splitext(os.path.basename(topFile))[0]+'.top')
os.symlink(pdbFile, os.path.basename(pdbFile))

### Copy scripts of analysis
##fu.copy_file(rootPath+'scripts/runptraj.py','.')
##fu.copy_file(rootPath+'scripts/mdmix_ta.py','mdmix/')
##fu.copy_file(rootPath+'scripts/mdmix_gr.py','mdmix/')
##fu.copy_file(rootPath+'scripts/modules.py','mdmix/')
##fu.copy_file(rootPath+'scripts/mdmix_pscript.pml','mdmix/')
##fu.copy_file(rootPath+'scripts/mdmix_druggability.pl','mdmix/')
##fu.copy_file(rootPath+'scripts/mdmix_druggability_DGgrids.pl','mdmix/')
##fu.copy_file(rootPath+'scripts/PCA_md_trajectories.R','pca/')
##fu.copy_file(rootPath+'scripts/takeBB.py','pca/')
##fu.copy_file(rootPath+'scripts/extractSASAs.py','sasa/')
##fu.copy_file(rootPath+'scripts/runSASA.sh','sasa/')
##fu.copy_file(rootPath+'scripts/diffSASA.py','sasa/')
##
### Change user modes to make them executable
##os.system('chmod +x runptraj.py')
##os.system('chmod +x mdmix/mdmix_ta.py')
##os.system('chmod +x mdmix/mdmix_gr.py')
##os.system('chmod +x pca/takeBB.py')
##os.system('chmod +x sasa/runSASA.sh')
