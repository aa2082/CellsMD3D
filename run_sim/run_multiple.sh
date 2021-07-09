#!/bin/bash
echo $HOME

mkdir "$HOME/$1/data"	#directory to hold /Cells1 /Cells2 ...
mkdir "$HOME/$1/processing" #directory to hold current stuff
mkdir "$HOME/$1/cmd_line_output" #directory to hold command line outputs: output1.txt output2.txt

for ((i=1; i<= $2; i++))
do
	echo "starting number $(i) at $(date)"
	touch $HOME/$1/cmd_line_output/output$i.txt	#makes output file for recording command line of simulation
	./$3 in1.txt $4 $HOME/$1/processing > $HOME/$1/cmd_line_output/output$i.txt
	mkdir $HOME/$1/data/Cells$i
	cp -R $HOME/$1/processing/Cells/* $HOME/$1/data/Cells$i
	rm -r $HOME/$1/processing/*
done