//
//  NetworkRequestable.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol NetworkRequestable {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Encodable? { get }
    var header: [String:String]? { get }
}

public extension NetworkRequestable {
    var header: [String: String]? { nil }
}
