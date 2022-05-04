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
    
        let tabBarController = UITabBarController()
        let networkService = NetworkService()
        let dependencyContainer = DependencyContainer()
        
        self.coordinator = AppCoordinator(tabBarController: tabBarController,
                                          networkService: networkService,
                                          dependencyContainer: dependencyContainer)
        coordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

}

