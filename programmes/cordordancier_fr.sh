#!/usr/bin/env bash

numero_fichier=1


while [ "$numero_fichier" -lt 51 ]; do
    echo -e "
    <html>
    <head>
        <meta charset=\"UTF-8\">
        <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css\">
    </head>
    <body>
        <table class=\"table\">
            <tr>
                <th>gauche</th>
                <th>mot</th>
                <th>droite</th>
            </tr>" > ../concordances/fr/fr_${numero_fichier}.html
    ggrep -E -T -i "sécurité alimentaire" ../contextes/fr/fr_$numero_fichier.txt | sed -E "s/(.*)(sécurité alimentaire)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/">>"../concordances/fr/fr_$numero_fichier.html"
    echo "
	    </table>
    </body>
    </html>" >> ../concordances/fr/fr_${numero_fichier}.html
    numero_fichier=$((numero_fichier+1))
done


