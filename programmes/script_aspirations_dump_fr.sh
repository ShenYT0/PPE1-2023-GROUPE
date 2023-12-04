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
	curl -s $ASPIR > ../aspirations/fr/fr_$lineno.html
    lynx -dump -nolist -assume_charset=utf-8 --display_charset=utf-8 $ASPIR > ../dumps-text/fr/fr_$lineno.txt
	lineno=$(expr $lineno + 1)
done < "$URLS"