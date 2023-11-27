#!/bin/bash

echo "
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
        </tr>
">>"../tableaux/tableau_jpn.html"

var=1
while read -r line;
do
	code=$(curl -s -I -L -w "%{http_code}" -o /dev/null $line) #$(curl -s -I $line | head -n 1)
	encodage=$(curl -s -I -L -w "%{content_type}" -o /dev/null $line | grep -P -o "charset=\S+" | cut -d "=" -f2) #$(curl -s -I $line | grep "content-type:")
	#echo -e "$var\t$line\t$code\t$encodage\t"
	echo "
		<tr>
            <td>$var</td>
            <td><a href=\"$line\">$line</a></td>
            <td>$code</td>
            <td>$encodage</td>
        </tr>
	">>"../tableaux/tableau_jpn.html"
	

    curl $line > "../aspirations/jp-$var.html"
    lynx -dump -nolist "$line" > "..//jp-$var.txt"

    var=$(expr $var + 1)
done < "../URLs/test.txt"

echo "
	</table>
</body>
</html>
">>"../tableaux/tableau_jpn.html"