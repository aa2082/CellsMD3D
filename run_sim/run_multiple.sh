#!/bin/bash

echo "the date is $(date)"
echo $HOME

mkdir "$HOME/$1/data"	#directory to hold /Cells1 /Cells2 ...
mkdir "$HOME/$1/cmd_line_output" #directory to hold command line outputs: output1.txt output2.txt

for ((i=1; i<= $2; i++))
do
	touch "$HOME/$1/cmd_line_output/output$i.txt"	#makes output file for recording command line of simulation
	./$3 in1.txt $4 $HOME/$1/data > $HOME/$1/cmd_line_output/output$i.txt
done