//
//  SearchScreenViewModel.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 4.05.22.
//

import SwiftUI
import Combine

class SearchScreenViewModel: ObservableObject {
    @Published var searchHistory: [SearchReqestModel] = []
    @Published var searchedDeals: [DealModel] = []
    @Published var searchText: String = ""
    @Published private(set) var storesLogos: [String : UIImage] = [:]
    @Published private(set) var dealsLogos: [String : UIImage] = [:]
    @Published private(set) var isPaginationEnded = false
    
    let topDealsListVM: StoreSortedDealsListViewModel
    private var paginationPage: Int = 0
    private let apiService: CheapSharkService
    private var cancellables = Set<AnyCancellable>()
    private let searchDispathGroup = DispatchGroup()
    private let searchDispathQueue = DispatchQueue(label: "searchDispathQueue")
    private let saveHistoryService: SaveSearchHistoryService
    
    init(
        topDealsListVM: StoreSortedDealsListViewModel,
        apiService: CheapSharkService,
        saveHistoryService: SaveSearchHistoryService
    ){
        self.topDealsListVM = topDealsListVM
        self.apiService = apiService
        self.saveHistoryService = saveHistoryService
        self.saveHistoryService.$history
            .receive(on: DispatchQueue.main)
            .sink { [weak self] savedReqests in
                self?.searchHistory = savedReqests
            }
            .store(in: &cancellables)
        self.fetchStores()
    }
    
    func searchDeals() {
        searchDispathQueue.async { [weak self] in
            guard let self = self else { return }
            self.searchDispathGroup.wait()
            self.searchDispathGroup.enter()
            self.apiService.globalSearchDeals(
                title: self.searchText,
                onPaginationPage: self.paginationPage
            )?
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            self.searchDispathGroup.leave()
                            switch error {
                            case .decodeError(let description):
                                print("Global search deals JSON decode error: \(String(describing: description))")
                            default:
                                print("Global search deals error: \(error)")
                            }
                        case .finished:
                            print("Global search deals finished")
                        }
                    },
                    receiveValue: { deals in
                        self.searchedDeals += deals.filter {
                            !self.searchedDeals.contains($0)
                        }
                        self.isPaginationEnded = deals.isEmpty
                        self.searchDispathGroup.leave()
                        self.paginationPage += 1
                        deals.forEach({ self.fetchDealImage($0) })
                        if !self.searchHistory.contains(where: { $0.searchText == self.searchText }) {
                            self.saveHistoryService.saveSearchReqest(SearchReqestModel(searchText: self.searchText))
                        }
                    }
                )
                .store(in: &self.cancellables)
        }
    }
    
    func fetchDealImage(_ deal: DealModel) {
        apiService.fetchImage(forDeal: deal)?
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure:
                        print("Faild to fetch deal image")
                    case .finished:
                        print("Fetch deal image finished")
                    }
                },
                receiveValue: { [weak self] image in
                    self?.dealsLogos[deal.id] = image
                }
            )
            .store(in: &cancellables)
    }

    func deleteSearchResult() {
        searchText = ""
        searchedDeals = []
        paginationPage = 0
        isPaginationEnded = false
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
