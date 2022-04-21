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
    @Published private(set) var errorMessage: String?
    private(set) var dealsListIsFull = false
    
    private let apiService: CheapSharkService
    private var paginationPage = 1
    private let paginationQueue = DispatchQueue(label: "GamesListPaginationQueue")
    private let paginationDispatchGroup = DispatchGroup()
    private var cancellables = Set<AnyCancellable>()
    private var searchGameTitle = ""
    
    init(store: StoreModel, apiService: CheapSharkService) {
        self.store = store
        self.apiService = apiService
        paginateDealsList()
    }
    
    func paginateDealsList() {
        errorMessage = nil
        paginationQueue.async { [weak self] in
            guard let self = self else { return }
            self.paginationDispatchGroup.wait()
            self.paginationDispatchGroup.enter()
            self.apiService.getStoreDeals(forStore: self.store, onPaginationPage: self.paginationPage, withSearch: self.searchGameTitle)?
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("paginate deals list count for page \(self.paginationPage) error: \(error)")
                        DispatchQueue.main.async { [weak self] in
                            self?.errorMessage = "Faid to fetch games list".localized
                        }
                        self.paginationDispatchGroup.leave()
                    case .finished:
                        print("paginate deals list count for page \(self.paginationPage) finished")
                    }
                }, receiveValue: { deals in
                    deals.forEach {
                        if self.dealsImages[$0.id] == nil {
                            self.fetchImage(forDeal: $0)
                        }
                    }
                    DispatchQueue.main.async {
                        self.paginationPage += 1
                        self.dealsList += deals.filter({ !self.dealsList.contains($0) })
                        self.dealsListIsFull = deals.isEmpty
                        print("added \(deals.count) deals / total \(self.dealsList.count)")
                        print("search title\(self.searchGameTitle.isEmpty ? " is empty" : ": \(self.searchGameTitle)")")
                        print("\nnew paginationPage \(self.paginationPage)")
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
                    break
                }
            }, receiveValue: { image in
                DispatchQueue.main.async {
                    self.dealsImages[deal.id] = image
                }
            })
            .store(in: &cancellables)
    }
    
    func search(_ title: String) {
        paginationQueue.async { [weak self] in
            guard let self = self else { return }
            self.paginationDispatchGroup.wait()
            self.paginationDispatchGroup.enter()
            self.paginationPage = 1
            DispatchQueue.main.async {
                self.dealsList.removeAll()
            }
            self.searchGameTitle = title
            self.paginateDealsList()
            self.paginationDispatchGroup.leave()
        }
    }
}
