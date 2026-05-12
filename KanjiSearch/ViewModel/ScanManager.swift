//
//  ScanManager.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 5/1/26.
//

import Foundation
import Vision
import UIKit

@Observable
class ScanManager {
    var foundCharacters: [String] = []
    var foundKanji: [String] = []
    
    func resetScan() {
        foundCharacters = []
        foundKanji = []
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
    
    func interpretPhoto(scanningImage: CGImage) {
        let requestHandler = VNImageRequestHandler(cgImage: scanningImage)
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
        
        for observation in observations {
            foundCharacters.append(observation.topCandidates(1).first?.string ?? "")
        }
        
        siftKanji()
    }
    
    func siftKanji() {
        for textLine in foundCharacters {
            let charCheck = Array(textLine)
            for char in charCheck {
                if isKanji(char: char) {
                    foundKanji.append(String(char))
                }
            }
        }
    }
}
