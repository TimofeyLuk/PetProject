//
//  GamesScreenViewModel.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 1.04.22.
//

import UIKit

class GamesScreenViewModel: ObservableObject {
    
    @Published private(set) var store: StoreModel
    @Published private(set) var dealsList: [DealModel] = []
    private(set) var dealsListIsFull = false
    
    private let apiService: CheapSharkService
    private var paginationPage = 1
    private let paginationQueue = DispatchQueue(label: "GamesListPaginationQueue")
    private let paginationDispatchGroup = DispatchGroup()
    
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
            self.apiService.getStoreDeals(forStore: self.store,
                                          onPaginationPage: self.paginationPage) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    print("paginate deals list count \(error)")
                    self.paginationDispatchGroup.leave()
                case .success(let deals):
                    DispatchQueue.main.async {
                        self.paginationPage += 1
                        self.dealsList = Array(Set(self.dealsList + deals))
                        self.dealsListIsFull = deals.isEmpty
                        print("\n new paginationPage \(self.paginationPage)")
                        print("added \(deals.count) deals / total \(self.dealsList.count)")
                        self.paginationDispatchGroup.leave()
                    }
                }
            }
        }
    }
}
