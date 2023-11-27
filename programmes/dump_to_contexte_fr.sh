#!/usr/bin/env bash

#依次读取dumps文件夹的文件，找关键词，显示前一行后一行，把结果储存到contextes文件夹里，重复50次

numero_fichier=1

if [ $numero_fichier -lt 50 ]; then
    cat ../dumps-text/fr/fr_fich${numero_fichier}.txt | tr '[:upper:]' '[:lower:]' | grep -B 1 -A 1 "sécurité alimentaire" > ../contextes/fr_fich${numero_fichier}.txt
    numero_fichier=$(expr $numero_fichier + 1)
fi