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
    private var factory: DependencyContainer
    
    init(navigationController: UINavigationController, networkService: NetworkService, dependencyContainer: DependencyContainer) {
        self.navigationController = navigationController
        self.networkService = networkService
        self.factory = dependencyContainer
    }
    
    func start() {
        // TODO: check if user authorised
        showLoginView()
    }
    
    private func showLoginView() {
        let loginVC = factory.loginViewController()
        loginVC.delegate = self
        navigationController.pushViewController(loginVC, animated: false)
    }
    
}

extension AppCoordinator: LoginViewControllerDelegate {
    func showMainScreen() {
        let mainViewController = factory.mainViewController()
        mainViewController.delegate = self
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(mainViewController, animated: true)
    }
}

extension AppCoordinator: MainScreenDelegate {
    func chooseStore(_ store: StoreModel) {
        let gamesListVC = factory.gamesScreenViewController(forStore: store)
        navigationController.pushViewController(gamesListVC, animated: true)
    }
}
