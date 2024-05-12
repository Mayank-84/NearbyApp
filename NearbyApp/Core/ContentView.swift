//
//  ContentView.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ViewFactory.getListingView()
    }
}

#Preview {
    ContentView()
}

struct ViewFactory {
    // TODO: Make it mockable to mock with different mock versions of each smaller dependencies
    static func getListingView() -> some View {
        let networkService = ListingNetworkService()
        let pager = Pager()
        let repository = ListingRepository(networkService: networkService, pager: pager)
        let locationManager = LocationManager()
        let viewModel = NearbyListingViewModel(repository: repository, locationManager: locationManager)
        return NearbyListingView(viewModel: viewModel)
    }
}
