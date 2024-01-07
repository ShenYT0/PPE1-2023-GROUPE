#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jan  6 23:31:17 2024

@author: arthurzhang
"""

from os import chdir
chdir("/Users/arthurzhang/Cours_de_TAL/projet_encadre/PPE1-2023-GROUPE/programmes")


# 读取停用词列表
with open('stopwords-fr.txt', 'r') as file:
    stopwords = set([line.strip() for line in file if line.strip() != ''])

# 读取分词结果
with open('../itrameur/contexte-fr.txt', 'r', encoding='macroman') as file:
    words = file.read().split()

# 移除停用词
filtered_words = [word for word in words if word not in stopwords]

with open('../itrameur/contextes_fr_stop.txt', 'w') as file:
    for word in filtered_words:
        file.write(word + " ")