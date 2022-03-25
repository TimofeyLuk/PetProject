//
//  UserModel.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import Foundation

struct UserModel: Codable {
    var login: String
    var password: String
    
    var isAuthorised = false
}
