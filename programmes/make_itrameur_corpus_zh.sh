#!/usr/bin/env bash

if [[ $# -ne 2 ]] 
then 
    echo "On veut 2 arguments au script : chemin d'un dossier et chemin d'un fichier."
    exit
fi 

DOSSIER=$1
lang=$2

echo "<lang=\"$2\">" > "../itrameur/$1-$2.txt"

for file in ../"$1"/"$2"/*
do
    nom_page=$( basename "$2" | cut -d"." -f1 )
    echo "<page=\"$nom_page\">" >> "../itrameur/$1-$2.txt"

    content=$(LC_CTYPE=C sed -e "s/&/\&amp;/g" -e "s/</\&lt;/g" -e "s/>/\&gt;/g" "$file")
    echo "<text>$content</text>" >> "../itrameur/$1-$2.txt"

    echo -e "</text>\n</page> §" >> "../itrameur/$1-$2.txt"
done

echo "</lang>" >> "../itrameur/$1-$2.txt"


