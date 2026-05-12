//
//  UIColors.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/10/26.
//
import SwiftUI

extension Color {
    init(searchType: SearchType) {
        switch searchType {
        case .find:
            self = Color(red: 51/255, green: 201/255, blue: 84/255)
        case .draw:
            self = Color(red: 51/255, green: 170/255, blue: 201/255)
        case .scan:
            self = Color(red: 153/255, green: 100/255, blue: 209/255)
        }
    }
}
