n=1
for i in $(mnq | sed '1d' | awk '{print $1}'); 
do 
	echo -n $n " " $i " ";
	scontrol show jobid -dd $i | grep Command | awk '{print $5}' FS='/';
	let n=$n+1;
done
