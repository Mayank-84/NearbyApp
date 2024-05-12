//
//  NetworkError.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidParameters
    case decodingFailed
}
