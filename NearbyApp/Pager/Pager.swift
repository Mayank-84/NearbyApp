//
//  Pager.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import Foundation

protocol Pageable {
    func loadNextPage<T>(_ dataFetchProvider: @escaping(_ page: Int, _ itemsPerPage: Int) async throws ->T) async throws -> T?
    func reset() async
    func isPageEnd() async -> Bool
}

actor Pager: Pageable {
    let itemsPerPage: Int
    let maxPageLimit: Int
    
    private(set) var hasReachedPageEnd: Bool = false
    private(set) var currentPage: Int = 0
    
    var nextPage: Int { currentPage + 1 }
    private var shouldLoadNextPage: Bool {
        !hasReachedPageEnd && nextPage <= maxPageLimit
    }
    
    init(itemsPerPage: Int = 10,
         maxPageLimit: Int = 10) {
        self.itemsPerPage = itemsPerPage
        self.maxPageLimit = maxPageLimit
    }
    
    func loadNextPage<T>(_ dataFetchProvider: @escaping(_ page: Int, _ itemsPerPage: Int) async throws ->T) async throws -> T? {
        guard shouldLoadNextPage else {
            debugPrint("Paging: Cannot load next Page")
            return nil
        }
        let nextPage = self.nextPage
        debugPrint("Paging: Fetching next Page \(nextPage)")
        let items = try await dataFetchProvider(nextPage, itemsPerPage)
        if self.nextPage != nextPage { return nil }
        currentPage = nextPage
        hasReachedPageEnd = (currentPage == maxPageLimit)
        return items
    }
    
    func reset() {
        currentPage = 0
        hasReachedPageEnd = false
    }
    
    func isPageEnd() async -> Bool {
        return hasReachedPageEnd
    }
}
