//
//  GamesListView.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 1.04.22.
//

import SwiftUI

struct GamesListView: View {
    @ObservedObject var gameListVM: GamesScreenViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(gameListVM.dealsList) { deal in
                    let image = gameListVM.dealsImages[deal.id]
                    GamesListCell(deal: deal, image: image)
                        .padding([.leading, .trailing, .top])
                }
                if !gameListVM.dealsListIsFull {
                    ProgressView().onAppear {
                        let _ = print("ProgressView onAppear")
                        let _ = gameListVM.paginateDealsList()
                    }
                }
            }
        }
    }
}

struct GamesListView_Previews: PreviewProvider {
    static var previews: some View {
        GamesListView(gameListVM: GamesScreenViewModel(store: StoreModel(storeID: "",
                                                                         storeName: "Store name",
                                                                         isActive: 1,
                                                                         images: StoreModel.Images(banner: "",
                                                                                                   logo: "",
                                                                                                   icon: "")),
                                                       apiService: CheapSharkService(
                                                        networkService: DependencyContainer.shared.networkService
                                                       )
        ))
    }
}
