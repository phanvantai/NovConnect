//
//  LoginViewController.swift
//  NovConnect
//
//  Created by Tai Phan Van on 17/07/2021.
//

import UIKit

protocol AuthenticationDelgate: AnyObject {
    func authenticationDidFinish()
}

class LoginViewController: UIViewController {
    
    // MARK: - Views
    private let instaImageView = CustomAuthImageView()
    private let emailTextField = CustomAuthTextField(placeholder: "Email")
    private let passwordTextField = CustomAuthTextField(placeholder: "Password")
    private let loginButton = CustomAuthActionButton(title: "Log In")
    private let forgotPassButton = CustomAuthTextButton(title: "Forgotten password?")
    private let dontHaveAccountLabel = CustomAuthLabel(label: "Don't have an account?")
    private let signUpButton = CustomAuthTextButton(title: "Sign Up")
    private let bottomLine = CustomAuthLineView()
    
    // MARK: - Properties
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelgate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        addActions()
        
        configuteNotificationObservers()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(instaImageView)
        instaImageView.centerX(inView: self.view)
        instaImageView.setDimensions(height: 80, width: self.view.frame.width * 2 / 3)
        instaImageView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, paddingTop: 160)
        
        view.addSubview(emailTextField)
        emailTextField.keyboardType = .emailAddress
        emailTextField.anchor(top: instaImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(passwordTextField)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.anchor(top: emailTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(forgotPassButton)
        forgotPassButton.anchor(top: passwordTextField.bottomAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 16)
        
        view.addSubview(loginButton)
        loginButton.isEnabled = false
        loginButton.anchor(top: forgotPassButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        let stackView = UIStackView(arrangedSubviews: [dontHaveAccountLabel, signUpButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        view.addSubview(stackView)
        stackView.centerX(inView: self.view)
        stackView.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
        
        view.addSubview(bottomLine)
        bottomLine.anchor(bottom: stackView.topAnchor, paddingBottom: 24)
        bottomLine.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
    }
    
    func addActions() {
        loginButton.addTarget(self, action: #selector(logInOnClick), for: .touchUpInside)
        forgotPassButton.addTarget(self, action: #selector(forgotPasswordOnClick), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpOnClick), for: .touchUpInside)
    }
    
    func configuteNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    // MARK: - Actions
    @objc func logInOnClick() {
        print(#function)
        doLogin()
    }
    
    func doLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        AuthService.logIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.delegate?.authenticationDidFinish()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func forgotPasswordOnClick() {
        print(#function)
    }
    
    @objc func signUpOnClick() {
        print(#function)
        let registerVC = RegistrationViewController()
        registerVC.delegate = self.delegate
        self.show(registerVC, sender: self)
        //navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }
    
    @objc func textDidChange(sender: UITextField ) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        updateForm()
    }
}

// MARK: - FormProtocol
extension LoginViewController: FormProtocol {
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.isEnabled = viewModel.formIsValid
    }
}
