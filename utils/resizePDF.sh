#!/bin/bash

# USAGE resizePDF.sh bigfile.pdf smallfile.pdf

# -q quiet -> fewer messages
gs  -dNOPAUSE -dBATCH -dSAFER \
    -sDEVICE=pdfwrite \
    -dCompatibilityLevel=1.4 \
    -dPDFSETTINGS=/screen \
    -dEmbedAllFonts=true \
    -dSubsetFonts=true \
    -dColorImageDownsampleType=/Bicubic \
    -dColorImageResolution=300 \
    -dGrayImageDownsampleType=/Bicubic \
    -dGrayImageResolution=300 \
    -dMonoImageDownsampleType=/Bicubic \
    -dMonoImageResolution=300 \
    -sOutputFile=$2 \
     $1
