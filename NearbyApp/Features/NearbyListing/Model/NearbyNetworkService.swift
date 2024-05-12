//
//  NearbyNetworkService.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import Foundation

struct NearbyListingNetworkRequest: NetworkRequestable {
    // TODO: Create configuration and inject it, rather than hardcoding
    // Also , use base url depending on enevironmnet
    var baseURL: String = "https://api.seatgeek.com"
    
    var method: HTTPMethod = .get
    
    var path: String = "/2/venues"
    
    var parameters: Encodable?
    
    init(parameters: Encodable? = nil) {
        self.parameters = parameters
    }
}

protocol AnyListingNetworkService {
    func fetchListingData(lat: String, long: String, _ page: Int, _ itemsPerPage: Int) async throws -> NearbyListingResponseModel
}

struct ListingNetworkService: AnyListingNetworkService {

    private let networkProvider: AnyNetworkProvider
    
    init(networkProvider: AnyNetworkProvider = NetworkFactory.getNetworkProvider(nil)) {
        self.networkProvider = networkProvider
    }
    
    func fetchListingData(lat: String, long: String, _ page: Int, _ itemsPerPage: Int) async throws -> NearbyListingResponseModel {
        // TODO: store the client id securely
        let params: [String: String] = [ "client_id":"Mzg0OTc0Njl8MTcwMDgxMTg5NC44MDk2NjY5",
                                         "per_page":"10",
                                         "lat":lat,
                                        "lon": long,
                                        "page": "\(page)"]
        
        
        let request = NearbyListingNetworkRequest(parameters: params)
        return try await networkProvider.executeRequest(request: request, response: NearbyListingResponseModel.self)
    }
}
