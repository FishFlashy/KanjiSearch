//
//  Drawing.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/24/26.
//

import Foundation

struct Line: Codable, Hashable {
    var points: [CGPoint]
}

struct BoundingBox: Hashable {
    var x: Float = 0
    var y: Float = 0
    var width: Float = 0
    var height: Float = 0
}

