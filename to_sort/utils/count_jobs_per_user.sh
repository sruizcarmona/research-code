for i in $(mnq | sed '1d' | awk '{print $1}'); do scontrol show jobid -dd $i | grep Command; done > users.kk
for i in mmajewski mmartinez mrachman sruiz piticc;
do
	echo $i
	grep -c $i users.kk
done
rm users.kk
