//
//  KanjiSearchApp.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/5/26.
//

import SwiftUI
import SwiftData

@main
struct KanjiSearchApp: App {
    @State var networkManager = NetworkManager()
    @State var searchManager = SearchManager()
    @State var drawManager = DrawManager()
    @State var scanManager = ScanManager()
    
    var body: some Scene {
        WindowGroup {
            MainPageView()
                .environment(networkManager)
                .environment(searchManager)
                .environment(drawManager)
                .environment(scanManager)
                .modelContainer(for: Search.self)
        }
    }
}
