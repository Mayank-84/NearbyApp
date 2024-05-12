//
//  ListingRepository.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import Foundation

protocol AnyListingRepository {
    func fetchData(using lat: String, long: String) async throws -> NearbyListingResponseModel
}

struct ListingRepository: AnyListingRepository {
    private let networkService: AnyListingNetworkService
    private let pager: Pageable
    
    init(networkService: AnyListingNetworkService,
         pager: Pageable) {
        self.pager = pager
        self.networkService = networkService
    }
    
    func fetchData(using lat: String, long: String) async throws -> NearbyListingResponseModel {
        // TODO: check for local data
        // call network service
        let reachedEnd = await pager.isPageEnd()
        guard !reachedEnd else {
            throw ListingError.reachedPageEnd
        }
        let data = try await pager.loadNextPage { page, itemsPerPage in
            try await networkService.fetchListingData(lat: lat, long: long, page, itemsPerPage)
        }
        if let data {
            return data
        }
        else {
            throw ListingError.networkError
        }
    }
}
