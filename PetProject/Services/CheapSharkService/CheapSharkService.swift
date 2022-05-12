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
    
    func getStoresList() -> AnyPublisher<[StoreModel], CheapSharkServiceError>? {
        guard var url = apiURL else {
            return nil
        }
        url.appendPathComponent("stores")
        return networkService.getDecodedResponsePublisher(url, modelType: [StoreModel].self, decoder: JSONDecoder())
            .mapError { error -> CheapSharkServiceError in
                if error as? NetworkService.ResponseError != nil {
                    return CheapSharkServiceError.fetchError
                }
                return CheapSharkServiceError.decodeError(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchImage(forStore store: StoreModel) -> AnyPublisher<UIImage, CheapSharkServiceError>? {
        guard var url = hostURL else {
            return nil
        }
        url.appendPathComponent(store.images.logo)
        return fetchImage(url)
    }
    
    func getStoreDeals(forStore store: StoreModel, onPaginationPage page: Int, withSearch searchTitle: String) -> AnyPublisher<[DealModel], CheapSharkServiceError>? {
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
        if !searchTitle.isEmpty {
            components.queryItems?.append(URLQueryItem(name: "title", value: searchTitle))
        }
        
        guard let requestURL = components.url else { return nil }
        
        return networkService.getDecodedResponsePublisher(
            requestURL,
            modelType: [DealModel].self,
            decoder: JSONDecoder())
        .mapError { error -> CheapSharkServiceError in
            if error as? NetworkService.ResponseError != nil {
                return CheapSharkServiceError.fetchError
            }
            return CheapSharkServiceError.decodeError(error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
    
    func fetchImage(forDeal deal: DealModel) -> AnyPublisher<UIImage, CheapSharkServiceError>? {
        guard let url = URL(string: deal.thumb ?? "") else {
            return nil
        }
        return fetchImage(url)
    }
    
    func fetchImage(_ url: URL) -> AnyPublisher<UIImage, CheapSharkServiceError> {
        return networkService.getResponsePublisher(url)
            .tryMap { data in
                guard
                    let image = UIImage(data: data)
                else {
                    throw CheapSharkServiceError.decodeError(nil)
                }
                return image
            }
            .mapError { error -> CheapSharkServiceError in
                if error as? NetworkService.ResponseError != nil {
                    return CheapSharkServiceError.fetchError
                }
                return CheapSharkServiceError.decodeError(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchTopDeals() -> AnyPublisher<[DealModel], CheapSharkServiceError>? {
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
        components.queryItems?.append(URLQueryItem(name: "sortBy", value: "Savings"))
        
        guard let requestURL = components.url else { return nil }
        
        return networkService.getDecodedResponsePublisher(
            requestURL,
            modelType: [DealModel].self,
            decoder: JSONDecoder())
        .mapError { error -> CheapSharkServiceError in
            if error as? NetworkService.ResponseError != nil {
                return CheapSharkServiceError.fetchError
            }
            return CheapSharkServiceError.decodeError(error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
    
    func globalSearchDeals(title: String, onPaginationPage page: Int) -> AnyPublisher<[DealModel], CheapSharkServiceError>? {
        guard var url = apiURL  else {
            return nil
        }
        url.appendPathComponent("deals")
        guard
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            !title.isEmpty
        else {
            return nil
        }
        components.queryItems = []
        components.queryItems?.append(URLQueryItem(name: "sortBy", value: "Savings"))
        components.queryItems?.append(URLQueryItem(name: "pageNumber", value: "\(page)"))
        components.queryItems?.append(URLQueryItem(name: "pageSize", value: "\(paginationDealsCount)"))
        components.queryItems?.append(URLQueryItem(name: "title", value: title))
        
        guard let requestURL = components.url else { return nil }
        
        return networkService.getDecodedResponsePublisher(
            requestURL,
            modelType: [DealModel].self,
            decoder: JSONDecoder())
        .mapError { error -> CheapSharkServiceError in
            if error as? NetworkService.ResponseError != nil {
                return CheapSharkServiceError.fetchError
            }
            return CheapSharkServiceError.decodeError(error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
}

enum CheapSharkServiceError: Error {
    case apiNotFound
    case fetchError
    case decodeError(String?)
}
