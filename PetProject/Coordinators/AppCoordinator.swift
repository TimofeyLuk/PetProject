//
//  AppCoordinator.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var networkService: NetworkService
    
    init(navigationController: UINavigationController, networkService: NetworkService) {
        self.navigationController = navigationController
        self.networkService = networkService
    }
    
    func start() {
        // TODO: check if user authorised
        showLoginView()
    }
    
    func showLoginView() {
        let user = UserModel(login: "", password: "")
        let loginService = LoginService(networkService: networkService)
        let loginViewModel = LoginViewModel(user: user, loginService: loginService)
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        loginVC.loginScreenVM = loginViewModel
        navigationController.pushViewController(loginVC, animated: false)
    }
    
    func showAlert(_ alert: UIAlertController) {
        navigationController.topViewController?.present(alert, animated: true)
    }
    
    func showMainScreen() {
        
    }
}
