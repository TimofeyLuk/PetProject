//
//  DependencyContainer.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 28.03.22.
//

import Foundation

final class DependencyContainer {
    static let shared = DependencyContainer()
    
    let networkService = NetworkService()
    private(set) lazy var loginService = LoginService(networkService: self.networkService)
}
