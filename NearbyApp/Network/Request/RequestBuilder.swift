//
//  RequestBuilder.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import Foundation

// Network requestable to URL Request

protocol AnyURLRequestBuilder {
    func makeURLRequest(with request: NetworkRequestable) throws -> URLRequest
}

extension AnyURLRequestBuilder {
    func makeURLRequest(with request: NetworkRequestable) throws -> URLRequest {
        guard var urlCompinenets = URLComponents(string: request.baseURL + request.path) else {
            throw NetworkError.invalidURL
        }
        
        if let parameters = request.parameters,
           request.method == .get {
            urlCompinenets.queryItems = try queryItems(from: parameters)
        }
        
        guard let url = urlCompinenets.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        // add headers
        if let header = request.header {
            for (k,v) in header {
                urlRequest.addValue(v, forHTTPHeaderField: k)
            }
        }
        
        if request.method == .post, let parameters = request.parameters {
            urlRequest.httpBody = try JSONEncoder().encode(parameters)
        }
        
        return urlRequest
    }
    
    private func queryItems(from param: Encodable) throws -> [URLQueryItem] {
        let data = try JSONEncoder().encode(param)
        
        guard let decodedData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw NetworkError.decodingFailed
        }

        return decodedData.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
    }

}
