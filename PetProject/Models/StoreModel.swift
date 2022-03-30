//
//  StoreModel.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 29.03.22.
//

import Foundation

struct StoreModel: Codable {
    let storeID: String
    let storeName: String
    let isActive: Int
    let images: Images
    
    struct Images: Codable {
        let banner: String
        let logo: String
        let icon: String
    }
}
