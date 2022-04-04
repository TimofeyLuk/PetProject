//
//  GamesScreenViewController.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 1.04.22.
//

import UIKit
import SwiftUI

class GamesScreenViewController: UIHostingController<GamesListView> {
    init(gameListVM: GamesScreenViewModel) {
        let gameListView = GamesListView(gameListVM: gameListVM)
        super.init(rootView: gameListView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
