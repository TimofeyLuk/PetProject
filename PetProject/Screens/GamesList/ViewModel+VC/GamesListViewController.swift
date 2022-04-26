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
                }
            }.store(in: &cancellables)
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
