//
//  RequestFactory.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import Foundation

struct URLRequestBuilder: AnyURLRequestBuilder {  }

struct RequestFactory {
    static func getURLRequestBuilder() -> AnyURLRequestBuilder {
        return URLRequestBuilder()
    }
}
