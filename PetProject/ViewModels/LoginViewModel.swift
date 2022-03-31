//
//  LoginViewModel.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import Foundation

class LoginViewModel {
    
    @Published private(set) var user: UserModel
    @Published private(set) var loginError: LoginError?
    @Published private(set) var isLoginInProgress: Bool = false
    private var loginService: LoginService
    
    init(user: UserModel, loginService: LoginService) {
        self.user = user
        self.loginService = loginService
    }
    
    func setUserLogin(_ login: String) {
        user.login = login
    }
    
    func setUserPassword(_ password: String) {
        user.password = password
    }
    
    func login() {
        isLoginInProgress = true
        Task {
            do {
                let _ = try await loginService.login(user: user)
                user.isAuthorised = true
                self.loginError = nil
            } catch let error {
                if let loginError = error as? LoginError {
                    self.loginError = loginError
                } else {
                    self.loginError = LoginError(type: .network, message: error.localizedDescription)
                }
            }
            isLoginInProgress = false
        }
    }
}
