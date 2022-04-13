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
                        .frame(width: 120,
                               height: 45,
                               alignment: .center)
                }
                Text(deal.title ?? "No title")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)
                Spacer()
                turnButton
            }
            mainInfoView
            if fullInfoShown {
                fullInfoView
            }
        }
    }
    
    var mainInfoView: some View {
        let salePrice = Double(deal.salePrice ?? "") ?? 0
        return HStack {
            if salePrice > 0 {
                HStack {
                    Text("Sale price".localized + ": ")
                    Text(String(format: "%.2f", salePrice))
                }
            }
            Spacer()
            HStack {
                Text("Price".localized + ": ")
                Text(deal.normalPrice ?? "-")
                    .strikethrough(salePrice > 0)
            }
        }
    }
    
    var fullInfoView: some View {
        VStack {
            Divider().foregroundColor(.blue)
            HStack(alignment: .top) {
                raitingsView
                Spacer()
                infoView
            }
        }
    }
    
    var raitingsView: some View {
        VStack(alignment: .leading) {
            Text("Raitings".localized + " ").fontWeight(.heavy)
            if let metacriticScore = deal.metacriticScore {
                Text("Metacritic: \(metacriticScore)")
            }
            if let steamRatingPercent = deal.steamRatingPercent {
                Text("Steam: \(steamRatingPercent)")
            }
            if let dealRating = deal.dealRating {
                Text("Deal rating".localized + ": \(dealRating)")
            }
        }
        .multilineTextAlignment(.leading)
        .minimumScaleFactor(0.5)
    }
    
    var infoView: some View {
        return VStack(alignment: .trailing) {
            Text("Info".localized + " ").fontWeight(.heavy)
            if let releaseDate = deal.releaseDate {
                let date = Date(timeIntervalSince1970: TimeInterval(releaseDate))
                Text("Release date".localized + ": \(date.toString())")
            }
            if let lastChange = deal.lastChange {
                let date = Date(timeIntervalSince1970: TimeInterval(lastChange))
                Text("Last change" + " : \(date.toString())")
            }
        }
        .multilineTextAlignment(.leading)
        .minimumScaleFactor(0.5)
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
