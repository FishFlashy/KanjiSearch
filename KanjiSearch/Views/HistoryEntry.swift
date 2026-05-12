//
//  HistoryEntry.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/10/26.
//

import SwiftUI

struct HistoryEntryView: View {
    var search: Search
    
    var body: some View {
        let sizeFormat = floor(Double(search.results.count) / 5)
        
        GeometryReader { gr in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color(searchType: search.type).opacity(0.1))
                    .frame(height: gr.size.height)
                VStack(alignment: .leading) {
                    HistoryHeaderView(search: search)
                    HistoryGridView(search: search)
                }.padding()
            }
        }
        .frame(height: 130 + (70 * CGFloat(sizeFormat)))
        .padding(.horizontal)
    }
}

struct HistoryHeaderView: View {
    var search: Search
    
    var body: some View {
        HStack{
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color(searchType: search.type))
                    .frame(width: 150)
                Text("\(search.type.rawValue)")
                    .foregroundStyle(.white)
                    .bold()
            }
            Text("\(search.date.formatted())")
                .foregroundStyle(.gray)
            Spacer()
        }
    }
}

struct HistoryGridView: View {
    var search: Search
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<search.results.count, id:\.self) { i in
                KanjiBoxView(kanjiCharacter: search.results[i].character, boxColor: Color(searchType: search.type).opacity(0.7)).frame(height: 80)
            }
        }
    }
}

#Preview {
    HistoryEntryView(search: SampleResults.scanSearch)
}
