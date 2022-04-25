//
//  GamesListCellFullInfo.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 14.04.22.
//

import SwiftUI

struct GamesListCellFullInfo: View {
    
    var deal: DealModel
    
    var body: some View {
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
    
}
