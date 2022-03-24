//
//  AppCoordinator.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // TODO: check if user authorised
        showLoginView()
    }
    
    func showLoginView() {
        let user = UserModel(login: "", password: "")
        let loginViewModel = LoginViewModel(user: user)
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        loginVC.loginScreenVM = loginViewModel
        navigationController.pushViewController(loginVC, animated: false)
    }
}
