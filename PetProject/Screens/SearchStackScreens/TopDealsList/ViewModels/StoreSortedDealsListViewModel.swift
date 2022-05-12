//
//  StoreSortedDealsListViewModel.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 4.05.22.
//

import Combine
import UIKit

final class StoreSortedDealsListViewModel: ObservableObject {
    @Published var stores: [StoreModel] = []
    @Published var topDeals: [String : [DealModel]] = [:]
    
    private let apiService: CheapSharkService
    private var cancellables = Set<AnyCancellable>()
    private(set) var cellsViewModels: [String : StoreSortedListCellViewModel] = [:]
    
    init(apiService: CheapSharkService) {
        self.apiService = apiService
        fetchTopDeals()
    }
    
    private func fetchStores() {
        apiService.getStoresList()?
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        switch error {
                        case .decodeError(let description):
                            print("Stores JSON decode error: \(String(describing: description))")
                        default:
                            print("Fetch stores error: \(error)")
                        }
                    case .finished:
                        print("Fetch stores finished")
                    }
                },
                receiveValue: { [weak self] storesList in
                    guard let self = self else { return }
                    self.stores = storesList.filter { store in
                        !((self.topDeals[store.storeID]?.isEmpty) ?? true)
                    }
                    self.stores.forEach { store in
                        self.cellsViewModels[store.storeID] = StoreSortedListCellViewModel(
                            store: store,
                            apiService: self.apiService,
                            storeDeals: self.topDeals[store.storeID] ?? []
                        )
                    }
            })
            .store(in: &cancellables)
    }
    
    private func fetchTopDeals() {
        apiService.fetchTopDeals()?
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        switch error {
                        case .decodeError(let description):
                            print("Top deals JSON decode error: \(String(describing: description))")
                        default:
                            print("Fetch top deals error: \(error)")
                        }
                    case .finished:
                        print("Fetch top deals finished")
                    }
                }, receiveValue: { [weak self] topDealsList in
                    let storesIDs = Set(topDealsList.compactMap({ $0.storeID }))
                    storesIDs.forEach { storeId in
                        self?.topDeals[storeId] = topDealsList.filter({ $0.storeID == storeId })
                    }
                    self?.fetchStores()
                }
            )
            .store(in: &cancellables)
    }
}

