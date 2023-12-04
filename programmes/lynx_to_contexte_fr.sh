#!/usr/bin/env bash

#lynx每个链接，找关键词，显示前两行后两行，把结果储存到contextes文件夹里，重复50次

URLS=$1
numero_fichier=1

while read -r ASPIR
do
    lynx -dump -nolist -assume_charset=utf-8 --display_charset=utf-8 $ASPIR | LC_CTYPE=C tr '[:upper:]' '[:lower:]' | grep -B 2 -A 2 "sécurité alimentaire" > ../contextes/fr/fr_${numero_fichier}.txt
	numero_fichier=$(expr "$numero_fichier" + 1)
done < "$URLS"