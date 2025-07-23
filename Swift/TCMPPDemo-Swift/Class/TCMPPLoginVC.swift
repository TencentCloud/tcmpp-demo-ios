//
//  TCMPPLoginVC.swift
//  TCMPPDemo-Swift
//
//  Created by gavinjwxu on 2024/8/13.
//

import UIKit

class TCMPPLoginVC: UIViewController {
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "tcmpp_logo")
        return imageView
    }()
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 45)
        label.text = "TCMPP"
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.text = "A platform that takes your App to the next level"
        return label
    }()
    
    private lazy var textFieldBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.tcmpp_color(withHex: "#F4F4F4")
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = NSLocalizedString("Please enter the username", comment: "")
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.tcmpp_color(withHex: "#006EFF")
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.setTitle(NSLocalizedString("Log in", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(logoImageView)
        view.addSubview(logoLabel)
        view.addSubview(detailLabel)
        view.addSubview(textFieldBackgroundView)
        textFieldBackgroundView.addSubview(usernameTextField)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            // Logo image constraints
            logoImageView.widthAnchor.constraint(equalToConstant: 50),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -82), // (218/2 - 27)
            
            // Logo label constraints
            logoLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 10),
            logoLabel.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            logoLabel.widthAnchor.constraint(equalToConstant: 155),
            logoLabel.heightAnchor.constraint(equalToConstant: 50),
            
            // Detail label constraints
            detailLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 15),
            detailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailLabel.widthAnchor.constraint(equalToConstant: 325),
            detailLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // Text field background view constraints
            textFieldBackgroundView.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 50),
            textFieldBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldBackgroundView.widthAnchor.constraint(equalToConstant: 320),
            textFieldBackgroundView.heightAnchor.constraint(equalToConstant: 54),
            
            // Username text field constraints
            usernameTextField.leadingAnchor.constraint(equalTo: textFieldBackgroundView.leadingAnchor, constant: 15),
            usernameTextField.trailingAnchor.constraint(equalTo: textFieldBackgroundView.trailingAnchor, constant: -15),
            usernameTextField.topAnchor.constraint(equalTo: textFieldBackgroundView.topAnchor, constant: 15),
            usernameTextField.bottomAnchor.constraint(equalTo: textFieldBackgroundView.bottomAnchor, constant: -15),
            
            // Login button constraints
            loginButton.topAnchor.constraint(equalTo: textFieldBackgroundView.bottomAnchor, constant: 30),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 320),
            loginButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }

    @objc private func login() {
        usernameTextField.resignFirstResponder()
        guard let text = usernameTextField.text, !text.isEmpty else { return }
        
        TCMPPDemoLoginManager.shared.loginUser(userId: text) { err, value in
            if err == nil {
                DispatchQueue.main.async {
                    // Save user info for auto-login
                    TCMPPUserInfo.shared.nickName = self.usernameTextField.text
                    if let token = value {
                        TCMPPUserInfo.shared.token = token
                    }
                    
                    let rootViewController = TCMPPMainVC()
                    let navGationController = UINavigationController(rootViewController: rootViewController)
                    UIApplication.shared.keyWindow?.rootViewController = navGationController
                    if #available(iOS 13.0, *) {
                        let appearance = UINavigationBarAppearance()
                        appearance.backgroundColor = .white
                        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
                        appearance.shadowColor = .clear
                        navGationController.navigationBar.standardAppearance = appearance
                        navGationController.navigationBar.scrollEdgeAppearance = appearance
                    } else {
                        navGationController.navigationBar.barTintColor = .white
                        navGationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
                    }
                    let icon = UIImage(named: "success")
                    let toast = ToastView(icon: icon!, title: NSLocalizedString("Logged in successfully", comment: ""))
                    toast.show(withDuration: 2)
                }
            }
        }
    }
}
