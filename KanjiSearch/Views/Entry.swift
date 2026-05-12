//
//  Entry.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/9/26.
//

import SwiftUI

struct EntryView: View {
    var kanji: Kanji
    var boxColor: Color
    
    var body: some View {
        GeometryReader { gr in
            ZStack {
                HStack {
                    KanjiBoxView(kanjiCharacter: kanji.character, boxColor: boxColor)
                    VStack(alignment: .leading) {
                        Spacer()
                        KanjiPropertyView(kanji: kanji, size: 20, infoType: "Meaning")
                        KanjiPropertyView(kanji: kanji, size: 20, infoType: "Kun-Reading")
                        KanjiPropertyView(kanji: kanji, size: 20, infoType: "On-Reading")
                    }
                }
            }
        }
        .frame(height: 60)
        .padding()
    }
}

struct KanjiBoxView: View {
    var kanjiCharacter: String
    var boxColor: Color
    
    var body: some View {
        GeometryReader { gr in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(boxColor)
                Text(kanjiCharacter)
                    .font(.system(size: gr.size.width))
                    .foregroundStyle(.white)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct KanjiPropertyView: View {
    var kanji: Kanji
    var size: Int
    var infoType: String
    
    var body: some View {
        let textSize = CGFloat(size)
        
        if infoType == "Meaning" {
            Text(kanji.meaningText())
                .font(.system(size: textSize))
        }
        if infoType == "Kun-Reading" {
            Text(kanji.readingText(type: .kun))
                .font(.system(size: textSize))
        }
        if infoType == "On-Reading" {
            Text(kanji.readingText(type: .on))
                .font(.system(size: textSize))
        }
    }
}

#Preview {
    EntryView(kanji: Sample.day, boxColor: Color(searchType: .scan))
}
