//
//  Utility.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import Foundation

enum Loadable<T: Identifiable> {
    case notRequested
    case loading
    case loaded
    case failed(Error)
}
