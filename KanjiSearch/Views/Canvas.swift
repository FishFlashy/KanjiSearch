//
//  Canvas.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/24/26.
//

import SwiftUI

struct FreeformLine: Shape {
    let points: [CGPoint]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard let firstPoint = points.first else { return path }
        
        path.move(to: firstPoint)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        
        return path
    }
}

struct FreeformDrawing: Shape {
    let drawing: [Line]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for line in drawing {
            let points = line.points
            
            var part = Path()
            
            guard let firstPoint = points.first else { return path }
            
            part.move(to: firstPoint)
            for point in points.dropFirst() {
                part.addLine(to: point)
            }
            
            path.addPath(part)
        }
        
        return path
    }
}
