//
//  LoginViewController.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Subviews
    weak var coordinator: AppCoordinator?
    var loginScreenVM: LoginViewModel?
    let loginForm = LoginFormView()
    
    private var currentKeyboardHeigh: CGFloat = 0
    private var loginFormBottomAnchorWhenKeyboardShown: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LoginViewController.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LoginViewController.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Layout
    
    func setupLayout() {
        view.backgroundColor = .systemBlue
        view.addSubview(loginForm)
        
        loginForm.backgroundColor = .white
        loginForm.translatesAutoresizingMaskIntoConstraints = false
        loginForm.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        loginForm.heightAnchor.constraint(equalToConstant: view.bounds.height / 2).isActive = true
        loginForm.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    // MARK: - Keyboard tracking
    
    @objc
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
                self.currentKeyboardHeigh = keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            self.currentKeyboardHeigh = 0
        }
    }

    @objc
    func keyboardWillChangeFrame(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.size.height
            let deltaKeyboard = keyboardHeight - currentKeyboardHeigh
            if deltaKeyboard > 0 && deltaKeyboard < 100 {
                self.view.frame.origin.y -= abs(deltaKeyboard)
                self.currentKeyboardHeigh = keyboardHeight
                return
            }
            if deltaKeyboard < 0 && deltaKeyboard > -100 {
                self.view.frame.origin.y += abs(deltaKeyboard)
                self.currentKeyboardHeigh = keyboardHeight
                return
            }
        }
    }
}

