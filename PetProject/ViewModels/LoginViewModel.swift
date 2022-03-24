//
//  LoginViewModel.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published private(set) var user: UserModel
    
    init(user: UserModel) {
        self.user = user
    }
    
    func setUserLogin(_ login: String) {
        user.login = login
    }
    
    func setUserPassword(_ password: String) {
        user.password = password
    }
    
    func login() {
        
    }
}
