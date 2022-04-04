//
//  DateExtensions.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 1.04.22.
//

import Foundation

extension Date {
    func toString(withFormat format: String = "dd-MM-yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
