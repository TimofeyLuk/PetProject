//
//  Coordinator.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
