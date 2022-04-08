//
//  CheapSharkService.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 29.03.22.
//

import Combine
import UIKit

final class CheapSharkService {
    
    private let apiURL = URL(string: "https://www.cheapshark.com/api/1.0")
    private var hostURL =  URL(string: "https://www.cheapshark.com")
    private let networkService: NetworkService
    let paginationDealsCount = 40
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    typealias GetStoresListPublisher = Publishers.Map<NetworkService.GetResponsePublisher, Result<[StoreModel], CheapSharkServiceError>>
    func getStoresList() -> GetStoresListPublisher? {
        guard var url = apiURL else {
            return nil
        }
        url.appendPathComponent("stores")
        return networkService.getResponsePublisher(url).map { result -> Result<[StoreModel], CheapSharkServiceError> in
            switch result {
            case .failure(_):
                return .failure(CheapSharkServiceError.fetchError)
            case .success(let data):
                do {
                    let stores = try JSONDecoder().decode([StoreModel].self, from: data)
                    return .success(stores)
                } catch let error {
                    return .failure(.decodeError(error.localizedDescription))
                }
            }
        }
    }
    
    typealias FetchImagePublisher = Publishers.Map<NetworkService.GetImagePublisher, Result<UIImage, CheapSharkServiceError>>
    func fetchImage(forStore store: StoreModel) -> FetchImagePublisher? {
        guard var url = hostURL else {
            return nil
        }
        url.appendPathComponent(store.images.logo)
        return networkService.getImagePublisher(url).map { result -> Result<UIImage, CheapSharkServiceError> in
            switch result {
            case .success(let image):
                return .success(image)
            case .failure(let error):
                print("fetch image error: \(error.message)")
                return .failure(.fetchError)
            }
        }
    }
    
    typealias GetStoreDealsPublisher = Publishers.Map<NetworkService.GetResponsePublisher, Result<[DealModel], CheapSharkServiceError>>
    func getStoreDeals(forStore store: StoreModel, onPaginationPage page: Int) -> GetStoreDealsPublisher? {
        guard var url = apiURL  else {
            return nil
        }
        url.appendPathComponent("deals")
        guard
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            return nil
        }
        components.queryItems = []
        components.queryItems?.append(URLQueryItem(name: "storeID", value: "\(store.storeID)"))
        components.queryItems?.append(URLQueryItem(name: "pageNumber", value: "\(page)"))
        components.queryItems?.append(URLQueryItem(name: "pageSize", value: "\(paginationDealsCount)"))
        
        guard let requestURL = components.url else { return nil }
        
        return networkService.getResponsePublisher(requestURL, timeout: 7)
            .map { result -> Result<[DealModel], CheapSharkServiceError> in
                switch result {
                case .failure(let error):
                    print("Response publisher \(String(describing: error))")
                    return .failure(.fetchError)
                case .success(let data):
                    do {
                        let deals = try JSONDecoder().decode([DealModel].self, from: data)
                        return .success(deals)
                    } catch let error {
                        return .failure(.decodeError(error.localizedDescription))
                    }
                }
            }
    }
    
    func fetchImage(forDeal deal: DealModel) -> FetchImagePublisher? {
        guard let url = URL(string: deal.thumb ?? "") else {
            return nil
        }
        return networkService.getImagePublisher(url)
            .map { result -> Result<UIImage, CheapSharkServiceError> in
                switch result {
                case .success(let image):
                    return .success(image)
                case .failure(let error):
                    print("fetch image error: \(error.message)")
                    return .failure(.fetchError)
                }
            }
    }
}

enum CheapSharkServiceError: Error {
    case apiNotFound
    case fetchError
    case decodeError(String?)
}
