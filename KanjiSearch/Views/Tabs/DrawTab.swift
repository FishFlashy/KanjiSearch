//
//  DrawTab.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/10/26.
//

import SwiftUI
import SwiftData

struct DrawTabView: View {
    @Environment(DrawManager.self) var drawManager
    @Environment(SearchManager.self) var searchManager
    
    var body: some View {
        NavigationView {
            VStack {
                PageTitleView(text: "Draw")
                DrawCanvasView()
                HStack {
                    DrawOptionButtonView(option: "Undo", image: "arrow.counterclockwise")
                    DrawOptionButtonView(option: "Reset", image: "trash")
                    DrawLookupButtonView()
                }.padding(.horizontal)
                Spacer()
                DrawFoundView()
            }
        }
    }
}

struct DrawCanvasView: View {
    @Environment(DrawManager.self) var drawManager
    
    @State private var currentPoints: [CGPoint] = []
    
    var body: some View {
        GeometryReader { gr in
            let dragGesture = DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let xCheck = (value.location.x > gr.frame(in: .global).minX-55) && (value.location.x < gr.frame(in: .global).maxX-55)
                    let yCheck = (value.location.y > gr.frame(in:.global).minY-130) && (value.location.y < gr.frame(in: .global).maxY-130)
                    if xCheck && yCheck {
                        currentPoints.append(value.location)
                    }
                }
                .onEnded { value in
                    let newLine = Line(points: currentPoints)
                    
                    drawManager.drawing.append(newLine)
                    currentPoints.removeAll()
                }
            
            ZStack {
                Rectangle()
                    .foregroundStyle(.black)
                Rectangle()
                    .foregroundStyle(.white)
                    .frame(width: gr.size.width * 0.95, height: gr.size.height * 0.95)
                Rectangle()
                    .foregroundStyle(.gray)
                    .frame(width: 1, height: gr.size.height * 0.95)
                Rectangle()
                    .foregroundStyle(.gray)
                    .frame(width: gr.size.width * 0.95, height: 1)
                
                FreeformDrawing(drawing: drawManager.drawing)
                    .stroke(Color(searchType: .draw), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                if currentPoints.count >= 1 {
                    FreeformLine(points: currentPoints)
                        .stroke(Color(searchType: .draw), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                }
            }.gesture(dragGesture)
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(width: 300, height: 300)
        .padding()
    }
}

struct DrawOptionButtonView: View {
    @Environment(DrawManager.self) var drawManager
    
    var option: String
    var image: String
    
    var body: some View {
        Button {
            if option == "Undo" {
                drawManager.undoDrawing()
            }
            if option == "Reset" {
                drawManager.resetDrawing()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white.opacity(0))
                    .glassEffect(in: .rect(cornerRadius: 20))
                Image(systemName: image)
                    .foregroundStyle(.black)
            }
        }.frame(width: 80, height: 80)
    }
}

struct DrawLookupButtonView: View {
    @Environment(DrawManager.self) var drawManager
    
    var body: some View {
        ZStack {
            Button {
                let renderer = ImageRenderer(content: fromDrawing())
                if let drawingImage = renderer.cgImage {
                    drawManager.interpretDrawing(drawingImage: drawingImage)
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white.opacity(0))
                        .glassEffect(in: .rect(cornerRadius: 20))
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.black)
                }
            }.frame(width: 160, height: 80)
        }
    }
    
    func fromDrawing() -> some View {
        FreeformDrawing(drawing: drawManager.drawing)
            .stroke(Color(searchType: .draw), style: StrokeStyle(lineWidth: 8, lineCap: .round)).frame(width: 300, height: 300)
    }
}

struct DrawFoundView: View {
    @Environment(DrawManager.self) var drawManager
    @Environment(SearchManager.self) var searchManager
    
    var body: some View {
        VStack {
            if drawManager.foundKanji != "" {
                DrawInfoButtonView()
                    .onAppear {
                        searchManager.kanjiCharacterFind(kanjiCharacter: drawManager.foundKanji, searchType: .draw)
                    }
            }
            else {
                ZStack {
                    Text("(No Kanji Found)")
                }
            }
        }
        .padding()
        .frame(minWidth: 200, minHeight: 200)
    }
}

struct DrawInfoButtonView: View {
    @Environment(DrawManager.self) var drawManager
    @Environment(SearchManager.self) var searchManager
    
    @Query private var searchList: [Search]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationLink {
            if searchManager.drawList.count > 0 {
                InfoPageView(kanji: searchManager.drawList[0], searchType: .draw)
                    .onAppear {
                        if searchList.contains(where: {($0.results == searchManager.drawList) && ($0.type == .draw)}) {
                            let foundIndex: Int = searchList.firstIndex(where: {($0.results == searchManager.drawList) && ($0.type == .draw)})!
                            searchList[foundIndex].date = Date.now
                        }
                        else {
                            context.insert(Search(results: searchManager.drawList, type: .draw))
                        }
                    }
            }
        } label: {
            KanjiBoxView(kanjiCharacter: drawManager.foundKanji, boxColor: Color(searchType: .draw))
                .frame(maxHeight: 150)
        }
    }
}

#Preview {
    DrawTabView()
        .environment(DrawManager())
        .environment(SearchManager())
        .environment(NetworkManager())
}
