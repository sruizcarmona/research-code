###i want to select 800 molecules for manual inspection:
#First 100 mols by SCORE.INTER
#First 100 mols by SCORE.INTER.norm
#First 200 cluster centroids by similarity
#First 200 cluster centroids by SCORE.INTER
#First 200 cluster centroids by SCORE.INTER.norm

myfile="VS_SPECS/specs_raw_hits_top1000.sd"

###1) first 100 mols by score.inter:
sdfilter -f'$_REC <= 100' $myfile > SELECTED_MOLS/a_top100_scoreinter.sd

###2) first 100 mols by score.inter.norm:
sdsort -n -fSCORE.INTER.norm $myfile | sdfilter -f'$_REC <= 100' > SELECTED_MOLS/b_top100_scoreinternorm.sd

###3) first 200 cluster centroids:
#as they come from python notebook, first molecule from each cluster
for f in CLUSTERS/*;
do
    sdfilter -f'$_REC == 1' $f >> SELECTED_MOLS/c_top200_centroids.sd
done

###4) first 200 cluster members by SCORE.INTER:
#sort each cluster with SCORE.INTER and select first molecule
for f in CLUSTERS/*;
do
    sdsort -n -fSCORE.INTER $f | sdfilter -f'$_REC == 1' >> SELECTED_MOLS/d_top200_cl_scoreinter.sd
done

###5) first 200 cluster members by SCORE.INTER.norm:
#sort each cluster with SCORE.INTER.norm and select first molecule
for f in CLUSTERS/*;
do
    sdsort -n -fSCORE.INTER.norm $f | sdfilter -f'$_REC == 1' >> SELECTED_MOLS/e_top200_cl_scoreinternorm.sd
done
