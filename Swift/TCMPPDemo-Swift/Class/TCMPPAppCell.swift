//
//  TCMPPAppCell.swift
//  TCMPPDemo-Swift
//
//  Created by gavinjwxu on 2024/8/13.
//

import UIKit

protocol AppCellDelegate: AnyObject {
    func didClickMore(appId: String)
}

class TCMPPAppCell: UITableViewCell {
    var searchInfo: TMFAppletSearchInfo? {
        didSet {
            guard let searchInfo = searchInfo else { return }
            self.icon.image = UIImage(named: "tmf_weapp_icon_default")
            TCMPPCommonTools.getImageWith(searchInfo.appIcon) { (image, error) in
                if let image = image {
                    self.icon.image = image
                }
            }
            self.name.text = searchInfo.appTitle
            if (searchInfo.appIntro.count > 0) {
                self.detail.isHidden = false
                self.detail.text = searchInfo.appIntro
                self.category.tz_top = self.detail.tz_bottom + 5
            } else {
                self.detail.isHidden = true
                self.category.tz_top = self.name.tz_bottom + 5
            }
            self.category.textColor = UIColor.tcmpp_color(withHex: "#FA9C45")
            self.category.text = searchInfo.appCategory.components(separatedBy: ",").first?.components(separatedBy: "->").first
        }
    }

    var appInfo: TMFMiniAppInfo? {
        didSet {
            guard let appInfo = appInfo else { return }
            self.icon.image = UIImage(named: "tmf_weapp_icon_default")
            TCMPPCommonTools.getImageWith(appInfo.appIcon) { (image, error) in
                if let image = image {
                    self.icon.image = image
                }
            }
            self.name.text = appInfo.appTitle
            if appInfo.appDescription.count > 0 {
                self.detail.isHidden = false
                self.detail.text = appInfo.appDescription
                self.category.tz_top = self.detail.tz_bottom + 5
            } else {
                self.detail.isHidden = true
                self.category.tz_top = self.name.tz_bottom + 5
            }
            self.category.textColor = UIColor.tcmpp_color(withHex: "#FA9C45")
            switch appInfo.verType {
            case .develop:
                self.category.text = NSLocalizedString("Develop", comment: "")
            case .audit:
                self.category.text = NSLocalizedString("Reviewed", comment: "")
            case .preview:
                self.category.text = NSLocalizedString("Preview", comment: "")
            case .online:
                self.category.text = NSLocalizedString("Online", comment: "")
                self.category.textColor = UIColor.tcmpp_color(withHex: "#0ABF5B")
            case .local:
                self.category.text = NSLocalizedString("Local", comment: "")
            @unknown default:
                self.category.text = ""
            }
        }
    }
    var icon: UIImageView!
    var name: UILabel!
    var detail: UILabel!
    var category: UILabel!
    weak var delegate: AppCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
    }

    private func initSubViews() {
        selectionStyle = .none
        let width = UIScreen.main.bounds.size.width

        icon = UIImageView(frame: CGRect(x: 15, y: 15, width: 48, height: 48))
        icon.roundingCorners(.allCorners, cornerRadius: 24)
        icon.image = UIImage(named: "tmf_weapp_icon_default")
        contentView.addSubview(icon)

        name = UILabel(frame: CGRect(x: icon.tz_right + 15, y: icon.tz_top, width: 250, height: 22))
        name.textColor = .black
        name.font = UIFont.systemFont(ofSize: 17)
        contentView.addSubview(name)

        detail = UILabel(frame: CGRect(x: icon.tz_right + 15, y: name.tz_bottom + 5, width: width - icon.tz_width - 15 * 3 - 45, height: 20))
        detail.textColor = .lightGray
        detail.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(detail)

        category = UILabel(frame: CGRect(x: icon.tz_right + 15, y: detail.tz_bottom + 5, width: detail.tz_width, height: 18))
        category.textColor = UIColor.tcmpp_color(withHex: "#FA9C45")
        category.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(category)

        let more = UIButton(frame: CGRect(x: width - 45, y: 0, width: 45, height: 100))
        more.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        more.setImage(UIImage(named: "more_click"), for: .normal)
        more.addTarget(self, action: #selector(clickMore), for: .touchUpInside)
        contentView.addSubview(more)

        let line = UIView(frame: CGRect(x: category.tz_left, y: 100 - 0.5, width: width - icon.tz_width - 15 * 3, height: 0.5))
        line.backgroundColor = UIColor.tcmpp_color(withHex: "#EEEEEE")
        contentView.addSubview(line)
    }

    @objc private func clickMore() {
        if let delegate = delegate {
            let appId = appInfo?.appId ?? searchInfo?.appId ?? ""
            delegate.didClickMore(appId: appId)
        }
    }
}
