//
//  StyleTransferService.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 05/06/26.
//

import Foundation

final class StyleTransferService {
    static let shared = StyleTransferService()
    
    private init() {}
    
    private let translateURL = URL(string: "http://10.67.51.75:8000/translate")!
    
    func translate(_ text: String) async throws -> String {
        var request = URLRequest(url: translateURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        
        let body = TranslateRequest(
            text: text,
            topK: 3,
            minimumScore: 0.2
        )
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw StyleTransferError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw StyleTransferError.serverError(httpResponse.statusCode)
        }
        
        let decoded = try JSONDecoder().decode(TranslateResponse.self, from: data)
        return decoded.result
    }
}

private struct TranslateRequest: Encodable {
    let text: String
    let topK: Int
    let minimumScore: Double
    
    enum CodingKeys: String, CodingKey {
        case text
        case topK = "top_k"
        case minimumScore = "minimum_score"
    }
}

private struct TranslateResponse: Decodable {
    let input: String
    let formalText: String
    let result: String
    let options: [String]
    
    enum CodingKeys: String, CodingKey {
        case input
        case formalText = "formal_text"
        case result
        case options
    }
}

enum StyleTransferError: LocalizedError {
    case invalidResponse
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server."
        case .serverError(let code):
            return "Server returned error code \(code)."
        }
    }
}
