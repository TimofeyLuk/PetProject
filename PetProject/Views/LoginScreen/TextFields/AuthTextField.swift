//
//  AuthTextField.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import UIKit

class AuthTextField: UIView {
    
    // MARK: - Subviews
    
    let textField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    let messageLabel: UILabel = {
        let label = UILabel()
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.textColor = .placeholderText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Property & Modifiers
    
    var text: String? { textField.text }
    
    func setMessage(_ text: String) {
        messageLabel.text = text
        messageLabel.textColor = .placeholderText
    }
    
    func setErrorMessage(_ text: String) {
        messageLabel.text = text
        messageLabel.textColor = .red
    }
    
    @objc
    private func handleFieldEditing() {
        setMessage("")
    }
    
    // MARK: - Init & Layout
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.borderStyle = .roundedRect
        
        self.textField.addTarget(self, action: #selector(handleFieldEditing), for: .editingDidBegin)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        makeLayoutConstrains()
        super.layoutSubviews()
    }
    
    func makeLayoutConstrains() {
        addSubview(textField)
        addSubview(messageLabel)
        
        textField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        [textField, messageLabel].forEach { view in
            view.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: self.bounds.height / 2).isActive = true
        }
        
    }
}

class TextField: UITextField {

    var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect  = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= padding.right
        return rect
    }
}
