//
//  MainPage.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/10/26.
//

import SwiftUI
import SwiftData

struct MainPageView: View {
    @Environment(NetworkManager.self) var networkManager
    @Environment(SearchManager.self) var searchManager
    @Environment(DrawManager.self) var drawManager
    @Environment(ScanManager.self) var scanManager
    
    @Query(sort: \Search.date, order: .reverse) private var searchList: [Search]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        TabView() {
            Tab("History", systemImage: "clock") {
                HistoryTabView()
            }
            Tab("Find", systemImage: "magnifyingglass") {
                FindTabView(kanjiList: searchManager.findList)
            }
            Tab("Draw", systemImage: "square.and.pencil") {
                DrawTabView()
            }
            Tab("Scan", systemImage: "camera") {
                ScanTabView()
            }
        }
    }
}

struct PageTitleView: View {
    var text: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text(text)
                .font(.system(size: 50, weight: .bold))
        }
        .frame(height: 50)
    }
}

#Preview {
    MainPageView()
        .environment(NetworkManager())
        .environment(SearchManager())
        .environment(DrawManager())
        .environment(ScanManager())
}
