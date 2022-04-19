//
//  GamesListViewController.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 1.04.22.
//

import UIKit
import SwiftUI

class GamesListViewController: UIHostingController<GamesListView> {
    init(gameListVM: GamesListViewModel) {
        let gameListView = GamesListView(gameListVM: gameListVM)
        super.init(rootView: gameListView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
