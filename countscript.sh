#!/bin/bash
#
############################################################
#Author: Crischarles D. Arruda			   	   #					   
#							   #	
#This script can be applied only for:			   #
#-Single Substitution Monoalphabetic Cipher for Pt-Br text #
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

#Arrays with letters by frequency
ptbrfr=(a e o s r i d m n t c u l p v g q b f h z j x w k y)
enfr=(e t a o i n s h r d l c u m w f g y p k b v j x q z)
itfr=("i" "a" "e" "o" "n" "t" "r" "l" "s" "c" "d" "p" "u" "m" "v" "g" "z" "f" "b" "q" "h" "w" "y" "j" "k" "x")

#Function to count letters from the file
function countletters(){
	position=0
	for l in {A..Z};
	do	
		filefr[$position]=$(grep -o "$l" "$1" | wc -l)
		abc[$position]="$l"
		((position++))
	done	
	
	#counting *
	filefr[$position]=$(grep -o "*" "$1" | wc -l)
	abc[$position]="*"
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

#Function used for letter replacement 
function letterrep(){

	tr "$1" "+" < $decfilepath > /tmp/decfiletmp.txt && mv /tmp/decfiletmp.txt $decfilepath
        tr "$2" "$1" < $decfilepath > /tmp/decfiletmp.txt && mv /tmp/decfiletmp.txt $decfilepath
        tr "+" "$2" < $decfilepath > /tmp/decfiletmp.txt && mv /tmp/decfiletmp.txt $decfilepath

}

#Function to decipher the file content
function decfunction(){
	
	decfilepath=/tmp/decfile.txt
	cat "$1" | tr '[:lower:]' '[:upper:]' > $decfilepath

	############################################################################################################
	#Version 1.0
	#Deciphering through Letter Frequency analysis 

	tr "X" " " < $decfilepath > /tmp/decfiletmp.txt && mv /tmp/decfiletmp.txt $decfilepath

	for i in {0..26};
	do
		tr "${sabc[$i]}" "${itfr[$i]}" < $decfilepath > /tmp/decfiletmp.txt && mv /tmp/decfiletmp.txt $decfilepath
	done

	#tr "s" "+" < $decfilepath > /tmp/decfiletmp.txt && mv /tmp/decfiletmp.txt $decfilepath
	#tr "d" "s" < $decfilepath > /tmp/decfiletmp.txt && mv /tmp/decfiletmp.txt $decfilepath
	#tr "+" "d" < $decfilepath > /tmp/decfiletmp.txt && mv /tmp/decfiletmp.txt $decfilepath

	#############################################################################################################	
	#Version 1.1
	#Checking whether the two most frequent letters are in the correct position (A and E), using the word "que"
	#"que" is the most frequent word by far with just 3 letters in PtBr
	
	wordslist=$(cat $decfilepath | grep -o '\b[a-z]\{3\}\b' | sort | uniq -c | sort -nr)
	worde=$(echo $wordslist | grep -Eo '\b\w+e\b' | head -n 1)
	worda=$(echo $wordslist | grep -Eo '\b\w+a\b' | head -n 1)
	
	#Searching for the letter 'q'
	cutworde=$(echo $worde | cut -c 1)
	cutworda=$(echo $worda | cut -c 1)
	
	countcutworda=$(cat $decfilepath | grep -Eo "\b\w+${cutworda}\b" | wc -l)
	countcutworde=$(cat $decfilepath | grep -Eo "\b\w+${cutworde}\b" | wc -l)
	
	if [ $countcutworda -gt $countcutworde ]
	then
		wordque=$worde
	else
		wordque=$worda
	fi

	#Letter replacement time based on the word "que"
	wordque1=$(echo $wordque | cut -c 1)
	wordque2=$(echo $wordque | cut -c 2)
	wordque3=$(echo $wordque | cut -c 3)
	
	#letterrep "q" "$wordque1"
	#letterrep "u" "$wordque2"
	#letterrep "e" "$wordque3"
	
	#############################################################################################################   
        #Version 1.2
	#Using common words like "uma" and "nao"
	
	#Updating wordslist
	wordslist=$(cat $decfilepath | grep -o '\b[a-z]\{3\}\b' | sort | uniq -c | sort -nr)
	
	#Searching for the word "uma"
	worduma=$(echo $wordslist | grep -Eo '\bu\w+a\b' | head -n 1)
	worduma=$(echo $worduma | cut -c 2)

	#Letter replacement time base on the word "uma"
	#letterrep "m" "$worduma"

	#Searching for the word "nao" and removing the possible word already fixed "mao"
	wordslist=$(cat $decfilepath | grep -o '\b[a-z]\{3\}\b' | sort | uniq -c | sort -nr)
	wordnao=$(echo $wordslist | grep -Eo '\b\w+ao\b' | sed '/mao/d' | head -n 1)
	
	wordnao=$(echo $wordnao | cut -c 1)

        #letterrep "n" "$wordnao"

	#############################################################################################################
        #Version 1.3
        #Where is "H"? Using the word "ha" to find it
	
	wordslist=$(cat $decfilepath | grep -o '\b[a-z]\{2\}\b' | sort | uniq -c | sort -nr)
	
	#Removing common words with 2 letters ending with "a"
	endswitha=(da ja la na)
	for i in {0..3};
	do 
		wordslist=$(echo $wordslist | grep -Eo '\b\w+a\b' | sed "/${endswitha[i]}/d")
	done

	wordha=$(echo $wordslist | cut -c 1)
	#letterrep "h" "$wordha"
}


countletters $1

sposition=0
sortletters

echo ${abc[*]}
echo ${filefr[*]}

echo ${sabc[*]}
echo ${sfilefr[*]}

#decfunction $1
echo "here is your deciphered message"
#cat /tmp/decfile.txt




