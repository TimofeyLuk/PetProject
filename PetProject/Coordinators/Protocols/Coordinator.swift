//
//  Coordinator.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
    func showAlert(_ alert: UIAlertController)
}

extension Coordinator {
    func showAlert(_ alert: UIAlertController) {
        navigationController.topViewController?.present(alert, animated: true)
    }
}
