//
//  NetworkFactory.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import Foundation

struct NetworkFactory {
    static func getNetworkProvider(_ adaptors: [RequestAdaption]?, session: URLSession = .shared) -> AnyNetworkProvider {
        return NetworkProvider(session: session, requestAdaptors: adaptors)
    }
}
