//
//  GamesListView.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 1.04.22.
//

import SwiftUI

struct GamesListView: View {
    
    @ObservedObject var gameListVM: GamesListViewModel
    @State var searchableText: String = ""
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchableText,
                      onCommit: { gameListVM.search(searchableText) },
                      onCancel: { gameListVM.search("") })
            gamesList
        }
    }
    
    private var gamesList: some View {
        ScrollView {
            LazyVStack {
                ForEach(gameListVM.dealsList) { deal in
                    let image = gameListVM.dealsImages[deal.id]
                    GamesListCell(deal: deal, image: image).padding()
                }
                if !gameListVM.dealsListIsFull {
                    ProgressView().onAppear {
                        gameListVM.paginateDealsList()
                    }
                }
            }
        }
    }
    
}

struct GamesListView_Previews: PreviewProvider {
    static var previews: some View {
        GamesListView(gameListVM: GamesListViewModel(store: StoreModel(storeID: "",
                                                                       storeName: "Store name",
                                                                       isActive: 1,
                                                                       images: StoreModel.Images(banner: "", logo: "", icon: "")),
                                                     apiService: CheapSharkService( networkService: NetworkService())
        ))
    }
}
