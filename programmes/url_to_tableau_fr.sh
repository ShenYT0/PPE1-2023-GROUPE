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
    <link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css\" rel=\"stylesheet\" integrity=\"sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN\" crossorigin=\"anonymous\">
    <script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js\" integrity=\"sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL\" crossorigin=\"anonymous\"></script>
    <title>Tableau JPN</title>
</head>
<body>
    <div class="table-responsive">
	<table class=\"table table-info table-hover table-sm\">
        <tr>
            <th>num</th>
            <th>url</th>
            <th>requête</th>
            <th>encodage</th>
            <th>aspiration</th>
            <th>dump-text</th>
            <th>compte</th>
            <th>contexte</th>
            <th>concordance</th>
        </tr>
" > ../tableaux/tableau_fr.html

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
			<td>$count</td>
			<td><a href=\"$line\">$line</a></td>
			<td>$web_response</td>
			<td>$web_encodage</td>
			<td><a href="../aspirations/fr/fr_${count}.html">aspiration</a></td>
			<td><a href="../dumps-text/fr/fr_${count}.txt">dump-text</a></td>
			<td>$occurence_NB</td>
			<td><a href="../contextes/fr/fr_${count}.txt">contexte</a></td>
			<td><a href="../concordances/fr/fr_${count}.html">concordance</a></td>
		</tr>" >> ../tableaux/tableau_fr.html
	count=$((count+1))
done < "$chemin_fichier"

#Give HTML end
echo "
	</table>
</body>
</html>
" >> ../tableaux/tableau_fr.html