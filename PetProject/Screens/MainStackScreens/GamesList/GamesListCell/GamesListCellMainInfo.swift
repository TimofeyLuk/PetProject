//
//  GamesListCellMainInfo.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 14.04.22.
//

import SwiftUI

struct GamesListCellMainInfo: View {
    var deal: DealModel
    
    var body: some View {
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
    
}
