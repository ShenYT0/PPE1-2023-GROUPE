#!/usr/bin/env bash

chemin_fichier=$1
count=1

#Give a default file if chemin_fichier not specified
if [ -z "$1" ]; then
	chemin_fichier="../urls/fr.txt"
fi

#Give HTML head, create HTML file
echo -e "
<html>
<head>
	<meta charset=\"UTF-8\">
    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css\">
</head>
<body>
	<table class=\"table\">
        <tr>
            <th>num</th>
            <th>url</th>
            <th>requête</th>
            <th>encodage</th>
			<th>nombre d'occurence</th>
        </tr>" > ../tableaux/tableau_fr.html

#Read fr.txt line by line; output order number, website URL, HTTP response code, encoding and number of occurence
while read -r line;
do
	#Fetch encoding of websites
	web_encodage=$(curl -s "$line" | grep -Eo 'charset=".*"' | cut -d'"' -f2 | tr '[:lower:]' '[:upper:]' | uniq )
	#Fetch HTTP response code from websites
	web_response=$(curl -Ils "$line" | grep "HTTP/" | grep -Eo "[0-9]{3}")
	#Fetch number of occurence of word
	occurence_NB=$(lynx --dump --nolist -assume_charset=utf-8 --display_charset=utf-8 "$line" | LC_CTYPE=C tr '[:upper:]' '[:lower:]' | grep -o "sécurité alimentaire" | wc -l)
	#Print results into tableau_fr.html
	echo "		<tr>
			<td>$count</td><td>$line</td><td>$web_encodage</td><td>$web_response</td><td>$occurence_NB</td>
		</tr>" >> ../tableaux/tableau_fr.html
	count=$((count+1))
done < "$chemin_fichier"

#Give HTML end
echo "
	</table>
</body>
</html>
" >> ../tableaux/tableau_fr.html