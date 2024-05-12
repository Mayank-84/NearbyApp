//
//  ResponseParsing.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import Foundation

protocol ResponseParsing {
    func parseResult<T:Decodable>(_ result: RequestSuccessModel) throws -> T
}

extension ResponseParsing {
    func parseResult<T:Decodable>(_ result: RequestSuccessModel) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(T.self, from: result.data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
