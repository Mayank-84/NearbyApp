//
//  NearbyListingResponseModel.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import Foundation

enum ListingError: Error {
    case reachedPageEnd
    case networkError
    case locationRequired
    case genericError
}

struct NearbyListingCollectionData: Identifiable {
    var data: [NearbyListingDataItem]
    let id: UUID = UUID()
}

struct NearbyListingDataItem: Identifiable {
    let title: String
    let subTitle: String
    let imagePath: String
    let id: UUID = UUID()
    
    var imageURL: URL? { URL(string: imagePath) }
}

struct NearbyListingResponseModel: Codable {
    let venues: [Venue]
}

struct Venue: Codable {
    let name: String
    let url: String
    let address: String?
    let city: String
}
