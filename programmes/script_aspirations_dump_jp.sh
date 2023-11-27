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
	curl $ASPIR > ../../aspirations/japonais/jp_$lineno.html
    w3m $ASPIR > ../../dumps-text/japonais/jp_$lineno.txt
	lineno=$(expr $lineno + 1)
done < "$URLS"