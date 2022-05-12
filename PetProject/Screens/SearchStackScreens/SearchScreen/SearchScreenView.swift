//
//  SearchScreenView.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 4.05.22.
//

import SwiftUI

struct SearchScreenView: View {
    
    @ObservedObject var viewModel: SearchScreenViewModel
    
    var body: some View {
        VStack {
            SearchBar(
                searchText: $viewModel.searchText,
                onCommit: {
                    if viewModel.searchText.isEmpty {
                        viewModel.deleteSearchResult()
                    } else {
                        viewModel.searchDeals()
                    }
                },
                onCancel: { viewModel.deleteSearchResult() }
            )
            ScrollView {
                if viewModel.searchedDeals.isEmpty {
                    searchHistoryList
                    topDealsList
                } else {
                    searhedDeals
                }
            }
        }
    }
    
    var searchHistoryList: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text("Search history".localized)
            }
            if viewModel.searchHistory.isEmpty {
                HStack {
                    Spacer()
                    Text("History is empty".localized)
                        .font(.title3)
                        .foregroundColor(Color.gray)
                    Spacer()
                }
            } else {
                ForEach(viewModel.searchHistory.suffix(7).reversed()) { searchReqest in
                    HStack {
                        Text(searchReqest.searchText)
                            .font(.title2)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                }
            }
            Divider()
        }
        .padding(.horizontal)
    }
    
    var topDealsList: some View {
        VStack {
            HStack {
                Spacer()
                Text("Top deals".localized)
            }
            StoreSortedDealsListView(viewModel: viewModel.topDealsListVM)
        }
        .padding(.horizontal)
    }

    var searhedDeals: some View {
        LazyVStack {
            ForEach(viewModel.searchedDeals) { deal in
                GamesListCell(
                    deal: deal,
                    image: viewModel.dealsLogos[deal.id],
                    storeLogo: viewModel.storesLogos[deal.storeID ?? ""]
                )
            }
            if !viewModel.paginationIsEnded {
                ProgressView().onAppear { viewModel.searchDeals() }
            }
        }
    }
}




struct SearchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreenView(
            viewModel: SearchScreenViewModel(
                topDealsListVM: StoreSortedDealsListViewModel(
                    apiService: DependencyContainer().cheapSharkAPIService
                ),
                apiService: DependencyContainer().cheapSharkAPIService,
                saveHistoryService: SaveSearchHistoryService()
            )
        )
    }
}
