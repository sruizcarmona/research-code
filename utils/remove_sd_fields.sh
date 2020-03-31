#!/bin/sh

#fields="SYNONYMS INCHI_IDENTIFIER JCHEM_IUPAC JCHEM_TRADITIONAL_IUPAC" 
fields="SMILES" 
f_to_remove=$1
i=0

for f in $fields;
do
	if [ $i -eq 0 ]; then
		sed -e '/> <'$f'>/,+2d' $f_to_remove > tmp1
		i=1
	else
		sed -e '/> <'$f'>/,+2d' tmp1 > tmp2
		mv tmp2 tmp1
	fi
done

cat tmp1
rm tmp1

