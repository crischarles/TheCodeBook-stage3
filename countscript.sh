#!/bin/bash

############################################################
#Author: Crischarles D. Arruda			   	   #					   
#							   #	
#This script counts letters and order by frequency	   #
#							   #
############################################################

#Checking if sent file is valid

if [ -f "$1" ];
then
	echo "File exists"
	validation=$(file $1 | awk -F ': ' '{print $2}' | awk -F ' ' '{print $2}')
	
	if [[ $validation == "text"* ]];
	then
		echo "and it's a valid file"
	else
		echo "but it's an invalid file, please sent a text file"
		exit 1
	fi	
else
	echo "File doesn't exist"
	exit 1
fi

#Function to count letters from the file
function countletters(){
	position=0 
	for l in {a..z};
	do	
		filefr[$position]=$(grep -o "$l" "$1" | wc -l)
		abc[$position]="$l"
		((position++))
	done
}

#Function to sort by largest
function sortletters(){
	largest=0
	for n in {0..26};
	do 
		if [[ largest -lt ${filefr[$n]} ]];
		then
		       largest=${filefr[$n]}
		       nposition=$n
		fi
	done

	if [[ sposition -lt 27 ]];
	then	
		sabc[$sposition]=${abc[$nposition]}
		sfilefr[$sposition]=$largest
		
		((sposition++))
		
		filefr[$nposition]=0
		sortletters
	fi
}


countletters $1

sposition=0
sortletters

echo ${sabc[*]}
echo ${sfilefr[*]}





