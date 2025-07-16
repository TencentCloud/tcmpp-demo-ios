//
//  TCMPPUserInfoEditVC.swift
//  TCMPPDemo-Swift
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024 Tencent. All rights reserved.
//

import UIKit
import Photos
import TCMPPSDK

class TCMPPUserInfoEditVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var tableView: UITableView!
    private var userInfo: TCMPPUserInfo!
    private var avatarImageView: UIImageView!
    private var nicknameTextField: UITextField!
    private var emailTextField: UITextField!
    private var phoneTextField: UITextField!
    private var avatarData: Data?
    private var loadingToast: ToastView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Edit User Information", comment: "")
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.systemBackground
        } else {
            self.view.backgroundColor = UIColor.white
        }
        
        userInfo = TCMPPUserInfo.shared
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let saveButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        if #available(iOS 13.0, *) {
            tableView.backgroundColor = UIColor.systemGroupedBackground
        } else {
            tableView.backgroundColor = UIColor.groupTableViewBackground
        }
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func saveButtonTapped() {
        saveUserInfo()
    }
    
    private func saveUserInfo() {
        let nickname = nicknameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        showLoading(NSLocalizedString("Saving...", comment: ""))
        
        var avatarData: Data? = nil
        if let avatarImage = avatarImageView.image {
            avatarData = avatarImage.jpegData(compressionQuality: 0.8)
        }
        
        TCMPPDemoLoginManager.shared.updateUserInfo(
            email: email,
            avatar: avatarData,
            nickName: nickname,
            phoneNumber: phone,
            success: { [weak self] success, message in
                DispatchQueue.main.async {
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                    self?.hideLoading()
                    
                    if success {
                        self?.userInfo.nickName = nickname
                        self?.userInfo.email = email
                        self?.userInfo.phoneNumber = phone
                        self?.userInfo.saveUserInfo()
                        self?.showToast(NSLocalizedString("User information updated successfully", comment: ""))
                        self?.navigationController?.popViewController(animated: true)
                    } else {
                        self?.showToast(message.isEmpty ? NSLocalizedString("Update failed", comment: "") : message)
                    }
                }
            },
            failure: { [weak self] error in
                DispatchQueue.main.async {
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                    self?.hideLoading()
                    self?.showToast(error.localizedDescription.isEmpty ? NSLocalizedString("Update failed", comment: "") : error.localizedDescription)
                }
            }
        )
    }
    
    private func showToast(_ message: String) {
        let icon = UIImage(named: "success")
        let toast = ToastView(icon: icon!, title: message)
        toast.show(withDuration: 2.0)
    }
    
    private func showLoading(_ message: String) {
        let icon = UIImage(named: "success")
        loadingToast = ToastView(icon: icon!, title: message)
        loadingToast?.show(withDuration: 2.0)
    }
    
    private func hideLoading() {
        loadingToast?.dismiss()
        loadingToast = nil
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "UserInfoCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        cell?.selectionStyle = .none
        
        switch indexPath.row {
        case 0: // Avatar
            cell?.textLabel?.text = NSLocalizedString("Avatar", comment: "")
            setupAvatarCell(cell!)
        case 1: // Nickname
            cell?.textLabel?.text = NSLocalizedString("Nickname", comment: "")
            setupNicknameCell(cell!)
        case 2: // Email
            cell?.textLabel?.text = NSLocalizedString("Email", comment: "")
            setupEmailCell(cell!)
        case 3: // Phone
            cell?.textLabel?.text = NSLocalizedString("Phone Number", comment: "")
            setupPhoneCell(cell!)
        default:
            break
        }
        
        return cell!
    }
    
    private func setupAvatarCell(_ cell: UITableViewCell) {
        if avatarImageView == nil {
            avatarImageView = UIImageView()
            avatarImageView.contentMode = .scaleAspectFill
            avatarImageView.clipsToBounds = true
            avatarImageView.layer.cornerRadius = 25
            avatarImageView.backgroundColor = UIColor.lightGray
            
            if #available(iOS 13.0, *) {
                avatarImageView.image = UIImage(systemName: "person.circle.fill")
            } else {
                avatarImageView.image = UIImage(named: "avatar")
            }
            
            // Load avatar from URL or use default
            if let avatarUrl = userInfo.avatarUrl, !avatarUrl.isEmpty {
                print("Loading avatar from URL: \(avatarUrl)")
                guard let url = URL(string: avatarUrl) else {
                    print("Invalid avatar URL: \(avatarUrl)")
                    return
                }
                
                URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Avatar loading error: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let data = data, let image = UIImage(data: data) else {
                            print("Failed to create image from data")
                            return
                        }
                        
                        print("Avatar loaded successfully")
                        self?.avatarImageView.image = image
                    }
                }.resume()
            } else {
                print("No avatar URL available")
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
            avatarImageView.addGestureRecognizer(tapGesture)
            avatarImageView.isUserInteractionEnabled = true
        }
        
        cell.contentView.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            avatarImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupNicknameCell(_ cell: UITableViewCell) {
        if nicknameTextField == nil {
            nicknameTextField = UITextField()
            nicknameTextField.placeholder = NSLocalizedString("Enter nickname", comment: "")
            nicknameTextField.text = userInfo.nickName
            nicknameTextField.borderStyle = .none
            nicknameTextField.clearButtonMode = .whileEditing
        }
        
        cell.contentView.addSubview(nicknameTextField)
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nicknameTextField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 120),
            nicknameTextField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            nicknameTextField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupEmailCell(_ cell: UITableViewCell) {
        if emailTextField == nil {
            emailTextField = UITextField()
            emailTextField.placeholder = NSLocalizedString("Enter email", comment: "")
            emailTextField.text = userInfo.email
            emailTextField.borderStyle = .none
            emailTextField.keyboardType = .emailAddress
            emailTextField.autocapitalizationType = .none
            emailTextField.clearButtonMode = .whileEditing
        }
        
        cell.contentView.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 120),
            emailTextField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            emailTextField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupPhoneCell(_ cell: UITableViewCell) {
        if phoneTextField == nil {
            phoneTextField = UITextField()
            phoneTextField.placeholder = NSLocalizedString("Enter phone number", comment: "")
            phoneTextField.text = userInfo.phoneNumber
            phoneTextField.borderStyle = .none
            phoneTextField.keyboardType = .phonePad
            phoneTextField.clearButtonMode = .whileEditing
        }
        
        cell.contentView.addSubview(phoneTextField)
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            phoneTextField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 120),
            phoneTextField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            phoneTextField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            phoneTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - Avatar Selection
    
    @objc private func avatarTapped() {
        let alertController = UIAlertController(title: NSLocalizedString("Select Avatar", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default) { _ in
            self.openImagePicker(sourceType: .camera)
        }
        alertController.addAction(cameraAction)
        
        let photoLibraryAction = UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .default) { _ in
            self.openImagePicker(sourceType: .photoLibrary)
        }
        alertController.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        if sourceType == .camera {
            let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
            if authStatus == .denied || authStatus == .restricted {
                let alert = UIAlertController(title: NSLocalizedString("Camera Permission", comment: ""), 
                                            message: NSLocalizedString("Please enable camera access in Settings", comment: ""), 
                                            preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
                present(alert, animated: true)
                return
            }
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            // Compress image
            let maxSize: CGFloat = 300.0
            var newSize = editedImage.size
            if newSize.width > maxSize || newSize.height > maxSize {
                let scale = min(maxSize / newSize.width, maxSize / newSize.height)
                newSize = CGSize(width: newSize.width * scale, height: newSize.height * scale)
                
                UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
                editedImage.draw(in: CGRect(origin: .zero, size: newSize))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                avatarImageView.image = resizedImage
                avatarData = resizedImage?.jpegData(compressionQuality: 0.8)
            } else {
                avatarImageView.image = editedImage
                avatarData = editedImage.jpegData(compressionQuality: 0.8)
            }
        } else if let originalImage = info[.originalImage] as? UIImage {
            avatarImageView.image = originalImage
            avatarData = originalImage.jpegData(compressionQuality: 0.8)
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
} 
