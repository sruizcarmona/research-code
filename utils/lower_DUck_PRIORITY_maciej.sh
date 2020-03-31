#this script will lower priority of duck jobs in order
#to allow other users with less jobs start faster
#usually MDmix


for job in $(for i in $(mnq | sed '1d' | awk '{print $1}'); do flag=$(scontrol show jobid -dd $i | grep rachman | wc -l); echo $i $flag; done | sed '/ 0/d' | awk '{print $1}')
do 
	#scontrol update job=$job priority=102; 
	scontrol update job=$job nice=10000; 
done
