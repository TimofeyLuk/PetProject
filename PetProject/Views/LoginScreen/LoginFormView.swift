//
//  LoginFormView.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import UIKit

class LoginFormView: UIView {
    
    // MARK: - Subviews
    
    let loginField: AuthTextField = {
        let authField = AuthTextField()
        authField.textField.placeholder = "login"
        return authField
    }()
    
    let passwordField: PasswordTextField = {
        let passwordField = PasswordTextField()
        passwordField.textField.placeholder = "password"
        return passwordField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        return button
    }()
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        makeLayoutConstrains()
        super.layoutSubviews()
    }
    
    func makeLayoutConstrains() {
        addSubview(loginField)
        addSubview(passwordField)
        addSubview(loginButton)
        
        [loginField, passwordField].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -Constants.horizontalSpacing).isActive = true
            view.heightAnchor.constraint(equalToConstant: self.bounds.height / 3).isActive = true
            view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
        
        loginField.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.verticalSpacing).isActive = true
        passwordField.topAnchor.constraint(equalTo: loginField.bottomAnchor).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: Constants.verticalSpacing * 2).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.verticalSpacing * 2).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: self.bounds.width / 2).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loginButton.layer.cornerRadius = Constants.cornerRadius
    }
    
    private struct Constants {
        static let verticalSpacing: CGFloat = 10
        static let horizontalSpacing: CGFloat = 10
        static let cornerRadius: CGFloat = 7
    }
}
