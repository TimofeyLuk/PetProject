//
//  MainScreenViewModel.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 25.03.22.
//

import Foundation
import UIKit

final class MainScreenViewModel: ObservableObject {
    
    @Published private(set) var stores: [StoreModel] = []
    @Published private(set) var storesLogos: [String : UIImage] = [:]
    @Published private(set) var storesDealsCount: [String : String] = [:]
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
                    self.fetchMaximumDeals(forStore: store)
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
    
    private func fetchMaximumDeals(forStore store: StoreModel) {
        apiService.getMaximumDeals(forStore: store) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let deals):
                self.storesDealsCount[store.storeID] = deals.count == self.apiService.maximumDealsCount ? "999+" : "\(deals.count)"
            case .failure(let error):
                switch error {
                case .decodeError(let description):
                    print("fail to decode deals JSON for \(store.storeName): \(description ?? "")")
                default:
                    print("fail to get deals for \(store.storeName) with error \(error)")
                }
            }
        }
    }
}
