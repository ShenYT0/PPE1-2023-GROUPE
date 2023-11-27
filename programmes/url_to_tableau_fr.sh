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
        </tr>" > tableau_fr.html

#Read fr.txt line by line; output order number, website URL, HTTP response code, encoding and number of occurence
while read -r line;
do
	#Fetch encoding of websites
	web_encodage=$(curl -s "$line" | grep -Eo 'charset=".*"' | cut -d'"' -f2)
	#Fetch HTTP response code from websites
	web_response=$(curl -Ils "$line" | grep "HTTP/" | grep -Eo "[0-9]{3}")
	#Fetch number of occurence of word 注意这段代码只能在mac上跑，windows要修改iconv那一行(37)
	lynx -dump -nolist "$line" > web_content.txt
	iconv -f macroman -t UTF-8 web_content.txt > web_content_UTF.txt
	occurence_NB=$(cat web_content_UTF.txt | tr '[:upper:]' '[:lower:]' | grep -o "robot" | wc -l)
	rm web_content.txt web_content_UTF.txt
	echo -e "$count\t${line}\t$web_response\t$web_encodage\t$occurence_NB" >> temp.txt
	count=$((count+1))
done < "$chemin_fichier"

#Read temp.txt line by line, convert each line to a HTML body line
while read -r line;
do
#Convert each line to HTML body
mod_line=$(echo -e "$line" | sed 's/\t/<\/td><td>/g')
echo -e "
		<tr>
			<td>${mod_line}</td>
		</tr>" >> tableau_fr.html
done < temp.txt



#Give HTML end
echo "
	</table>
</body>
</html>
" >> tableau_fr.html

#Remove temporary files
rm temp.txt
