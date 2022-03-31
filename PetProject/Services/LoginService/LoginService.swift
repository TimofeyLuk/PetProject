//
//  LoginService.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import Foundation

final class LoginService {
    
    var networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func login(user: UserModel) async throws {
        try validateLogin(user.login)
        try validatePassword(user.password)
        
        let loginData = try JSONEncoder().encode(user)
        do {
            let _ = try await networkService.send(data: loginData, forUrl: "same url")
            return
        } catch let error {
            if let loginError = error as? LoginError {
                throw loginError
            } else {
                throw LoginError(type: .network, message: error.localizedDescription)
            }
        }
    }
    
    private func validateLogin(_ login: String) throws {
        if login.isEmpty {
            throw LoginError(type: .login, message: "Login can not be empty".localized)
        }
        if login.lowercased() != login {
            throw LoginError(type: .login, message: "Login can not contains uppercase".localized)
        }
    }
    
    private func validatePassword(_ password: String) throws {
        if password.isEmpty {
            throw LoginError(type: .login, message: "Password can not be empty".localized)
        }
    }
}
