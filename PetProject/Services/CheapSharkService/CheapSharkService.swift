//
//  CheapSharkService.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 29.03.22.
//

import Foundation
import Combine
import UIKit

final class CheapSharkService {
    
    private let apiURL = URL(string: "https://www.cheapshark.com/api/1.0")
    private var hostURL =  URL(string: "https://www.cheapshark.com")
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkService
    let maximumDealsCount = 999
    let paginationDealsCount = 40
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getStoresList(_ completion: @escaping (Result<[StoreModel], CheapSharkServiceError>) -> Void ) {
        guard var url = apiURL else {
            completion(.failure(.apiNotFound))
            return
        }
        url.appendPathComponent("stores")
        networkService.getResponsePublisher(url)
            .timeout(3, scheduler: RunLoop.current)
            .sink {
                switch $0 {
                case .failure(_):
                    completion(.failure(.fetchError))
                case .finished:
                    print ("Received store list completion: \($0).")
                }
            } receiveValue: { (data: Data, response: URLResponse) in
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        let stores = try JSONDecoder().decode([StoreModel].self, from: data)
                        completion(.success(stores))
                    } catch let error {
                        completion(.failure(.decodeError(error.localizedDescription)))
                    }
                } else {
                    completion(.failure(.fetchError))
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchImage(forStore store: StoreModel, _ completion: @escaping (Result<UIImage, CheapSharkServiceError>) -> Void ) {
        guard var url = hostURL else {
            completion(.failure(.apiNotFound))
            return
        }
        url.appendPathComponent(store.images.logo)
        networkService.getImagePublisher(url)
            .sink (
                receiveCompletion: {
                    switch $0 {
                    case .failure(_):
                        completion(.failure(.fetchError))
                    case .finished:
                        print ("Received fetch image for store \(store.storeID) completion: \($0).")
                    }
                },
                receiveValue: { image in
                    if let strongImage = image {
                        completion(.success(strongImage))
                    } else {
                        completion(.failure(.fetchError))
                    }
                })
            .store(in: &cancellables)
    }
    
    func getMaximumDeals(forStore store: StoreModel,
                         _ completion: @escaping (Result<[DealModel], CheapSharkServiceError>) -> Void) {
        guard var url = apiURL  else {
            completion(.failure(.apiNotFound))
            return
        }
        url.appendPathComponent("deals")
        guard
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            completion(.failure(.apiNotFound))
            return
        }
        components.queryItems?.append(URLQueryItem(name: "storeID", value: "\(store.storeID)"))
        components.queryItems?.append(URLQueryItem(name: "pageSize", value: "999"))
        
        guard let requestURL = components.url else {
            completion(.failure(.apiNotFound))
            return
        }
        
        networkService.getResponsePublisher(requestURL)
            .sink {
                switch $0 {
                case .failure(_):
                    completion(.failure(.fetchError))
                case .finished:
                    print("Received fetch max deals for store \(store.storeID) completion: \($0).")
                }
            } receiveValue: { (data: Data, response: URLResponse) in
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        let deals = try JSONDecoder().decode([DealModel].self, from: data)
                        completion(.success(deals))
                    } catch let error {
                        completion(.failure(.decodeError(error.localizedDescription)))
                    }
                } else {
                    completion(.failure(.fetchError))
                }
            }
            .store(in: &cancellables)
    }
}

enum CheapSharkServiceError: Error {
    case apiNotFound
    case fetchError
    case decodeError(String?)
}
