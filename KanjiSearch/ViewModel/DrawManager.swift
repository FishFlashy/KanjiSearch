//
//  DrawManager.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/24/26.
//

import Foundation
import Vision

@Observable
class DrawManager {
    var drawing: [Line] = []
    var foundKanji = "" {
        didSet {
            if foundKanji.count > 1 {
                foundKanji = String(foundKanji.first!)
            }
            if (foundKanji.count == 1) && (isKanji(char: foundKanji.first!) == false) {
                foundKanji = ""
            }
        }
    }
    
    func undoDrawing() {
        if drawing.count > 0 {
            drawing.removeLast()
        }
    }
    
    func resetDrawing() {
        drawing = []
    }
    
    func isKanji(char: Character) -> Bool {
        if (char.isUppercase) || (char.isLowercase) || (char.isNumber) {
            return false
        }
        let code = char.unicodeScalars.map({ $0.value })
        if code != [] {
            if(code[0] >= UInt32(12353)) && (code[0] <= UInt32(12447)) {
                return false
            }
            if (code[0] >= UInt32(12448)) && (code[0] <= UInt32(12543)) {
                return false
            }
        }
        return true
    }
    
    func interpretDrawing(drawingImage: CGImage) {
        let requestHandler = VNImageRequestHandler(cgImage: drawingImage)
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        
        request.recognitionLanguages = ["ja-JP"]
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
        
        if observations.count > 0 {
            foundKanji = observations[0].topCandidates(1).first?.string ?? ""
        }
        else {
            foundKanji = ""
        }
    }
}
