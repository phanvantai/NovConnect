//
//  RegistrationViewController.swift
//  NovConnect
//
//  Created by Tai Phan Van on 17/07/2021.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - Views
    //private let instaImageView = CustomAuthImageView()
    private let pickPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    private let emailTextField = CustomAuthTextField(placeholder: "Email")
    private let passwordTextField = CustomAuthTextField(placeholder: "Password")
    private let fullNameTextField = CustomAuthTextField(placeholder: "Fullname")
    private let userNameTextField = CustomAuthTextField(placeholder: "Username")
    private let signUpButton = CustomAuthActionButton(title: "Sign Up")
    private let alreadyHaveAccountLabel = CustomAuthLabel(label: "Already have an account?")
    private let signInButton = CustomAuthTextButton(title: "Sign In")
    private let bottomLine = CustomAuthLineView()
    
    // MARK: - Properties
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    weak var delegate: AuthenticationDelgate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        addActions()
        configureNotificationObservers()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullNameTextField, userNameTextField, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        
        //view.addSubview(instaImageView)
        //instaImageView.centerX(inView: view)
        //instaImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 64)
        //instaImageView.setDimensions(height: 80, width: self.view.frame.width * 2 / 3)
        
        view.addSubview(pickPhotoButton)
        pickPhotoButton.centerX(inView: view)
        pickPhotoButton.setDimensions(height: 140, width: 140)
        pickPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        signUpButton.isEnabled = false
        passwordTextField.isSecureTextEntry = true
        emailTextField.keyboardType = .emailAddress
        
        view.addSubview(stackView)
        stackView.anchor(top: pickPhotoButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingRight: 16)
        
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
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func addActions() {
        signInButton.addTarget(self, action: #selector(signInOnClick), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpOnClick), for: .touchUpInside)
        pickPhotoButton.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func handleProfilePhotoSelect() {
        print(#function)
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc func signUpOnClick() {
        print(#function)
        signUp()
    }
    
    @objc func signInOnClick() {
        print(#function)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        switch sender {
        case emailTextField:
            viewModel.email = sender.text
        case passwordTextField:
            viewModel.password = sender.text
        case fullNameTextField:
            viewModel.fullname = sender.text
        case userNameTextField:
            viewModel.username = sender.text
        default:
            print(sender)
        }
        updateForm()
    }
    
    // MARK: - Functions
    func signUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let username = userNameTextField.text?.lowercased() else { return }
        guard let image = profileImage else { return }
        
        let credential = AuthCredential(email: email, password: password, fullname: fullname, username: username, profileImage: image)
        
        AuthService.register(withCredential: credential) { error in
            if let error = error {
                //
                return
            }
            self.delegate?.authenticationDidFinish()
        }
    }
}

// MARK: - FormProtocol
extension RegistrationViewController: FormProtocol {
    func updateForm() {
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.isEnabled = viewModel.formIsValid
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selected = info[.editedImage] as? UIImage else { return }
        profileImage = selected
        
        pickPhotoButton.layer.cornerRadius = pickPhotoButton.frame.width / 2
        pickPhotoButton.layer.masksToBounds = true
        pickPhotoButton.layer.borderColor = UIColor.lightGray.cgColor
        pickPhotoButton.layer.borderWidth = 2
        pickPhotoButton.setImage(selected.withRenderingMode(.alwaysOriginal), for: .normal)
        
        picker.dismiss(animated: true, completion: nil)
    }
}
