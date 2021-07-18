//
//  RegistrationViewController.swift
//  NovConnect
//
//  Created by Tai Phan Van on 17/07/2021.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - Views
    private let instaImageView = CustomAuthImageView()
    private let emailTextField = CustomAuthTextField(placeholder: "Email")
    private let passwordTextField = CustomAuthTextField(placeholder: "Password")
    private let fullNameTextField = CustomAuthTextField(placeholder: "Fullname")
    private let userNameTextField = CustomAuthTextField(placeholder: "Username")
    private let signUpButton = CustomAuthActionButton(title: "Sign Up")
    private let alreadyHaveAccountLabel = CustomAuthLabel(label: "Already have an account?")
    private let signInButton = CustomAuthTextButton(title: "Sign In")
    private let bottomLine = CustomAuthLineView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        addActions()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullNameTextField, userNameTextField, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        
        view.addSubview(instaImageView)
        instaImageView.centerX(inView: view)
        instaImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 64)
        instaImageView.setDimensions(height: 80, width: self.view.frame.width * 2 / 3)
        
        view.addSubview(stackView)
        stackView.anchor(top: instaImageView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingRight: 16)
        
        let bottomView = UIStackView(arrangedSubviews: [alreadyHaveAccountLabel, signInButton])
        bottomView.axis = .horizontal
        bottomView.spacing = 8
        
        view.addSubview(bottomView)
        bottomView.centerX(inView: self.view)
        bottomView.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
        
        view.addSubview(bottomLine)
        bottomLine.anchor(bottom: bottomView.topAnchor, paddingBottom: 24)
        bottomLine.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
    }
    
    func addActions() {
        signInButton.addTarget(self, action: #selector(signInOnClick), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpOnClick), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func signUpOnClick() {
        print(#function)
    }
    
    @objc func signInOnClick() {
        print(#function)
        navigationController?.popViewController(animated: true)
    }
}
