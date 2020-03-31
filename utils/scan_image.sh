scanimage --device-name=epson2 --format=pnm --mode='Gray' --resolution 300 -l 40 -t 0 -x 48 > kk.pnm
gocr -i kk.pnm -o kk.txt
