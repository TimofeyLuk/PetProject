//
//  GamesListCell.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 1.04.22.
//

import SwiftUI

struct GamesListCell: View {
    
    var deal: DealModel
    var image: UIImage?
    @State private var fullInfoShown: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(maxWidth: 200,
                               maxHeight: 200,
                               alignment: .center)
                        .aspectRatio(contentMode: .fit)
                }
                Text(deal.title ?? "No title")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)
                Spacer()
                turnButton
            }
            GamesListCellMainInfo(deal: deal)
            if fullInfoShown {
                GamesListCellFullInfo(deal: deal)
            }
        }
    }
    
    var turnButton: some View {
        let imageName = fullInfoShown ? "chevron.up" : "chevron.down"
        return Image(systemName: imageName)
            .font(.title2)
            .onTapGesture {
                withAnimation { fullInfoShown.toggle() }
            }
    }
    
}




struct GamesListCell_Previews: PreviewProvider {
    static var previews: some View {
        GamesListCell(deal: DealModel(internalName: "DEUSEXHUMANREVOLUTIONDIRECTORSCUT",
                                                title: "Deus Ex: Human Revolution - Director's Cut",
                                                metacriticLink: "/game/pc/deus-ex-human-revolution---directors-cut",
                                                dealID: "HhzMJAgQYGZ%2B%2BFPpBG%2BRFcuUQZJO3KXvlnyYYGwGUfU%3D",
                                                storeID: "1",
                                                gameID: "102249",
                                                salePrice: "2.99",
                                                normalPrice: "19.99",
                                                isOnSale: "1",
                                                savings: "85.042521",
                                                metacriticScore: "91",
                                                steamRatingText: "Very Positive",
                                                steamRatingPercent: "92",
                                                steamRatingCount: "17993",
                                                steamAppID: "238010",
                                                releaseDate: 1382400000,
                                                lastChange: 1621536418,
                                                dealRating: "9.6",
                                                thumb: "https://cdn.cloudflare.steamstatic.com/steam/apps/238010/capsule_sm_120.jpg?t=1619788192"))
    }
}
