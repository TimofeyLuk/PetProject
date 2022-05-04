//
//  AppCoordinator.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    private(set) var tabBarController: UITabBarController
    private var mainNavigationController = UINavigationController()
    private var searchNavigationController = UINavigationController()
    private var networkService: NetworkService
    private var factory: DependencyContainer
    var rootViewController: UIViewController { tabBarController as UIViewController }
    
    init(tabBarController: UITabBarController, networkService: NetworkService, dependencyContainer: DependencyContainer) {
        self.tabBarController = tabBarController
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
        loginVC.modalPresentationStyle = .fullScreen
        tabBarController.setViewControllers([mainNavigationController], animated: false)
        mainNavigationController.pushViewController(loginVC, animated: true)
    }
    
    func showAlert(_ alert: UIAlertController) {
        let selectedViewController = tabBarController.selectedViewController
        if let navigationController = selectedViewController as? UINavigationController {
            navigationController.topViewController?.present(alert, animated: true)
        } else {
            selectedViewController?.present(alert, animated: true)
        }
    }
}

extension AppCoordinator: LoginViewControllerDelegate {
    func showMainScreen() {
        let mainViewController = factory.mainViewController()
        mainViewController.delegate = self

        mainNavigationController.tabBarItem = UITabBarItem(
            title: "Stores".localized,
            image: UIImage(systemName: "cart"),
            selectedImage: UIImage(systemName: "cart.fill")
        )
        mainNavigationController.viewControllers.removeAll()
        mainNavigationController.pushViewController(mainViewController, animated: true)
        
        searchNavigationController.tabBarItem = UITabBarItem(
            title: "Search".localized,
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        searchNavigationController.viewControllers.removeAll()
        
        tabBarController.viewControllers?.removeAll()
        tabBarController.setViewControllers([mainNavigationController, searchNavigationController], animated: true)
        tabBarController.selectedIndex = 0
    }
}

extension AppCoordinator: MainScreenDelegate {
    func chooseStore(_ store: StoreModel) {
        let gamesListVC = factory.gamesListViewController(forStore: store, delegate: self)
        mainNavigationController.pushViewController(gamesListVC, animated: true)
    }
}

extension AppCoordinator: GamesListDelegate {}
