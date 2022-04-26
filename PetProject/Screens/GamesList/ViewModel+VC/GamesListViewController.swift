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
                    let alert = UIAlertController(title: "Error".localized, message: errorMessage, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok".localized, style: .default) { _ in
                        self?.gameListVM.paginateDealsList()
                    }
                    alert.addAction(okAction)
                    self?.delegate.showAlert(alert)
                }
            }.store(in: &cancellables)
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
