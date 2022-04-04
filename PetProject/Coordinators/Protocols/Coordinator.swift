//
//  Coordinator.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import UIKit

protocol Coordinator: AlertShowable {
    var navigationController: UINavigationController { get }
    func start()
}

extension Coordinator {
    func showAlert(_ alert: UIAlertController) {
        navigationController.topViewController?.present(alert, animated: true)
    }
}
