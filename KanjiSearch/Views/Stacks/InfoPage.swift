//
//  InfoPage.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/9/26.
//

import SwiftUI

struct InfoPageView: View {
    var kanji: Kanji
    var searchType: SearchType
    
    var body: some View {
        VStack {
            PageTitleView(text: "Info")
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    KanjiBoxView(kanjiCharacter: kanji.character, boxColor: Color(searchType: searchType)).frame(height: 100)
                    Spacer(minLength: 40)
                    InfoSectionView(header: "Meanings", text: kanji.meaningText())
                    InfoSectionView(header: "Kun'yomi Readings", text: kanji.readingText(type: .kun))
                    InfoSectionView(header: "On'yomi Readings", text: kanji.readingText(type: .on))
                    InfoSectionView(header: "Radicals", text: kanji.radicalText())
                    VocabSectionView(header: "Kun-Vocab", vocab: kanji.vocab.filter{$0.type == .kun})
                    VocabSectionView(header: "On-Vocab", vocab: kanji.vocab.filter{$0.type == .on})
                    Spacer(minLength: 500)
                }
            }
        }
    }
}

struct InfoSectionView: View {
    var header: String
    var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.gray.opacity(0.1))
            VStack {
                Text(header).bold()
                Text(text == "" ? "N/A" : text)
            }
        }.padding(.horizontal)
    }
}

struct VocabSectionView: View {
    var header: String
    var vocab: [Vocab]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.gray.opacity(0.1))
            VStack {
                Text(header).bold()
                if vocab.count == 0 {
                    Text("N/A")
                }
                else {
                    ForEach(0..<vocab.count, id:\.self) { i in
                        Spacer(minLength: 15)
                        Text("\(vocab[i].word) (\(vocab[i].reading))")
                        Text("\(vocab[i].meaningText())")
                    }
                }
            }
        }.padding(.horizontal)
    }
}

#Preview {
    InfoPageView(kanji: Sample.logic, searchType: .draw)
}
