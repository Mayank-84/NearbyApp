//
//  RequestExecutor.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import Foundation

struct RequestSuccessModel {
    let data: Data
    let response: URLResponse
}

protocol RequestExecuting {
    var session: URLSession { get set }
    init(session: URLSession)
    func execute(_ requeset: URLRequest) async throws -> RequestSuccessModel
}

struct URLRequestExecutor: RequestExecuting {
    
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func execute(_ requeset: URLRequest) async throws -> RequestSuccessModel {
        let (data, response) = try await session.data(for: requeset)
        return .init(data: data, response: response)
    }
}
