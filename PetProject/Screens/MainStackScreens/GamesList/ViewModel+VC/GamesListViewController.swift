//
//  GamesListViewController.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 1.04.22.
//

import UIKit
import SwiftUI
import Combine

protocol GamesListDelegate { }

final class GamesListViewController: UIHostingController<GamesListView>, UISearchBarDelegate {
    
    private let gameListVM: GamesListViewModel
    typealias GamesListViewControllerDelegate = (GamesListDelegate & AlertShowable)
    private let delegate: GamesListViewControllerDelegate
    private var cancellables: Set<AnyCancellable> = []
    
    init(gameListVM: GamesListViewModel, delegate: GamesListViewControllerDelegate) {
        self.gameListVM = gameListVM
        self.delegate = delegate
        let gameListView = GamesListView(gameListVM: gameListVM)
        super.init(rootView: gameListView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD:PetProject/Screens/MainStackScreens/GamesList/ViewModel+VC/GamesListViewController.swift
        self.title = gameListVM.store.storeName
        gameListVM.$errorMessage.sink { [weak self] message in
            if let errorMessage = message {
                let alert = UIAlertController(title: "Error".localized, message: errorMessage, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok".localized, style: .default) { _ in
                    DispatchQueue.main.async {
                        self?.gameListVM.paginateDealsList()
                    }
=======
        gameListVM.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                if let errorMessage = message {
                    self?.delegate.showErrorAlert(
                        withErrorMessage: errorMessage,
                        okAction: {
                            self?.gameListVM.paginateDealsList()
                        }
                    )
>>>>>>> search:PetProject/Screens/GamesList/ViewModel+VC/GamesListViewController.swift
                }
            }.store(in: &cancellables)
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
