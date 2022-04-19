//
//  LoginViewController.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 24.03.22.
//

import UIKit
import Combine

protocol LoginViewControllerDelegate: AnyObject {
    func showMainScreen()
}

class LoginViewController: UIViewController {

    var delegate: (LoginViewControllerDelegate & Coordinator)?
    var loginScreenVM: LoginViewModel!
    let loginForm = LoginFormView()
    
    // MARK: - Constraints
    private var shownKeyBoardBottomAnchor: NSLayoutConstraint?
    private var hiddenKeyBoardBottomAnchor: NSLayoutConstraint?
    private var loginFormHeightAnchor: NSLayoutConstraint?
    private var loginFormBottomAnchorWhenKeyboardShown: NSLayoutConstraint?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loginForm.loginField.textField.delegate = self
        loginForm.passwordField.textField.delegate = self
        loginForm.loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        setupLayout()
        setupLayoutConstraints()
        makeObserving()
    }
    
    @objc
    private func loginAction() {
        loginScreenVM?.login()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Layout
    
    private func setupLayout() {
        view.backgroundColor = .systemBlue
        view.addSubview(loginForm)
        loginForm.backgroundColor = .white
    }
    
    private func setupLayoutConstraints() {
        loginForm.translatesAutoresizingMaskIntoConstraints = false
        loginForm.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        setupLoginFormHeightAnchor()
        hiddenKeyBoardBottomAnchor = loginForm.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        hiddenKeyBoardBottomAnchor?.isActive = true
    }
    
    private func setupLoginFormHeightAnchor() {
        loginFormHeightAnchor?.isActive = false
        if UIDevice.current.orientation.isLandscape {
            loginFormHeightAnchor = loginForm.topAnchor.constraint(equalTo: view.topAnchor)
        } else {
            loginFormHeightAnchor = loginForm.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        }
        loginFormHeightAnchor?.isActive = true
        loginForm.setNeedsLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupLoginFormHeightAnchor()
    }

    // MARK: - Keyboard tracking
    
    @objc
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            hiddenKeyBoardBottomAnchor?.isActive = false
            shownKeyBoardBottomAnchor?.isActive = false
            shownKeyBoardBottomAnchor =  loginForm.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardSize.height)
            shownKeyBoardBottomAnchor?.isActive = true
        }
        setupLoginFormHeightAnchor()
    }

    @objc func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != 0 {
            shownKeyBoardBottomAnchor?.isActive = false
            hiddenKeyBoardBottomAnchor?.isActive = true
        }
        setupLoginFormHeightAnchor()
    }

    @objc
    func keyboardWillChangeFrame(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            hiddenKeyBoardBottomAnchor?.isActive = false
            shownKeyBoardBottomAnchor?.isActive = false
            shownKeyBoardBottomAnchor =  loginForm.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardSize.height)
            shownKeyBoardBottomAnchor?.isActive = true
            setupLoginFormHeightAnchor()
        }
    }
    
    // MARK: - Observing
    
    private func makeObserving() {
        makeViewModelObserving()
        makeNotificationObserving()
    }
    
    private func makeViewModelObserving() {
        loginScreenVM?.$user.receive(on: DispatchQueue.main).sink { [weak self] user in
            guard let self = self else { return }
            if user.isAuthorised {
                self.delegate?.showMainScreen()
            }
        }.store(in: &cancellables)
        
        loginScreenVM?.$loginError.receive(on: DispatchQueue.main).sink { [weak self] loginError in
            guard
                let self = self,
                let loginError = loginError
            else { return }
            switch loginError.type {
            case .login:
                self.loginForm.loginField.setErrorMessage(loginError.message)
            case .password:
                self.loginForm.passwordField.setErrorMessage(loginError.message)
            case .network:
                self.delegate?.showErrorAlert(withErrorMessage: loginError.message)
            }
        }.store(in: &cancellables)
        
       loginScreenVM?.$isLoginInProgress
            .receive(on: DispatchQueue.main)
            .map({ !$0 })
            .assign(to: \.isEnabled, on: loginForm.loginButton)
            .store(in: &cancellables)
        
    }
    
    private func makeNotificationObserving() {
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
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == loginForm.loginField.textField, let login = textField.text {
            loginScreenVM?.setUserLogin(login)
        } else if textField == loginForm.passwordField.textField, let password = textField.text {
            loginScreenVM?.setUserPassword(password)
        }
    }
    
}
