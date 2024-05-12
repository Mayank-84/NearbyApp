//
//  NearbyListingView.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import SwiftUI

struct NearbyListingView<T: AnyNearbyListingViewModel>: View {
    @StateObject private var viewModel: T
    @State private var sliderValue: Int = 0
    
    init(viewModel: T) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
            contentView
            sliderView
        }.onAppear {
            viewModel.fetchData()
        }
    }
}

private extension NearbyListingView {
    @ViewBuilder
    var contentView: some View {
        switch viewModel.dataFetchPhase {
        case .notRequested, .loading:
            loadingView
        case .loaded:
            loadedView
        case .failed(let error):
            // TODO: Show appropriate error
            Text("Something went wrong")
        }
    }
    @ViewBuilder
    var loadedView: some View {
        if viewModel.listData.data.count > 0 {
            List(viewModel.listData.data, id: \.id) { data in
                ListItem(data: data) {
                    // TODO: open the webpage
                }.onAppear {
                    // add pagination condition here
                }
            }.listStyle(.grouped)
        } else if case .loaded = viewModel.dataFetchPhase {
            Text("No items to show at this moment")
        }
    }
    
    var loadingView: some View {
        ProgressView().progressViewStyle(.circular)
    }
    
    var failedView: some View {
        // TODO:
        Text("something went wrong")
    }

    var sliderView: some View {
        // TODO: Implement slider functionality here
        EmptyView()
    }
}

struct ListItem: View {
    let data: NearbyListingDataItem
    let onTap: (() -> ())?
    
    var body: some View {
        HStack {
            // TODO: Replace with cached image
            AsyncImage(url: data.imageURL)
            VStack {
                Text(data.title)
                    .bold()
                Text(data.subTitle)
            }
        }
    }
}
