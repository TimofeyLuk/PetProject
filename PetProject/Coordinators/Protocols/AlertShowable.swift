//
//  AlertShowable.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 1.04.22.
//

import UIKit

protocol AlertShowable {
    func showAlert(_ alert: UIAlertController)
    func showErrorAlert(withErrorMessage message: String?, okAction: (() -> Void)?)
}

extension AlertShowable {
    func showErrorAlert(withErrorMessage message: String?, okAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error".localized,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "Ok".localized,
            style: .default,
            handler: { _ in
                okAction?()
            }
        )
        alert.addAction(okAction)
        showAlert(alert)
    }
}
