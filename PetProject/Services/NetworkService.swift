//
//  NetworkService.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import Combine
import UIKit

final class NetworkService {
    
    struct ResponseError: Error {
        let message: String
    }
    
    func send(data: Data, forUrl url: String) async throws -> (Data, URLResponse) {
        if Bool.random() {
            print("send success")
            return (Data(), URLResponse())
        } else {
            print("send fail")
            throw LoginError(type: .network, message: "Some network error".localized)
        }
    }
    
    typealias GetResponsePublisher = Publishers.Map<URLSession.DataTaskPublisher, Result<Data, ResponseError>>
    func getResponsePublisher(_ url: URL, timeout: Int = 3) -> GetResponsePublisher {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { (data: Data, response: URLResponse) -> Result<Data, ResponseError> in
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200
                else {
                    return .failure(ResponseError(message: "failed https response"))
                }
                return .success(data)
            }
    }
    
    typealias GetImagePublisher = Publishers.Map<GetResponsePublisher, Result<UIImage, ResponseError>>
    func getImagePublisher(_ url: URL) -> GetImagePublisher {
        getResponsePublisher(url).map { result -> Result<UIImage, ResponseError> in
            switch result {
            case .failure(let error):
                return .failure(error)
            case .success(let data):
                if let image = UIImage(data: data) {
                    return .success(image)
                } else {
                    return .failure(ResponseError(message: "fail to decode image"))
                }
            }
        }
    }
}
