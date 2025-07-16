//
//  ToastView.swift
//  TCMPPDemo-Swift
//
//  Created by gavinjwxu on 2024/8/13.
//

import UIKit
import TCMPPSDK

class ToastView: UIView {

    private var iconImageView: UIImageView!
    private var titleLabel: UILabel!
    private var toastWindow: UIWindow?

    init(icon: UIImage, title: String) {
        super.init(frame: CGRect(x: 15, y: -64, width: UIScreen.main.bounds.width - 30, height: 64))
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        
        iconImageView = UIImageView(image: icon)
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .black
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        
        // 设置布局
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(withDuration duration: CGFloat) {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self)
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseInOut,
                           animations: {
                self.frame = CGRect(x: 15, y: 20 + (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0), width: UIScreen.main.bounds.width - 30, height: 64)
            }, completion: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(duration)) {
            self.dismiss()
        }
    }

    func dismiss() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut,
                       animations: {
                        self.frame = CGRect(x: 15, y: -64, width: UIScreen.main.bounds.width - 30, height: 64)
                       }, completion: { finished in
                        self.removeFromSuperview()
                       })
    }
}

extension UIApplication {
    var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
    }
}
