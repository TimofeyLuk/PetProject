//
//  DependencyContainer.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 28.03.22.
//

import Foundation

final class DependencyContainer {
    static let shared = DependencyContainer()
    
    let networkService = NetworkService()
    private(set) lazy var loginService = LoginService(networkService: self.networkService)
    private(set) lazy var cheapSharkAPIService = CheapSharkService(networkService: self.networkService)
    
    private(set) lazy var loginViewController: LoginViewController = {
        let user = UserModel(login: "", password: "")
        let loginService = LoginService(networkService: self.networkService)
        let loginViewModel = LoginViewModel(user: user, loginService: loginService)
        let loginVC = LoginViewController()
        loginVC.loginScreenVM = loginViewModel
        return loginVC
    }()
    
    
    private(set) lazy var mainViewController: MainScreenViewController = {
        let mainViewController = MainScreenViewController()
        let apiService = self.cheapSharkAPIService
        let mainScreenVM = MainScreenViewModel(apiService: apiService)
        mainViewController.mainScreenVM = mainScreenVM
        return mainViewController
    }()
    
    func gamesScreenViewController(forStore store: StoreModel) -> GamesScreenViewController {
        let apiService = DependencyContainer.shared.cheapSharkAPIService
        let gamesListVM = GamesScreenViewModel(store: store, apiService: apiService)
        let gamesListVC = GamesScreenViewController(gameListVM: gamesListVM)
        return gamesListVC
    }
}
