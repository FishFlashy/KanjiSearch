//
//  HistoryTab.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/10/26.
//

import SwiftUI
import SwiftData

struct HistoryTabView: View {
    @State var isEditing: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                PageTitleView(text: "History")
                HStack {
                    Spacer()
                    if isEditing {
                        ClearAllButton(isEditing: $isEditing)
                    }
                    EditButton(isEditing: $isEditing)
                }.padding()
                HistoryScrollView(isEditing: $isEditing)
            }
        }
    }
}

struct EditButton: View {
    @Binding var isEditing: Bool
    
    var body: some View {
        Button {
            isEditing.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white.opacity(0))
                    .glassEffect(in: .rect(cornerRadius: 20))
                Text(isEditing ? "Done" : "Edit")
                    .foregroundStyle(.black)
            }
        }.frame(width: 100, height: 40)
    }
}

struct ClearAllButton: View {
    @Query(sort: \Search.date, order: .reverse) private var searchList: [Search]
    @Environment(\.modelContext) private var context
    
    @Binding var isEditing: Bool
    
    var body: some View {
        Button {
            do {
                try context.delete(model: Search.self)
            }
            catch {
                print("Clear All Error")
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white.opacity(0))
                    .glassEffect(in: .rect(cornerRadius: 20))
                Text("Clear All")
                    .foregroundStyle(.red)
            }
        }.frame(width: 100, height: 40)
    }
}

struct HistoryScrollView: View {
    @Query(sort: \Search.date, order: .reverse) private var searchList: [Search]
    @Environment(\.modelContext) private var context
    
    @Binding var isEditing: Bool
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                if searchList.count > 0 {
                    ForEach(searchList, id:\.self) { search in
                        ZStack {
                            NavigationLink {
                                if search.results.count == 1 {
                                    InfoPageView(kanji: search.results[0], searchType: search.type)
                                }
                                else {
                                    ResultsPageView(kanjiList: search.results)
                                }
                            } label: {
                                HistoryEntryView(search: search)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(isEditing ? 0.8 : 1)
                            .disabled(isEditing)
                            
                            if isEditing {
                                VStack {
                                    HStack() {
                                        Spacer()
                                        Button {
                                            context.delete(search)
                                        } label: {
                                            ZStack {
                                                Circle()
                                                    .foregroundStyle(.red)
                                                    .aspectRatio(1, contentMode: .fit)
                                                    .frame(width: 30)
                                                Image(systemName: "trash")
                                                    .foregroundStyle(.white)
                                            }.padding()
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                else {
                    Text("No History Entries")
                        .opacity(0.5)
                }
            }
        }
    }
}

#Preview {
    HistoryTabView()
}
