#!/usr/bin/env bash

URLS=$1
lineno=1

if [ ! -f $URLS ]
then
    echo "On a besoins d'un fichier comme argument."
    exit
fi 

echo "

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css\" rel=\"stylesheet\" integrity=\"sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN\" crossorigin=\"anonymous\">
        <script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js\" integrity=\"sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL\" crossorigin=\"anonymous\"></script>
        <title>tableau chinois</title>
    </head>
    <body>

        <div class="table-responsive">
            <table class=\"table table-info table-hover table-sm\">
                <tr>
                    <th>numéro</th>
                    <th>urls</th>
                    <th>code HTTP</th>
                    <th>encodage</th>
                    <th>HTML</th>
                    <th>dump-text</th>
                    <th>occurrences</th>
                    <th>contextes</th>
                    <th>concordances</th>
                </tr>
" > tableau_zh.html

while read -r URL
do 
    CODE=$(curl -s -I -L -w "%{http_code}" -o /dev/null $URL)
    #ENCODAGE=$(curl -s -I -L -w "%{content_type}" -o /dev/null $URL | ggrep -P -o "charset=\S+" | cut -d"=" -f2 | tail -n 1)
    
    ASPIR=$(curl $URL) 
    DUMP=$(w3m $URL) 
    echo "$ASPIR" > ../aspirations/chinois/zh_$lineno.html
    echo "$DUMP" > ../dumps-text/chinois/zh_$lineno.txt 
    
    ENCODAGE=$(curl -s -I -L -w "%{content_type}" -o /dev/null $URL)
    if [ "$ENCODAGE" = "text/html" ]
    then
        ENCODAGE=$(ggrep -P -o "charset=\S+" ../aspirations/chinois/zh_$lineno.html | sort | uniq | tail -n 1 | cut -d"=" -f2 | cut -d"\"" -f1 | tail -n 1)
        if [ ! $ENCODAGE ]
        then
            ENCODAGE=$()
            ENCODAGE=$(ggrep -P -o "charset=\S+" ../aspirations/chinois/zh_$lineno.html | sort | uniq | tail -n 1 | cut -d"=" -f2 | cut -d"\"" -f2 | cut -d"\"" -f1)
        fi 
    else
        ENCODAGE=$(echo $ENCODAGE | ggrep -P -o "charset=\S+" | cut -d"=" -f2 | tail -n 1)
    fi

    OCCU=$(cat ../dumps-text/chinois/zh_$lineno.txt | egrep -o "食品安全" | wc -l)
    echo "$lineno\t$URL\t$CODE\t$ENCODAGE\t$OCCU" >> tableaux_zh.txt

    CONTEXTE=$(cat ../dumps-text/chinois/zh_$lineno.txt | egrep -B2 -A2 "食品安全" )
    echo "$CONTEXTE" > ../contextes/chinois/zh_$lineno.txt

    echo "
        <html>
            <head>
              <meta charset=\"utf-8\">
		        <meta name="viewport" content="width=device-width, initial-scale=1">
		        <title>Concordances</title>
		        <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css\">
	        </head>
		    <body>
			    <table class=\"table\">
				    <tr>
				        <th>gauche</th>
					    <th>cible</th>
					    <th>droite</th>
				    </tr>
	    " > ../concordances/chinois/zh_$lineno.html

    ggrep -E -T -i "食品安全" ../contextes/chinois/zh_$lineno.txt | sed -E "s/(.*)(食品安全)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/">>"../concordances/chinois/zh_$lineno.html"
    echo "
                </table>
            </body>
        </html>
        " >> ../concordances/chinois/zh_$lineno.html


    echo "
            <tr>
                <td>$lineno</td>
                <td><a href="$URL">$URL</a></td>
                <td>$CODE</td>
                <td>$ENCODAGE</td>
                <td><a href="../aspirations/chinois/zh_$lineno.html">html</a></td>
                <td><a href="../dumps-text/chinois/zh_$lineno.txt">text</a></td>
                <td>$OCCU</td>
                <td><a href="../contextes/chinois/zh_$lineno.txt">contexte</a></td>
                <td><a href="../concordances/chinois/zh_$lineno.html">condordances</a></td>
            </tr>
    " >> tableau_zh.html

    lineno=$(expr $lineno + 1 )
done < "$URLS"

echo "
            </table>
        </div>
    </body>
</html>
" >> tableau_zh.html
