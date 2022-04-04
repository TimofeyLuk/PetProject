//
//  DealModel.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 31.03.22.
//

import Foundation

struct DealModel: Codable {
    let internalName: String?
    let title: String?
    let metacriticLink: String?
    let dealID: String?
    let storeID: String?
    let gameID: String?
    let salePrice: String?
    let normalPrice: String?
    let isOnSale: String?
    let savings: String?
    let metacriticScore: String?
    let steamRatingText: String?
    let steamRatingPercent: String?
    let steamRatingCount: String?
    let steamAppID: String?
    let releaseDate: Int?
    let lastChange: Int?
    let dealRating: String?
    let thumb: String?
}
