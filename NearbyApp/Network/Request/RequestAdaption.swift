//
//  RequestAdaption.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import Foundation

// Allow final modification of requests before they are executed
// like default headers, etc
public protocol RequestAdaption {
    func adapt(request: URLRequest) -> URLRequest
}

public struct DefaultHTTPHeaderAdapter: RequestAdaption {
    private var headerProvider: () -> ([String: String])
    
    public init(headerProvider: @escaping () -> [String : String]) {
        self.headerProvider = headerProvider
    }
    
    public func adapt(request: URLRequest) -> URLRequest {
        var mutableRequest = request
        let headers = headerProvider()
        headers.forEach {
            mutableRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        return mutableRequest
    }
}
