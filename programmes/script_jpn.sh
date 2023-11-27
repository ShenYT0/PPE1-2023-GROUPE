#!/bin/bash

if [ -f "../tableaux/tableau_jpn.html" ];
then
    rm "../tableaux/tableau_jpn.html"
fi

echo "
<html>
<head>
	<meta charset=\"UTF-8\">
    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css\">
    <title>Tableau JPN</title>
</head>
<body>
	<table class=\"table\">
        <tr>
            <th>num</th>
            <th>url</th>
            <th>requête</th>
            <th>encodage</th>
            <th>compte</th>
            <th>contexte</th>
            <th>concordance</th>
        </tr>
">>"../tableaux/tableau_jpn.html"

var=1
while read -r line;
do
	curl -s -o "../aspirations/japonais/jp-$var.html" "$line" #asp
    lynx -dump -nolist "$line" > "../dumps-text/japonais/jp-$var.txt" #dump
    
    grep -A 1 -B 1 --color "食の安全" "../dumps-text/japonais/jp-$var.txt" > "../contextes/japonais/jp-$var.txt"

    echo "
    <html>
    <head>
        <meta charset=\"UTF-8\">
        <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css\">
        <title>Concordance JPN $var</title>
    </head>
    <body>
        <table class=\"table\">
            <tr>
                <th>gauche</th>
                <th>mot</th>
                <th>droite</th>
            </tr>
        ">>"../concordances/japonais/jp-$var.html"
    grep -E -T -i "食の安全" ../contextes/japonais/jp-1.txt | sed -E 's/(.*)(食の安全)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/'>>"../concordances/japonais/jp-$var.html"
    echo "
        </table>
    </body>
    </html>
    ">>"../concordances/japonais/jp-$var.html"
    

    compte=$(grep -c "食の安全" "../dumps-text/japonais/jp-$var.txt")
    code=$(curl -s -I -L -w "%{http_code}" -o /dev/null $line) #$(curl -s -I $line | head -n 1)
	encodage=$(curl -s -I -L -w "%{content_type}" -o /dev/null $line | grep -P -o "charset=\S+" | cut -d "=" -f2) #$(curl -s -I $line | grep "content-type:")
	
    #echo -e "$var\t$line\t$code\t$encodage\t"
	
    echo "
		<tr>
            <td>$var</td>
            <td><a href=\"$line\">$line</a></td>
            <td>$code</td>
            <td>$encodage</td>
            <td>$compte</td>
            <td><a href=\"../contextes/japonais/jp-$var.txt\">contexte</a></td>
            <td><a href=\"../concordances/japonais/jp-$var.html\">contexte</a></td>
        </tr>
	">>"../tableaux/tableau_jpn.html"
	
    
    var=$(expr $var + 1)
done < "../URLs/urls_jpn.txt"

echo "
	</table>
</body>
</html>
">>"../tableaux/tableau_jpn.html"

