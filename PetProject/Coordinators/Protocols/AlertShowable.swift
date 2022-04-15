//
//  AlertShowable.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 1.04.22.
//

import UIKit

protocol AlertShowable {
    func showAlert(_ alert: UIAlertController)
    func showErrorAlert(withErrorMessage message: String?)
}

extension AlertShowable {
    func showErrorAlert(withErrorMessage message: String?) {
        let alert = UIAlertController(title: "Error".localized,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok".localized, style: .cancel)
        alert.addAction(okAction)
        showAlert(alert)
    }
}
