#!/bin/bash
PRM="gasd_rdock_free.prm"
#PH4=pharma.const
#NRUNS="filter_5p.txt"
NRUNS=50

##Choose one of: ASINEX ENAMINE LIFECHEM PRINCETON SPECS
VENDOR=$1
LIB=`echo $VENDOR | awk '{print tolower($0)}'`
LIBPATH="/sysgen/raw/internal/HTSDB_50/"

#DIR=`pwd`
DIR=.
HTDIR="VS_"$VENDOR

PROTOCOL="dock.prm"

LOGDIR=${DIR}/${HTDIR}/log
OUTDIR=${DIR}/${HTDIR}/out

mkdir $HTDIR $LOGDIR $OUTDIR

for SDF in ${LIBPATH}/${LIB}/*.sd
do
        ligBasename=`basename $SDF`
        OUT=${ligBasename%.sd}_out

        echo rbdock -i $SDF -o $OUTDIR/$OUT -r $PRM -p $PROTOCOL -n $NRUNS \> ${LOGDIR}/${OUT}.log ';' sdsort -n -fSCORE -s ${OUTDIR}/${OUT}.sd \| sdfilter -f"'"\$SCORE.RESTR \< 1.0"'" \| sdfilter -f"'"\$SCORE.INTER \< -10.0"'" \| sdfilter -f"'"\$_COUNT == 1"'" \> ${OUTDIR}/${OUT}_sorted.sd >> greasy_input_${VENDOR}.txt
done

sed 's/XXINPUTXX/'greasy_input_${VENDOR}.txt'/' send_greasy_tmp.q.tmp | sed 's/XXNAMEXX/'$VENDOR'_'$PRM'/'> send_greasy_${VENDOR}.q
