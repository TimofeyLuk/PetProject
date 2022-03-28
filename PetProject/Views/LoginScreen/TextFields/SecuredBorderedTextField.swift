//
//  SecuredBorderedTextField.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import UIKit

class SecuredBorderedTextField: BorderedTextField {
    
    private lazy var showPassButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.addTarget(self, action: #selector(changePassVisibility), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textField.rightView = showPassButton
        self.textField.rightViewMode = .always
        self.textField.isSecureTextEntry = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func changePassVisibility() {
        if self.textField.isSecureTextEntry {
            self.textField.isSecureTextEntry = false
            showPassButton.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            self.textField.isSecureTextEntry = true
            showPassButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
}
