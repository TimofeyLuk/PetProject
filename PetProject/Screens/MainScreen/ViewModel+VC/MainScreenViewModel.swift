//
//  MainScreenViewModel.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 25.03.22.
//

import UIKit
import Combine

final class MainScreenViewModel {
    
    @Published private(set) var stores: [StoreModel] = []
    @Published private(set) var storesLogos: [String : UIImage] = [:]
    @Published private(set) var error: CheapSharkServiceError?
    
    var count: Int { stores.count }
    private let apiService: CheapSharkService
    private var cancellables = Set<AnyCancellable>()
    
    init(apiService: CheapSharkService) {
        self.apiService = apiService
        fetchStores()
    }
    
    private func fetchStores() {
        apiService.getStoresList()?
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.error = error
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
                    self.stores = storesList
                    storesList.forEach { store in
                        self.fetchImage(forStore: store)
                    }
            })
            .store(in: &cancellables)
    }
    
    private func fetchImage(forStore store: StoreModel) {
        apiService.fetchImage(forStore: store)?
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("fail to get logo for \(store.storeName) with error: \(error)")
                case .finished:
                    print("fetch logo for \(store.storeName) finished")
                }
            }, receiveValue: { image in
                self.storesLogos[store.storeID] = image
            })
            .store(in: &cancellables)
    }
    
}
