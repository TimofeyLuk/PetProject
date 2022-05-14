//
//  SearchScreenVC.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 4.05.22.
//

import UIKit
import SwiftUI

final class SearchScreenViewControlller: UIHostingController<SearchScreenView> {
    
    init(viewModel: SearchScreenViewModel) {
        let searchScreen = SearchScreenView(viewModel: viewModel)
        super.init(rootView: searchScreen)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
