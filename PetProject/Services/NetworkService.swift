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
    
    func getResponsePublisher(_ url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ (data: Data, response: URLResponse) in
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200
                else {
                    throw ResponseError(message: "failed https response")
                }
                return data
            })
            .mapError({ _ in
                return ResponseError(message: "failed https response")
            })
            .eraseToAnyPublisher()
    }
    
    func getDecodedResponsePublisher<Model,Coder>( _ url: URL,
                                                   modelType: Model.Type,
                                                   decoder: Coder
    ) -> AnyPublisher<Model, Error> where Model : Decodable, Coder : TopLevelDecoder {
        getResponsePublisher(url)
            .decode(type: modelType, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
