#!/bin/bash

############################################################
#Author: Crischarles D. Arruda			   	   #					   
#							   #	
#This script can be applied only for:			   #
#-Monoalphabetic Cipher with Homophones for Italian text   #
#	where:						   #
#		Most frequent letter = space		   #
#		asterisk added as part of alphabet	   #
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

#Array with letters by frequency - Italian
itfr=(e i o n l r t s c d p u m v g z f b q h w y j k x a)

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

function areplacement() {

	sed -i 's/G/a/g' $decfilepath
	sed -i 's/M/a/g' $decfilepath
	sed -i 's/C/a/g' $decfilepath
	sed -i 's/Z/a/g' $decfilepath
	sed -i 's/N/a/g' $decfilepath
	sed -i 's/B/a/g' $decfilepath
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
	
	areplacement

	countletters $decfilepath

	sposition=0
	sortletters

	#Special treatment for most frequent letter 
	sed -i "s/${sabc[0]}/ /g" $decfilepath

	for i in {1..26};
	do
		tr "${sabc[$i]}" "${itfr[$i-1]}" < $decfilepath > /tmp/decfiletmp.txt && mv /tmp/decfiletmp.txt $decfilepath
	done

	#############################################################################################################	
	#Version 1.1
	#CHE is the most frequent word with 3 letters in Italian. 
	#Let's use it to confirm that the most frequent letters are in the correct position
	
	wordche=$(cat $decfilepath | grep -o '\b[a-z]\{3\}\b' | sort | uniq -c | sort -nr | head -n 1 | awk -F ' ' '{print $2}')
	wordche1=$(echo $wordche | cut -c 1)
	wordche2=$(echo $wordche | cut -c 2)
	wordche3=$(echo $wordche | cut -c 3)

	if [ "$wordche1" != "c" ]; then
		letterrep "c" "$wordche1"
	fi
	if [ "$wordche2" != "h" ]; then
                letterrep "h" "$wordche2"
        fi
	if [ "$wordche3" != "e" ]; then
                letterrep "e" "$wordche3"
        fi

	#NON is another very common word with 3 letters in Italian, 
	#its difference is, it has the same letter at first and third position
	wordnonlist=$(cat $decfilepath | grep -o '\b[a-z]\{3\}\b' | sort | uniq -c | sort -nr)
	
	for wordnon in $wordnonlist; do
		wordnon1=$(echo $wordnon | cut -c 1)
		wordnon2=$(echo $wordnon | cut -c 2)
		wordnon3=$(echo $wordnon | cut -c 3)

		if [ "$wordnon1" == "$wordnon3" ];
		then
			if [ "n" != "$wordnon1" ];then
				letterrep "n" "$wordnon1"
			fi	
			if [ "o" != "$wordnon2" ];then
				letterrep "o" "$wordnon2"
			fi
			break
		fi
	done

	############################################################################################################
	#Version 1.2
	#Searching for T letter through the word TUTTE
	#TUTTE is a common 5 letters word, with the advantage of those 3 same letter in position 1, 3 and 4. 
	
	wordlist=$(cat $decfilepath | grep -o '\b[a-z]\{5\}\b' | sort | uniq -c | sort -nr)

	for wordt in $wordlist; do 
		wordt1=$(echo $wordt | cut -c 1)
		wordt2=$(echo $wordt | cut -c 2)
		wordt3=$(echo $wordt | cut -c 3)
		wordt4=$(echo $wordt | cut -c 4)
		wordt5=$(echo $wordt | cut -c 5)

		if [[ $wordt1 == $wordt3 && $wordt3 == $wordt4 && $wordt5 == "e" ]];
		then
			letterrep "t" "$wordt1"
			letterrep "u" "$wordt2"
		fi
	done

        #############################################################################################################   
        #Version 1.3
        #Searching for L
	#L is the most common letter found not between other letters (after A, E and I) 
	
	letterlist=$(cat $decfilepath | grep -o '\b[a-z]\b' | sort | uniq -c | sort -nr)
	letterstorm=(a e i)

	for i in {0..2};
	do
		letterlist=$(echo $letterlist | grep -o '\b[a-z]\b' | sed "/${letterstorm[$i]}/d")
	done

	letterl=$(echo $letterlist | cut -c 1)
	letterrep "l" "$letterl"

}

decfunction $1
echo "here is your deciphered message"
cat /tmp/decfile.txt




