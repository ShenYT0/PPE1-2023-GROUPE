#ce script vise à éliminer les stopwords du fichier "contextes-japonais_tok_col.txt"
def main():
    with open('../itrameur/Pretraitements_jpn/stopwords-ja.txt', 'r', encoding='utf-8') as file:
        stopwords = set([line.strip() for line in file if line.strip() != ''])

    with open('../itrameur/Pretraitements_jpn/contextes-jpn_tok_col.txt', 'r', encoding='utf-8') as file:
        words = file.read().split()

    filtered_words = [word for word in words if word not in stopwords]

    with open('../itrameur/Pretraitements_jpn/contextes-jpn_stop.txt', 'w', encoding='utf-8') as file:
        for word in filtered_words:
            file.write(word + " ")  


    with open('../img/Analyse_jpn/nuageWord.txt', 'r', encoding='utf-8') as file:
        words_n = file.read().split()

    filtered_words_n = [word for word in words_n if word not in stopwords]

    with open('../img/Analyse_jpn/nuageWord_stop.txt', 'w', encoding='utf-8') as file:
        for word in filtered_words_n:
            file.write(word + " ")  
    # wordcloud_cli --text ..\img\Analyse_jpn\nuageWord_stop.txt --mask ../img/Analyse_jpn/fishMask.jpg --background white --color orange --imagefile nuage_jpn.png --fontfile ../img/Analyse_jpn/fontJPN.otf

if __name__ == "__main__":
    main()