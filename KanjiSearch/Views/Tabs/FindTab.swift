//
//  FindTab.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/9/26.
//

import SwiftUI
import SwiftData

struct FindTabView: View {
    @Environment(NetworkManager.self) var networkManager
    @Environment(SearchManager.self) var searchManager
    
    @State var textInput = ""
    
    var kanjiList: [Kanji]
    
    var body: some View {
        NavigationView {
            VStack {
                PageTitleView(text: "Find")
                HStack {
                    FindTextBoxView(textInput: $textInput)
                    FindButtonView(textInput: $textInput)
                }
                FindScrollView(kanjiList: kanjiList)
            }
        }
    }
}

struct FindScrollView: View {
    @Environment(SearchManager.self) var searchManager
    
    @Query private var searchList: [Search]
    @Environment(\.modelContext) private var context
    
    var kanjiList: [Kanji]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(0..<kanjiList.count, id:\.self) { i in
                    NavigationLink {
                        InfoPageView(kanji: kanjiList[i], searchType: .find)
                            .onAppear {
                                if searchList.contains(where: {($0.results == searchManager.findList) && ($0.type == .find)}) {
                                    let foundIndex: Int = searchList.firstIndex(where: {($0.results == searchManager.findList) && ($0.type == .find)})!
                                    searchList[foundIndex].date = Date.now
                                }
                                else {
                                    context.insert(Search(results: searchManager.findList, type: .find))
                                }
                            }
                    } label: {
                        EntryView(kanji: kanjiList[i], boxColor: Color(searchType: .find).opacity(0.7))
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct FindTextBoxView: View {
    @Binding var textInput: String
    
    var body: some View {
        ZStack {
            HStack {
                Spacer().frame(maxWidth: 20)
                TextField("Directly Search a Kanji Character", text: $textInput)
                    .disableAutocorrection(true)
                    .frame(minHeight: 50)
                    .textInputAutocapitalization(.never)
                Spacer().frame(maxWidth: 20)
            }
        }
        .glassEffect(in: .rect(cornerRadius: 20))
    }
}

struct FindButtonView: View {
    @Environment(NetworkManager.self) var networkManager
    @Environment(SearchManager.self) var searchManager
    
    @Binding var textInput: String
    
    var body: some View {
        Button {
            searchManager.kanjiCharacterFind(kanjiCharacter: textInput, searchType: .find)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white.opacity(0))
                    .frame(maxWidth: 50, maxHeight: 50)
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.black)
            }.glassEffect(in: .rect(cornerRadius: 20))
        }
    }
}

#Preview {
    FindTabView(kanjiList: [Sample.day, Sample.year, Sample.tome])
        .environment(NetworkManager())
        .environment(SearchManager())
}



