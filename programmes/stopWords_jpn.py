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

if __name__ == "__main__":
    main()