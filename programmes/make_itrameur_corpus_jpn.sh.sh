#!/bin/bash
# $1 contextes/dumps-text
# $2 japonais

if [ -f "../itrameur/$1-$2.txt" ];
then
    rm "../itrameur/$1-$2.txt"
fi

echo "<lang=\"$2\">" >> "../itrameur/$1-$2.txt"

for file in ../"$1"/"$2"/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        filename_no_ext=$(basename -- "$filename" | cut -f 1 -d '.')
        echo "<page=\"$filename_no_ext\">
        <text>" >> "../itrameur/$1-$2.txt"

        #cat "$file" >>  "../itrameur/$1-$2.txt"
        sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' "$file" >> "../itrameur/$1-$2.txt"

        echo "</text>
        </page> §" >> "../itrameur/$1-$2.txt"
    fi
done

echo "</lang>" >> "../itrameur/$1-$2.txt"

#sed -i -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' "../itrameur/$1-$2.txt"