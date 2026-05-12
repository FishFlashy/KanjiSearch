//
//  SearchManager.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/14/26.
//

import Foundation

@Observable
class SearchManager {
    var findList: [Kanji] = []
    var drawList: [Kanji] = []
    
    var scanList: [Kanji] = []
    var scanIdle: Bool = true
    
    func updateList(newList: [Kanji], searchType: SearchType) {
        if searchType == .find {
            findList = newList
        }
        if searchType == .draw {
            drawList = newList
        }
        if searchType == .scan {
            scanList = newList
        }
    }
    
    func resetList(searchType: SearchType) {
        if searchType == .find {
            findList = []
        }
        if searchType == .draw {
            drawList = []
        }
        if searchType == .scan {
            scanList = []
        }
    }
    
    func isHiragana(char: Character) -> Bool {
        let code = char.unicodeScalars.map({ $0.value })
        if code != [] {
            return code[0] >= UInt32(12353) && code[0] <= UInt32(12447)
        }
        return false
    }
    
    func isKatakana(char: Character) -> Bool {
        let code = char.unicodeScalars.map({ $0.value })
        if code != [] {
            return code[0] >= UInt32(12448) && code[0] <= UInt32(12543)
        }
        return false
    }
    
    func kanjiCharacterFind(kanjiCharacter: String, searchType: SearchType) {
        Task {
            do {
                let networkManager = NetworkManager()
                let foundKanji: Kanji = try await networkManager.byCharacterSearch(character: kanjiCharacter)
                if searchType == .find || searchType == .draw {
                    updateList(newList: [foundKanji], searchType: searchType)
                }
                else {
                    scanList.append(foundKanji)
                }
            } catch {
                print("search error")
                if searchType == .find || searchType == .draw {
                    updateList(newList: [], searchType: searchType)
                }
            }
        }
    }
    
    func kanjiBulkFind(foundKanji: [String]) {
        scanIdle = false
        for kanjiCharacter in foundKanji {
            kanjiCharacterFind(kanjiCharacter: kanjiCharacter, searchType: .scan)
        }
        scanIdle = true
    }
}
