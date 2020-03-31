## lines starting with <SCORE> stored in for loop in $i, then add one to get score and print the line with the score.
#for i in $(sed -n '/<SCORE>/=' allResults.sdf); do  let i=$i+1; sed -n ${i}p allResults.sdf;  done

#sdsort -n -s -fSCORE test.out.sd | sdfilter -f'$_COUNT == 1' | sdsort -n -fSCORE.INTER

#PRINTS MAXIMUM SCORE
#for i in $(sdsort -n -s -fSCORE $1 | sdfilter -f'$_COUNT == 1' | sdsort -n -fSCORE.INTER | sed -n '/<SCORE>/='); do  let i=$i+1; sdsort -n -s -fSCORE $1 | sdfilter -f'$_COUNT == 1' | sdsort -n -fSCORE.INTER | sed -n ${i}p;   done

#for i in $(sdsort -n -s -fSCORE $1 | sdsort -n -fSCORE.INTER | sed -n '/<SCORE>/='); do  let i=$i+1; sdsort -n -s -fSCORE $1 | sdfilter -f'$_COUNT == 1' | sdsort -n -fSCORE.INTER | sed -n ${i}p;   done

##SORTS ALL POSES FROM HIGHEST TO LOWEST SCORES
#It takes all poses of all ligands and sorts them all
sdsort -n -fSCORE $1 


#sdsort -n -s -fSCORE test.out.sd | sdfilter -f'$_COUNT == 1' | sdsort -n -fSCORE.INTER); do  let i=$i+1; sed -n ${i}p test.out.sd;  done

