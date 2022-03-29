//
//  StringExtensions.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 29.03.22.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "\(self)_comment")
    }
}
