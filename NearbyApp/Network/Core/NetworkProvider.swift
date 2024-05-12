//
//  NetworkProvider.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import Foundation

protocol AnyNetworkProvider {
    
    func executeRequest<T: Decodable,
                               U: NetworkRequestable>(request: U, response: T.Type) async throws -> T
    init(session: URLSession, requestAdaptors: [RequestAdaption]?)
}

final class NetworkProvider: AnyNetworkProvider {
    private let requestBuilder: AnyURLRequestBuilder
    private let requestExecutor: RequestExecuting
    private let requestAdaptors: [RequestAdaption]
    private let responseParser: ResponseParsing
    
    init(requestMaker: AnyURLRequestBuilder,
                requestExecutor: RequestExecuting,
                requestAdaptors: [RequestAdaption],
                responseParser: ResponseParsing) {
        self.requestBuilder = requestMaker
        self.requestExecutor = requestExecutor
        self.requestAdaptors = requestAdaptors
        self.responseParser = responseParser
    }
    
    public init(session: URLSession, requestAdaptors: [RequestAdaption]?) {
        self.requestBuilder = RequestFactory.getURLRequestBuilder()
        // TODO: Create builder to instantiate these
        self.requestExecutor = URLRequestExecutor(session: session)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.responseParser = ResponseParser(decoder)
        self.requestAdaptors = requestAdaptors ?? []
    }

    public func executeRequest<T: Decodable,
                               U: NetworkRequestable>(request: U, response: T.Type) async throws -> T {
        // create url request
        let request = try requestBuilder.makeURLRequest(with: request)
        
        // adapt
        var adaptedRequest = request
        requestAdaptors.forEach {
            adaptedRequest = $0.adapt(request: adaptedRequest)
        }
        
        // execute
        let result = try await requestExecutor.execute(adaptedRequest)
        
        // parse
        let parsedResult: T = try responseParser.parseResult(result)
        return parsedResult
    }
}
