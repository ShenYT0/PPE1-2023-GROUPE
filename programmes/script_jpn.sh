#!/bin/bash

if [ -f "../tableaux/tableau_jpn.html" ];
then
    rm "../tableaux/tableau_jpn.html"
fi

echo "
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
">>"../tableaux/tableau_jpn.html"

var=1
while read -r line;
do
    if [ -f "../concordances/japonais/jp-$var.html" ];
    then
        rm "../concordances/japonais/jp-$var.html"
    fi


    code=$(curl -s -L -w "%{http_code}" -o "../aspirations/japonais/jp-$var.html" $line) #$(curl -s -I $line | head -n 1)
	encodage=$(curl -s -I -L -w "%{content_type}" -o /dev/null $line | grep -P -o "charset=\S+" | cut -d "=" -f2) #$(curl -s -I $line | grep "content-type:")

    #curl -s -o "../aspirations/japonais/jp-$var.html" "$line" #asp
    dump="NA"

    if [ $code == "200" ] #-eq 200
    then
        lynx -dump -nolist "../aspirations/japonais/jp-$var.html" > "../dumps-text/japonais/tmp.txt" #dump
        cat "../dumps-text/japonais/tmp.txt" | python3 ./tokenize_japanese.py > "../dumps-text/japonais/jp-$var.txt"
        rm "../dumps-text/japonais/tmp.txt"
        compte=$(grep -i -o "食 の 安全" "../dumps-text/japonais/jp-$var.txt" | wc -l)
        dump="<a href=\"../dumps-text/japonais/jp-$var.txt\">dump-text</a>"

        grep -i -C 3 "食 の 安全" "../dumps-text/japonais/jp-$var.txt" > "../contextes/japonais/jp-$var.txt"
        #grep -A 1 -B 1 --color "食の安全" "../dumps-text/japonais/jp-$var.txt" > "../contextes/japonais/jp-$var.txt"
        contexte="<a href=\"../contextes/japonais/jp-$var.txt\">contexte</a>"

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
        
        # grep -E -T -i "食 の 安全" ../contextes/japonais/jp-$var.txt | sed -E 's/(.*)(食 の 安全)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/'>>"../concordances/japonais/jp-$var.html"
        grep -i -P "(\w+\W){0,5}食 の 安全(\w+\W){0,5}" ../contextes/japonais/jp-$var.txt | sed -E 's/(.*)(食 の 安全)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/'>>"../concordances/japonais/jp-$var.html"
        echo "
            </table>
            </body>
            </html>
            ">>"../concordances/japonais/jp-$var.html"
        concordance="<a href=\"../concordances/japonais/jp-$var.html\">concordance</a>"
    else
        compte=""
        contexte=""
        concordance=""
    fi
	
    #echo -e "$var\t$line\t$code\t$encodage\t"
	
    echo "
		<tr>
            <td>$var</td>
            <td><a href=\"$line\">$line</a></td>
            <td>$code</td>
            <td>$encodage</td>
            <td><a href=\"../aspirations/japonais/jp-$var.html\">aspiration</a></td>
            <td>$dump</td>
            <td>$compte</td>
            <td>$contexte</td>
            <td>$concordance</td>
        </tr>
	">>"../tableaux/tableau_jpn.html"
	
    
    var=$(expr $var + 1)
done < "../URLs/urls_jpn.txt"

echo "
	</table>
    </div>
</body>
</html>
">>"../tableaux/tableau_jpn.html"

