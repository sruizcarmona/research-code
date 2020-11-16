f=$1
out=fixed_${f}
# fix lap length
laplength=$2
# add trackpoints for all
totaldist=$3
sed 's/DistanceMeters>0.0/DistanceMeters>'${laplength}'/g' ${f} |
    sed 's/\/Time>/\/Time><DistanceMeters>'${totaldist}'<\/DistanceMeters>/g' |
    sed 's/<DistanceMeters>'${totaldist}'</<DistanceMeters>0</' |
    sed 's/Sport=\"Other/Sport=\"swimming/' > $out
