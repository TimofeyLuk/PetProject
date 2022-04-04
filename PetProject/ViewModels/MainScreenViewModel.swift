//
//  MainScreenViewModel.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 25.03.22.
//

import UIKit

final class MainScreenViewModel {
    
    @Published private(set) var stores: [StoreModel] = []
    @Published private(set) var storesLogos: [String : UIImage] = [:]
    @Published private(set) var error: CheapSharkServiceError?
    
    var count: Int { stores.count }
    private let apiService: CheapSharkService
    
    init(apiService: CheapSharkService) {
        self.apiService = apiService
        fetchStores()
    }
    
    private func fetchStores() {
        apiService.getStoresList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let storesList):
                self.stores = storesList
                storesList.forEach { store in
                    self.fetchImage(forStore: store)
                }
            case .failure(let error):
                self.error = error
                switch error {
                case .decodeError(let description):
                    print("Stores JSON decode error: \(String(describing: description))")
                default:
                    print("Fetch stores error: \(error)")
                }
            }
        }
    }
    
    private func fetchImage(forStore store: StoreModel) {
        apiService.fetchImage(forStore: store) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.storesLogos[store.storeID] = image
            case .failure(_):
                print("fail to get logo for \(store.storeName)")
            }
        }
    }
    
}
