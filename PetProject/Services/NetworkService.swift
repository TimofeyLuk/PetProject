//
//  NetworkService.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import Foundation

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
    
}
