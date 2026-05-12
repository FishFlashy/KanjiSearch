//
//  Kanji.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/5/26.
//

import Foundation
import SwiftData

//MARK: Reading
enum ReadingType: String, Codable, Identifiable, CaseIterable {
    var id: String { self.rawValue }
    
    case on = "Onyomi"
    case kun = "Kunyomi"
}

struct Reading: Codable {
    var part: String
    var type: ReadingType
}

//MARK: Kanji
struct Kanji: Codable, Equatable {
    var character: String
    var readings: [Reading]
    var meanings: [String]
    var radicals: [String]
    var vocab: [Vocab]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.character = try container.decode(String.self, forKey: .character)
        self.readings = try container.decode([Reading].self, forKey: .readings)
        self.meanings = try container.decode([String].self, forKey: .meanings)
        self.radicals = try container.decode([String].self, forKey: .radicals)
        self.vocab = try container.decode([Vocab].self, forKey: .vocab)
    }
    
    init(character: String, readings: [Reading], meanings: [String], radicals: [String], vocab: [Vocab]) {
        self.character = character
        self.readings = readings
        self.meanings = meanings
        self.radicals = radicals
        self.vocab = vocab
    }
    
    func meaningText() -> String {
        var text = ""
        for meaning in meanings {
            text += "\(meaning), "
        }
        if text.count > 1 {
            text.removeLast(2)
        }
        return text
    }
    
    func readingText(type: ReadingType) -> String {
        var text = ""
        for reading in readings.filter({$0.type == type}) {
            text += "\(reading.part)、"
        }
        if text.count > 0 {
            text.removeLast(1)
        }
        return text
    }
    
    func radicalText() -> String {
        var text = ""
        for radical in radicals {
            text += "\(radical)、"
        }
        if text.count > 0 {
            text.removeLast(1)
        }
        return text
    }
    
    static func == (lhs: Kanji, rhs: Kanji) -> Bool {
        return
            lhs.character == rhs.character
    }
}

//MARK: Vocab
struct Vocab: Codable {
    var word: String
    var reading: String
    var meanings: [String]
    var type: ReadingType
    
    func meaningText() -> String {
        var text = ""
        for meaning in meanings {
            text += "\(meaning), "
        }
        if text.count > 1 {
            text.removeLast(2)
        }
        return text
    }
}

//MARK: Search
enum SearchType: String, Codable, Identifiable, CaseIterable {
    var id: String { self.rawValue }
    
    case find = "From Find"
    case scan = "From Scan"
    case draw = "From Draw"
}

@Model
class Search : Identifiable {
    var id: UUID
    var results: [Kanji]
    var type: SearchType
    var date: Date
    
    init(id: UUID = UUID(), results: [Kanji], type: SearchType, date: Date = Date.now) {
        self.id = id
        self.results = results
        self.type = type
        self.date = date
    }
}
