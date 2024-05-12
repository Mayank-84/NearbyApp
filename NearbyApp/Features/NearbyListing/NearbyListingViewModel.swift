//
//  NearbyListingViewModel.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import CoreLocation

protocol AnyNearbyListingViewModel: AnyObject, ObservableObject {
    var dataFetchPhase: Loadable<NearbyListingCollectionData> { get }
    var listData: NearbyListingCollectionData { get }
    func fetchData()
}

final class NearbyListingViewModel: AnyNearbyListingViewModel {
    @Published private(set) var dataFetchPhase: Loadable<NearbyListingCollectionData>
    @Published private(set) var listData: NearbyListingCollectionData
    
    private let repository: AnyListingRepository
    private var locationManager: any LocationHandler
    
    init(dataFetchPhase: Loadable<NearbyListingCollectionData> = .notRequested,
         listData: NearbyListingCollectionData = .init(data: []),
         repository: AnyListingRepository,
         locationManager: any LocationHandler) {
        self.dataFetchPhase = dataFetchPhase
        self.listData = listData
        self.repository = repository
        self.locationManager = locationManager
        self.locationManager.startUpdatingLocation()
        self.locationManager.locationChangedCallback = { [weak self] coordiantes in
            self?.locationChanged(coordiantes)
        }
    }
    
    func fetchData() {
        if case .loading = dataFetchPhase { return }
        // I am overriding the location to test on simulator. For some reasons, it is not updating location for me
        let lat = "12.84"
        let lang = "77.6"
        
        dataFetchPhase = .loading
        Task {
            do {
                let response = try await repository.fetchData(using: lat, long: lang)
                let transformedData = transformResponseToCollectionData(response: response)
                DispatchQueue.main.async {
                    self.listData.data.append(contentsOf: transformedData.data)
                    self.dataFetchPhase = .loaded
                }
            } catch {
                // TODO: Show error on UI
                dataFetchPhase = .failed(ListingError.genericError)
            }
        }
    }
    
    private func transformResponseToCollectionData(response: NearbyListingResponseModel) -> NearbyListingCollectionData {
        var dataItems: [NearbyListingDataItem] = []
        
        for venue in response.venues {
            let title = venue.name
            let subTitle = venue.address ?? ""
            let imagePath = venue.url
            
            let dataItem = NearbyListingDataItem(title: title, subTitle: subTitle, imagePath: imagePath)
            dataItems.append(dataItem)
        }
        
        let collectionData = NearbyListingCollectionData(data: dataItems)
        return collectionData
    }
    private func locationChanged(_ coordinates: CLLocationCoordinate2D?) {
        guard coordinates != nil else { return }
        // TODO: call fetch data as and when location updates
    }
}

