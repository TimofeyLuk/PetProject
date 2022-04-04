//
//  NetworkService.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import Combine
import UIKit

final class NetworkService {
    
    func send(data: Data, forUrl url: String) async throws -> (Data, URLResponse) {
        if Bool.random() {
            print("send success")
            return (Data(), URLResponse())
        } else {
            print("send fail")
            throw LoginError(type: .network, message: "Some network error".localized)
        }
    }
    
    func getResponsePublisher(_ url: URL) -> URLSession.DataTaskPublisher {
        URLSession.shared.dataTaskPublisher(for: url)
    }
    
    func getImagePublisher(_ url: URL) -> Publishers.Map<URLSession.DataTaskPublisher, UIImage?> {
        getResponsePublisher(url).map { (data: Data, response: URLResponse) in
            return UIImage(data: data)
        }
    }
}
