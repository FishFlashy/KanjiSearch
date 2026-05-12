# - Setup Instructions -
#1. Activate your virtual environment
#2. Install "jisho_api"
#3. Install "fastapi[standard]"
#4. Run kanji.py on FastAPI

#NOTE: When using pip install for "fastapi[standard]" and "jisho_api",
#always install "jisho_api" BEFORE "fastapi[standard]"! Of the two, FastAPI demands the more recent versions of
#rich and pydantic, and the virtual environement hosts the only the versions of these dependencies from the
#most recent "install" call!

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from jisho_api.kanji import Kanji as KanjiLookup

app = FastAPI()

class Kanji(BaseModel):
    character: str
    readings: list[Reading]
    meanings: list[str]
    radicals: list[str] 
    vocab: list[Vocab]

class Reading(BaseModel):
    part: str
    type: str

class Vocab(BaseModel):
    word: str
    reading: str
    meanings: list[str]
    type: str

@app.get("/kanji/character/{character}", response_model = Kanji)
async def byCharacterSearch(character: str):
    k = KanjiLookup.request(character)
    if k is None:
        raise HTTPException(status_code=404, detail="Kanji Not Found")
    
    itemCharacter = k.data.kanji
    itemMeanings = k.data.main_meanings or []
    itemRadicals = k.data.radical.alt_forms or []

    itemReadings = []

    kunReadingCheck = k.data.main_readings.kun or []
    for kunReading in kunReadingCheck:
        itemReadings.append(Reading(part=kunReading, type="Kunyomi"))
    onReadingCheck = k.data.main_readings.on or []
    for onReading in onReadingCheck:
        itemReadings.append(Reading(part=onReading, type="Onyomi"))

    itemVocab = []

    kunVocabCheck = k.data.reading_examples.kun or []
    for kunVocab in kunVocabCheck:
        itemVocab.append(Vocab(word=kunVocab.kanji, reading=kunVocab.reading, meanings=kunVocab.meanings, type="Kunyomi"))
    onVocabCheck = k.data.reading_examples.on or []
    for onVocab in onVocabCheck:
        itemVocab.append(Vocab(word=onVocab.kanji, reading=onVocab.reading, meanings=onVocab.meanings, type="Onyomi"))

    itemKanji = Kanji(character=itemCharacter, readings=itemReadings, meanings=itemMeanings, radicals=itemRadicals, vocab=itemVocab)
    return itemKanji
    
@app.get("kanji/text/{text}")
async def byMeaningSearch(input: str):
    #YOU ARE HERE
    return -1