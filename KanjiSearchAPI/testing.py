#Used for testing configurations from Jisho API

from jisho_api.kanji import Kanji
k = Kanji.request('日')

"""
print(k.data.kanji)
print()
print(k.data.main_meanings)
print()
print(k.data.main_readings.kun)
print()
print(k.data.main_readings.on)
print()
print(k.data.radical.alt_forms)
print()
print(k.data.reading_examples)
"""

for example in k.data.reading_examples.kun:
    print(example)
    print()
for example in k.data.reading_examples.on:
    print(example)
    print()

from jisho_api.tokenize import Tokens
t = Tokens.request('昨日すき焼きを食べました')

from jisho_api.sentence import Sentence
s = Sentence.request('水')


