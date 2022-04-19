//
//  AppDelegate.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        let navigationController = UINavigationController()
        let networkService = NetworkService()
        let dependencyContainer = DependencyContainer()
        
        self.coordinator = AppCoordinator(navigationController: navigationController,
                                          networkService: networkService,
                                          dependencyContainer: dependencyContainer)
        coordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

