//
//  GamesListViewModel.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 1.04.22.
//

import UIKit
import Combine

class GamesListViewModel: ObservableObject {
    
    @Published private(set) var store: StoreModel
    @Published private(set) var dealsList: [DealModel] = []
    @Published private(set) var dealsImages: [DealModel.ID : UIImage] = [:]
    private(set) var dealsListIsFull = false
    
    private let apiService: CheapSharkService
    private var paginationPage = 1
    private let paginationQueue = DispatchQueue(label: "GamesListPaginationQueue")
    private let paginationDispatchGroup = DispatchGroup()
    private var cancellables = Set<AnyCancellable>()
    
    init(store: StoreModel, apiService: CheapSharkService) {
        self.store = store
        self.apiService = apiService
        paginateDealsList()
    }
    
    func paginateDealsList() {
        paginationQueue.async { [weak self] in
            guard let self = self else { return }
            self.paginationDispatchGroup.wait()
            self.paginationDispatchGroup.enter()
            self.apiService.getStoreDeals(forStore: self.store, onPaginationPage: self.paginationPage)?
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("paginate deals list count for page \(self.paginationPage) error: \(error)")
                        self.paginationDispatchGroup.leave()
                    case .finished:
                        print("paginate deals list count for page \(self.paginationPage) finished")
                    }
                }, receiveValue: { deals in
                    deals.forEach {
                        self.fetchImage(forDeal: $0)
                    }
                    DispatchQueue.main.async {
                        self.paginationPage += 1
                        self.dealsList = Array(Set(self.dealsList + deals))
                        self.dealsListIsFull = deals.isEmpty
                        print("\n new paginationPage \(self.paginationPage)")
                        print("added \(deals.count) deals / total \(self.dealsList.count)")
                        self.paginationDispatchGroup.leave()
                    }
                })
                .store(in: &self.cancellables)
        }
    }
    
    private func fetchImage(forDeal deal: DealModel) {
        apiService.fetchImage(forDeal: deal)?
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("fetch image error: \(error)")
                case .finished:
                    print("fetched image for deal \(deal.id)")
                }
            }, receiveValue: { image in
                DispatchQueue.main.async {
                    self.dealsImages[deal.id] = image
                }
            })
            .store(in: &cancellables)
    }
}
