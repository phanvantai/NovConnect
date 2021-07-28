//
//  ResetPasswordViewController.swift
//  NovConnect
//
//  Created by Tai Phan Van on 27/07/2021.
//

import UIKit

protocol ResetPasswordViewControllerDelegate: AnyObject {
    func didSendResetPasswordLink(_ controller: ResetPasswordViewController)
}

class ResetPasswordViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel = ResetPasswordViewModel()
    var email: String?
    
    weak var delegate: ResetPasswordViewControllerDelegate?
    
    // MARK: - Views
    private lazy var iconImageView = CustomAuthImageView()
    private lazy var emailTextField = CustomAuthTextField(placeholder: "Email")
    private lazy var resetButton = CustomAuthActionButton(title: "Reset password")
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
        addActions()
        
        configureNotificationObservers()
    }
    
    func configureUI() {
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        view.addSubview(iconImageView)
        iconImageView.centerX(inView: self.view)
        iconImageView.setDimensions(height: 80, width: self.view.frame.width * 2 / 3)
        iconImageView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, paddingTop: 160)
        
        view.addSubview(emailTextField)
        emailTextField.text = email
        emailTextField.keyboardType = .emailAddress
        emailTextField.anchor(top: iconImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(resetButton)
        resetButton.anchor(top: emailTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        viewModel.email = email
        updateForm()
    }
    
    func addActions() {
        resetButton.addTarget(self, action: #selector(resetPasswordButtonOnClick), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonOnClick), for: .touchUpInside)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc func resetPasswordButtonOnClick() {
        print(#function)
        guard let email = emailTextField.text else { return }
        showLoading(true)
        AuthService.resetPassword(withEmail: email) { error in
            self.showLoading(false)
            if let error = error {
                DebugLog(error.localizedDescription)
                self.showMessage(withTitle: "Reset Password Error", message: error.localizedDescription)
            }
            self.delegate?.didSendResetPasswordLink(self)
        }
    }
    
    @objc func backButtonOnClick() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField ) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        updateForm()
    }
}

// MARK: - FormProtocol
extension ResetPasswordViewController: FormProtocol {
    func updateForm() {
        resetButton.backgroundColor = viewModel.buttonBackgroundColor
        resetButton.isEnabled = viewModel.formIsValid
    }
}
