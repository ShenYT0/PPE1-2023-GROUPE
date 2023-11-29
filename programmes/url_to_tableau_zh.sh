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
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>tableau chinois</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
    </head>
    <body>

        <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
            <tr>
                <th>numéro</th>
                <th>urls</th>
                <th>code HTTP</th>
                <th>encodage</th>
                <th>HTML</th>
                <th>dump-text</th>
                <th>occurrences</th>
                <th>contextes</th>
            </tr>
" > tableau_zh.html

while read -r URL
do 
    CODE=$(curl -s -I -L -w "%{http_code}" -o /dev/null $URL)
    ENCODAGE=$(curl -s -I -L -w "%{content_type}" -o /dev/null $URL | ggrep -P -o "charset=\S+" | cut -d"=" -f2 | tail -n 1)
    
    ASPIR=$(curl $URL) 
    DUMP=$(w3m $URL) 
    echo "$ASPIR" > ../aspirations/chinois/zh_$lineno.html
    echo "$DUMP" > ../dumps-text/chinois/zh_$lineno.txt 
    
    OCCU=$(cat ../dumps-text/chinois/zh_$lineno.txt | egrep -o "食品安全" | wc -l)
    echo "$lineno\t$URL\t$CODE\t$ENCODAGE\t$OCCU" >> tableaux_zh.txt

    CONTEXTE=$(cat ../dumps-text/chinois/zh_$lineno.txt | egrep -B2 -A2 "食品安全" )
    echo "$CONTEXTE" > ../contextes/chinois/zh_$lineno.txt

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
            </tr>
    " >> tableau_zh.html

    lineno=$(expr $lineno + 1 )
done < "$URLS"

echo "
        </table>
    </body>
</html>
" >> tableau_zh.html
