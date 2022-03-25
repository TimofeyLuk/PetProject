//
//  LoginError.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import Foundation

struct LoginError: Error {
    let type: FailType
    let message: String
    
    enum FailType {
        case login, password, network
    }
}
