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
        let loginVC = DependencyContainer.shared.loginViewController
        loginVC.delegate = self
        navigationController.pushViewController(loginVC, animated: false)
    }
    
}

extension AppCoordinator: LoginViewControllerDelegate {
    func showMainScreen() {
        let mainViewController = DependencyContainer.shared.mainViewController
        mainViewController.delegate = self
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(mainViewController, animated: true)
    }
}

extension AppCoordinator: MainScreenDelegate {
    func chooseStore(_ store: StoreModel) {
        let gamesListVC = DependencyContainer.shared.gamesScreenViewController(forStore: store)
        navigationController.pushViewController(gamesListVC, animated: true)
    }
}
