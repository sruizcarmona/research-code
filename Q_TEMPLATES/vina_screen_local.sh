#! /bin/bash

for f in ligs_pdbqt/*lig*.pdbqt; do
    b=`basename $f .pdbqt`
    echo Processing ligand $b
    vina --config vina_conf.txt --ligand $f --out results/$b\_out.pdbqt > results/logs/$b\_log.txt
done
