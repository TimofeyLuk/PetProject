//
//  TopDealsListCellViewModel.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 4.05.22.
//

import Combine
import UIKit

final class StoreSortedListCellViewModel: ObservableObject {
    
    @Published private(set) var store: StoreModel
    @Published var storeLogoImage: UIImage?
    @Published private(set) var storeDeals: [DealModel]
    @Published private(set) var dealsImages: [String : UIImage] = [:]
    
    private let apiService: CheapSharkService
    private var cancellables = Set<AnyCancellable>()
    
    init(store: StoreModel, apiService: CheapSharkService, storeDeals: [DealModel]) {
        self.store = store
        self.apiService = apiService
        self.storeDeals = storeDeals
        fetchStoreImage()
        fetchDealsImages()
    }
    
    private func fetchStoreImage() {
        apiService.fetchImage(forStore: store)?
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("fail to get store logo with error: \(error)")
                    case .finished:
                        print("fetch store logo finished")
                    }
                },
                receiveValue: { [weak self] image in
                    self?.storeLogoImage = image
                }
            )
            .store(in: &cancellables)
    }
    
    private func fetchDealsImages() {
        storeDeals.forEach { deal in
            apiService.fetchImage(forDeal: deal)?
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            print("fail to get deal image with error: \(error)")
                        case .finished:
                            print("fetch deal image finished")
                        }
                    },
                    receiveValue: { [weak self] image in
                        self?.dealsImages[deal.id] = image
                    }
                )
                .store(in: &cancellables)
        }
    }
    
}
