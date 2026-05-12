//
//  Sampler.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/15/26.
//

import Foundation

//MARK: Preview Samples
struct Sample {
    static let day = Kanji(character: "日",
                           readings: [Reading(part: "ひ", type: .kun),
                                      Reading(part: "-び", type: .kun),
                                      Reading(part: "-か", type: .kun),
                                      Reading(part: "ニチ", type: .on),
                                      Reading(part: "ジツ", type: .on)],
                           meanings: ["day", "sun", "Japan", "counter for days"],
                           radicals: [],
                           vocab: [])
    
    static let year = Kanji(character: "年",
                            readings: [Reading(part: "とし", type: .kun),
                                       Reading(part: "ネン", type: .on)],
                            meanings: ["year", "counter for years"],
                            radicals: [],
                            vocab: [])
    
    static let tome = Kanji(character: "冊",
                            readings: [Reading(part: "くみ", type: .kun),
                                       Reading(part: "サツ", type: .on),
                                       Reading(part: "サク", type: .on)],
                            meanings: ["tome", "counter for books", "volume"],
                            radicals: [],
                            vocab: [])
    
    static let fee = Kanji(character: "料",
                           readings: [Reading(part: "リョウ", type: .on)],
                           meanings: ["fee", "materials"],
                           radicals: [],
                           vocab: [])
    
    static let logic = Kanji(character: "理",
                              readings: [Reading(part: "ことわり", type: .kun),
                                         Reading(part: "リ", type: .on)],
                              meanings: ["logic", "arrangement", "reason", "justice", "truth"],
                             radicals: [],
                             vocab: [Vocab(word: "料理",
                                           reading: "りょうり",
                                           meanings: ["cooking"],
                                           type: .on)])
    
    static let cooking = Vocab(word: "料理",
                               reading: "りょうり",
                               meanings: ["cooking"],
                               type: .on)
}

struct SampleResults {
    static let findSearch = Search(results: [Sample.tome], type: .find, date: Date.now)
    static let drawSearch = Search(results: [Sample.year], type: .draw, date: Date.now)
    static let scanSearch = Search(results: [Sample.fee, Sample.logic], type: .scan, date: Date.now)
}
