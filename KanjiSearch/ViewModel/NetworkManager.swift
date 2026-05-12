//
//  NetworkManager.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/14/26.
//

import Foundation

@Observable
class NetworkManager {
    static let ipAddress : String = "http://localhost:8000"
    
    func byCharacterSearch(character: String) async throws -> Kanji {
        guard let url = URL(string: "\(NetworkManager.ipAddress)/kanji/character/\(character)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(Kanji.self, from: data)
    }
    
    enum NetworkError: LocalizedError {
        case invalidURL
        case invalidResponse
        case httpError(statusCode: Int)
        case invalidCredentials
        case emailAlreadyRegistered
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "The URL is invalid."
            case .invalidResponse:
                return "The server response was invalid."
            case .httpError(let statusCode):
                return "Request failed with status code: \(statusCode)"
            case .invalidCredentials:
                return "Invalid email or password."
            case .emailAlreadyRegistered:
                return "This email is already registered."
            }
        }
    }
}
