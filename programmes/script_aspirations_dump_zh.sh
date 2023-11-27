#!/usr/bin/env bash

if [[ $# -ne 1 ]];
then
	echo "On veut exactement un argument au script."
	exit
fi

URLS=$1

if [ ! -f $URLS ]
then
	echo "On attend un fichier, pas un dossier"
	exit
fi

lineno=1
nb=1
while read -r ASPIR
do
	curl $ASPIR > ../../aspirations/chinois/zh_$lineno.html
    w3m $ASPIR > ../../dumps-text/chinois/zh_$lineno.txt
	occu=$(cat dumps-text/chinois/zh_$lineno.txt | egrep -o "食品安全" | wc -l)
    echo -e "$lineno\t$occu" >> occurences_zh.txt	
	lineno=$(expr $lineno + 1)
done < "$URLS"