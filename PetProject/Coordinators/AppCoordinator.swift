//
//  AppCoordinator.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    private(set) var navigationController: UINavigationController
    private var networkService: NetworkService
    
    init(navigationController: UINavigationController, networkService: NetworkService) {
        self.navigationController = navigationController
        self.networkService = networkService
    }
    
    func start() {
        // TODO: check if user authorised
        showLoginView()
    }
    
    private func showLoginView() {
        let user = UserModel(login: "", password: "")
        let loginService = LoginService(networkService: networkService)
        let loginViewModel = LoginViewModel(user: user, loginService: loginService)
        let loginVC = LoginViewController()
        loginVC.delegate = self
        loginVC.loginScreenVM = loginViewModel
        navigationController.pushViewController(loginVC, animated: false)
    }
    
}

extension AppCoordinator: LoginViewControllerDelegate {
    func showMainScreen() {
        let mainViewController = MainScreenViewController()
        let mainScreenVM = MainScreenViewModel()
        mainViewController.mainScreenVM = mainScreenVM
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(mainViewController, animated: true)
    }
}
