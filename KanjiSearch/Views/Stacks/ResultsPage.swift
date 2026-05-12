//
//  ResultsPage.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/9/26.
//

import SwiftUI

struct ResultsPageView: View {
    @Environment(NetworkManager.self) var networkManager
    @Environment(SearchManager.self) var searchManager
    
    @State var filter = ""
    
    var kanjiList: [Kanji]
    
    var body: some View {
        var filteredList: [Kanji] {
            //TODO: Later on, add functionality such that either hiragana or katakana could be used to find readings of either type!
            
            if filter != "" {
                if (searchManager.isHiragana(char: filter.first!)) || (searchManager.isKatakana(char: filter.first!)) {
                    return kanjiList.filter { kanji in
                        kanji.readings.contains(where: {$0.part.localizedCaseInsensitiveContains(filter)})
                    }
                }
                else if filter.first!.isLetter {
                    return kanjiList.filter { kanji in
                        kanji.meanings.contains(where: {$0.localizedCaseInsensitiveContains(filter)})
                    }
                }
                else {
                    return kanjiList.filter { kanji in
                        kanji.character == filter
                    }
                }
            }
            return kanjiList
        }
        
        NavigationView {
            VStack {
                PageTitleView(text: "Results")
                ResultsTextBoxView(textInput: $filter)
                ResultScrollView(kanjiList: filteredList)
            }
        }
    }
}

struct ResultScrollView: View {
    var kanjiList: [Kanji]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(0..<kanjiList.count, id:\.self) { i in
                    NavigationLink {
                        InfoPageView(kanji: kanjiList[i], searchType: .scan)
                    } label: {
                        EntryView(kanji: kanjiList[i], boxColor: Color(searchType: .scan))
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct ResultsTextBoxView: View {
    @Binding var textInput : String
    
    var body: some View {
        ZStack {
            HStack {
                Spacer().frame(maxWidth: 20)
                TextField("Search for a Result", text: $textInput)
                    .disableAutocorrection(true)
                    .frame(minHeight: 50)
                    .textInputAutocapitalization(.never)
                Spacer().frame(maxWidth: 20)
            }
        }
        .glassEffect(in: .rect(cornerRadius: 20))
    }
}

#Preview {
    ResultsPageView(kanjiList: [Sample.fee, Sample.logic])
        .environment(NetworkManager())
        .environment(SearchManager())
}
