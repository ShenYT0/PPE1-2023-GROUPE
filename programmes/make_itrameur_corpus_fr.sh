#!/usr/bin/env bash

#define arguments
dump_dossier="../dumps-text/fr"
URLS="../urls/fr.txt"

#give XML start, create iTrameur file
echo "<lang=\"fr\">" > ../itrameur/dumps-text-fr.txt

#give XML body
count_dump=1
while read -r URL; do
    if [ "$count_dump" -lt 51 ]; then
        contenu_dump=$(cat "$dump_dossier"/fr_"${count_dump}".txt)
        echo "<page=\"$URL\">
	<text>$contenu_dump</text>
</page> §" >> ../itrameur/dumps-text-fr.txt
        count_dump=$(expr "$count_dump" + 1)
    fi
done < "$URLS"

#give XML ending
echo "</lang>" >> ../itrameur/dumps-text-fr.txt