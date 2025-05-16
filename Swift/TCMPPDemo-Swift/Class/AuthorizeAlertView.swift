//
//  AuthorizeAlertView.swift
//  TCMPPDemo-Swift
//
//  Created by xcode on 2025/5/16.
//

import UIKit
import TCMPPSDK

class AuthorizeAlertView: UIView {
    // MARK: - Properties
    var allowBlock: (() -> Void)?
    var denyBlock: (() -> Void)?
    
    // MARK: - Initializer
    init(frame: CGRect,
         scope: String,
         title: String,
         desc: String,
         privacyApi: String,
         appInfo: TMFMiniAppInfo?,
         allowBlock: (() -> Void)?,
         denyBlock: (() -> Void)?) {
        
        self.allowBlock = allowBlock
        self.denyBlock = denyBlock
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Background View
        let backgroundWidth = min(frame.size.width, frame.size.height) * 0.8
        let backgroundHeight: CGFloat = 300
        let backgroundView = UIView(frame: CGRect(
            x: (frame.size.width - backgroundWidth) / 2,
            y: (frame.size.height - backgroundHeight) / 2,
            width: backgroundWidth,
            height: backgroundHeight))
        backgroundView.layer.cornerRadius = 12
        backgroundView.backgroundColor = .white
        self.addSubview(backgroundView)
        
        // Title Label
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 20, width: backgroundWidth - 40, height: 30))
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        backgroundView.addSubview(titleLabel)
        
        // Description Label
        let descLabel = UILabel(frame: CGRect(x: 20, y: 60, width: backgroundWidth - 40, height: 100))
        descLabel.text = desc
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textAlignment = .left
        descLabel.textColor = .darkGray
        descLabel.numberOfLines = 0
        backgroundView.addSubview(descLabel)
        
        // Buttons
        let buttonWidth = (backgroundWidth - 60) / 2
        let buttonHeight: CGFloat = 44
        let buttonY = backgroundHeight - buttonHeight - 20
        
        // Deny Button
        let denyButton = UIButton(frame: CGRect(x: 20, y: buttonY, width: buttonWidth, height: buttonHeight))
        denyButton.setTitle("Reject", for: .normal)
        denyButton.setTitleColor(.darkGray, for: .normal)
        denyButton.layer.cornerRadius = 8
        denyButton.layer.borderWidth = 1
        denyButton.layer.borderColor = UIColor.lightGray.cgColor
        denyButton.addTarget(self, action: #selector(handleDenyButton), for: .touchUpInside)
        backgroundView.addSubview(denyButton)
        
        // Allow Button
        let allowButton = UIButton(frame: CGRect(x: backgroundWidth - buttonWidth - 20, y: buttonY, width: buttonWidth, height: buttonHeight))
        allowButton.setTitle("Allow", for: .normal)
        allowButton.setTitleColor(.white, for: .normal)
        allowButton.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 1.0)
        allowButton.layer.cornerRadius = 8
        allowButton.addTarget(self, action: #selector(handleAllowButton), for: .touchUpInside)
        backgroundView.addSubview(allowButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Button Actions
    @objc private func handleAllowButton() {
        allowBlock?()
        self.removeFromSuperview()
    }
    
    @objc private func handleDenyButton() {
        denyBlock?()
        self.removeFromSuperview()
    }
}
