//
//  StoreSortedDealsListView.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 4.05.22.
//

import SwiftUI

struct StoreSortedDealsListView: View {
    
    @ObservedObject var viewModel: StoreSortedDealsListViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.stores) { store in
                    if let cellViewModel = viewModel.cellsViewModels[store.storeID] {
                        StoreSortedDealsListCell(viewModel: cellViewModel)
                    }
                }
            }
        }
    }
}

struct TopDealsListView_Previews: PreviewProvider {
    static var previews: some View {
        StoreSortedDealsListView(
            viewModel: StoreSortedDealsListViewModel(
                apiService: DependencyContainer().cheapSharkAPIService
            )
        )
    }
}
