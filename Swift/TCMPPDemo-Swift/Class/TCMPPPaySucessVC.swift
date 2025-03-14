//
//  TCMPPPaySucessVC.swift
//  TCMPPDemo-Swift
//
//  Created by gavinjwxu on 2024/8/14.
//

import UIKit
import TCMPPSDK

class TCMPPPaySucessVC: UIViewController {
    var iconURL: String = ""
    var name: String = ""
    var price: Int = 0
    var dismissBlock: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initUI()
    }

    func initUI() {
        let title = UILabel(frame: CGRect(x: 0, y: 30 + TCMPPCommonTools.safeAreaInsets.top, width: 200, height: 20))
        title.textColor = UIColor(red: 96.0 / 255, green: 193.0 / 255, blue: 116.0 / 255, alpha: 1)
        title.textAlignment = .center
        title.center.x = view.center.x
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.text = NSLocalizedString("Pay Successfully", comment: "")
        view.addSubview(title)

        let icon = UIImageView(frame: CGRect(x: 0, y: title.frame.maxY + 100, width: 60, height: 60))
        icon.center.x = title.center.x
        icon.layer.cornerRadius = 30.0
        icon.layer.masksToBounds = true
        icon.image = UIImage(named: "tmf_weapp_icon_default")

        TCMPPCommonTools.getImageWith(iconURL) { (image, error) in
            if let image = image {
                icon.image = image
            }
        }
        view.addSubview(icon)

        let nameLabel = UILabel(frame: CGRect(x: 0, y: icon.frame.maxY + 20, width: view.frame.width, height: 20))
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.center.x = view.center.x
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.text = name
        view.addSubview(nameLabel)

        let priceLabel = UILabel(frame: CGRect(x: 0, y: nameLabel.frame.maxY + 50, width: view.frame.width, height: 40))
        priceLabel.textColor = .black
        priceLabel.textAlignment = .center
        priceLabel.center.x = view.center.x
        priceLabel.font = UIFont.systemFont(ofSize: 38)
        priceLabel.text = String(format: "$ %.2f", Double(price) / 100.0)
        view.addSubview(priceLabel)

        let doneBtn = UIButton(frame: CGRect(x: 0, y: view.frame.maxY - 200, width: 200, height: 50))
        doneBtn.backgroundColor = UIColor(red: 242.0 / 255, green: 242.0 / 255, blue: 242.0 / 255, alpha: 1)
        doneBtn.setTitleColor(.black, for: .normal)
        doneBtn.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        doneBtn.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
        doneBtn.center.x = view.center.x
        doneBtn.layer.cornerRadius = 8.0
        doneBtn.layer.masksToBounds = true
        view.addSubview(doneBtn)
    }

    @objc func doneClick() {
        dismiss(animated: true) {
            self.dismissBlock?()
        }
    }
}
