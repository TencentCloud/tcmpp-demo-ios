//
//  TCMPPLoginVC.swift
//  TCMPPDemo-Swift
//
//  Created by gavinjwxu on 2024/8/13.
//

import UIKit

class TCMPPLoginVC: UIViewController {
    private var tf: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    private func initUI() {
        view.backgroundColor = .white

        let logoIV = UIImageView(frame: CGRect(x: (view.tz_width - 218) / 2, y: 150, width: 50, height: 50))
        logoIV.image = UIImage(named: "tcmpp_logo")
        view.addSubview(logoIV)

        let logoLab = UILabel(frame: CGRect(x: logoIV.tz_right + 10, y: 150, width: 155, height: 50))
        logoLab.textColor = .black
        logoLab.font = UIFont.systemFont(ofSize: 45)
        logoLab.text = "TCMPP"
        view.addSubview(logoLab)

        let detailLab = UILabel(frame: CGRect(x: (view.tz_width - 325) / 2, y: logoIV.tz_bottom + 15, width: 325, height: 20))
        detailLab.textColor = .black
        detailLab.font = UIFont.italicSystemFont(ofSize: 14)
        detailLab.text = "A platform that takes your App to the next level"
        view.addSubview(detailLab)

        let bgView = UIView(frame: CGRect(x: (view.tz_width - 320) / 2, y: detailLab.tz_bottom + 50, width: 320, height: 54))
        bgView.backgroundColor = UIColor.tcmpp_color(withHex: "#F4F4F4")
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
        view.addSubview(bgView)

        let tf = UITextField(frame: CGRect(x: 15, y: 15, width: 320 - 15 * 2, height: 54 - 15 * 2))
        tf.textColor = .black
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.placeholder = NSLocalizedString("Please enter the username", comment: "")
        bgView.addSubview(tf)
        self.tf = tf

        let loginBtn = UIButton(frame: CGRect(x: (view.tz_width - 320) / 2, y: bgView.tz_bottom + 30, width: 320, height: 54))
        loginBtn.backgroundColor = UIColor.tcmpp_color(withHex: "#006EFF")
        loginBtn.layer.cornerRadius = 8
        loginBtn.layer.masksToBounds = true
        loginBtn.setTitle(NSLocalizedString("Log in", comment: ""), for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        view.addSubview(loginBtn)
    }

    @objc private func login() {
        tf.resignFirstResponder()
        guard let text = tf.text, !text.isEmpty else { return }
        
        TCMPPLoginManager.shared.loginUser(userId: text) { err, value in
            if err == nil {
                DispatchQueue.main.async {
                    DemoUserInfo.shared.nickName = self.tf.text
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
