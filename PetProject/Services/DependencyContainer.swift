//
//  DependencyContainer.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 28.03.22.
//

import Foundation

final class DependencyContainer {
    
    let networkService = NetworkService()
    
    func loginService() -> LoginService {
        LoginService(networkService: self.networkService)
    }
    
    func cheapSharkAPIService() -> CheapSharkService {
        CheapSharkService(networkService: self.networkService)
    }
    
    func loginViewController() -> LoginViewController {
        let user = UserModel(login: "", password: "")
        let loginService = LoginService(networkService: self.networkService)
        let loginViewModel = LoginViewModel(user: user, loginService: loginService)
        let loginVC = LoginViewController()
        loginVC.loginScreenVM = loginViewModel
        return loginVC
    }
    
    func mainViewController() -> MainScreenViewController {
        let mainViewController = MainScreenViewController()
        let mainScreenVM = MainScreenViewModel(apiService: cheapSharkAPIService())
        mainViewController.mainScreenVM = mainScreenVM
        return mainViewController
    }
    
    func gamesScreenViewController(forStore store: StoreModel) -> GamesScreenViewController {
        let gamesListVM = GamesScreenViewModel(store: store, apiService: cheapSharkAPIService())
        let gamesListVC = GamesScreenViewController(gameListVM: gamesListVM)
        return gamesListVC
    }
}
