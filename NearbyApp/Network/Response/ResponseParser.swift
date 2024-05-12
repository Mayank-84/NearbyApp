//
//  ResponseParser.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import Foundation

struct ResponseParser: ResponseParsing {
    private let decoder: JSONDecoder
    
    init(_ decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    func parseResult<T: Decodable>(_ result: RequestSuccessModel) throws -> T {
        do {
            return try decoder.decode(T.self, from: result.data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
