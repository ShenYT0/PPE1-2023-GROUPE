def remplaceMot(source, destination) :
    with open(source) as s :
        content = s.read()
    modified_content = content.replace('食品 安全', '食品安全')
    modified_content = modified_content.replace('食 の 安全', '食の安全')
    modified_content = modified_content.replace('食品 の 安全', '食品の安全')
    with open(destination, 'w') as d :
        d.write(modified_content)

def main():
    remplaceMot("../itrameur/contextes-japonais.txt", "../itrameur/Pretraitements_jpn/contextes-jpn_tok_col.txt")

if __name__ == "__main__":
    main()