//
//  StoreSortedDealsListCell.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 4.05.22.
//

import SwiftUI

struct StoreSortedDealsListCell: View {
    
    @StateObject var viewModel: StoreSortedListCellViewModel
    @State private var isDealsListShown = false
    
    var body: some View {
        VStack(alignment: .leading) {
            mainInfo
            if isDealsListShown {
                dealsList
            }
        }
    }
    
    var mainInfo: some View {
        HStack {
            storeLogo
            VStack(alignment: .leading) {
                Text(viewModel.store.storeName)
                    .font(.title)
                Text("Number of deals".localized + ": \(viewModel.storeDeals.count)")
            }
            .padding(.horizontal)
            Spacer()
            turnButton
        }
    }
    
    var storeLogo: some View {
        Group {
            if let storeLogoImage = viewModel.storeLogoImage {
                Image(uiImage: storeLogoImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: Constants.imageSize,
                        height: Constants.imageSize,
                        alignment: .center
                    )
                    .shadow(
                        color: .gray,
                        radius: Constants.cornerRadius
                    )
                    .padding()
            } else {
                EmptyView()
            }
        }
    }
    
    var turnButton: some View {
        let imageName = isDealsListShown ? "chevron.up" : "chevron.down"
        return Image(systemName: imageName)
            .font(.title2)
            .onTapGesture {
                withAnimation { isDealsListShown.toggle() }
            }
    }
    
    var dealsList: some View {
        HStack {
            Divider()
            VStack {
                ForEach(viewModel.storeDeals) { deal in
                    GamesListCell(
                        deal: deal,
                        image: viewModel.dealsImages[deal.id]
                    )
                }
            }
        }
        .padding(.leading, Constants.dealsListPaddind)
    }
    
    private struct Constants {
        static let imageSize: CGFloat = 64
        static let cornerRadius: CGFloat = 7
        static let dealsListPaddind: CGFloat = 45
    }
}






struct TopDealsListCell_Previews: PreviewProvider {
    static var previews: some View {
        StoreSortedDealsListCell(
            viewModel: StoreSortedListCellViewModel(
                store: StoreModel(
                    storeID: "1",
                    storeName: "store name",
                    isActive: 1,
                    images: StoreModel.Images(
                        banner: "",
                        logo: "",
                        icon: ""
                    )
                ),
                apiService: CheapSharkService(
                    networkService: NetworkService()
                ),
                storeDeals: [])
        )
    }
}
