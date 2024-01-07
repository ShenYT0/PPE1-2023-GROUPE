#!/usr/bin/env bash

#define arguments
contexte_dossier="../contextes/fr"
URLS="../urls/fr.txt"

#give XML start, create iTrameur contexte file
echo "<lang=\"fr\">" > ../itrameur/contexte-fr.txt

#give XML body
count_contexte=1
while read -r URL; do
    if [ "$count_contexte" -lt 51 ]; then
        contenu_contexte=$(cat "$contexte_dossier"/fr_"${count_contexte}".txt)
        echo "<page=$URL>
	<text>$contenu_contexte</text>
</page> §" >> ../itrameur/contexte-fr.txt
        count_contexte=$(expr "$count_contexte" + 1)
    fi
done < "$URLS"

#give XML ending
echo "</lang>" >> ../itrameur/contexte-fr.txt