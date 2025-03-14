//
//  TCMPPAppCell.swift
//  TCMPPDemo-Swift
//
//  Created by gavinjwxu on 2024/8/13.
//

import UIKit
import TCMPPSDK

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
            } else {
                self.detail.isHidden = true
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
            } else {
                self.detail.isHidden = true
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
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "tmf_weapp_icon_default")
        return imageView
    }()
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var detail: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var category: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.tcmpp_color(withHex: "#FA9C45")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "more_click"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.addTarget(self, action: #selector(clickMore), for: .touchUpInside)
        return button
    }()
    
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.tcmpp_color(withHex: "#EEEEEE")
        return view
    }()
    
    weak var delegate: AppCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        selectionStyle = .none
        
        contentView.addSubview(icon)
        contentView.addSubview(name)
        contentView.addSubview(detail)
        contentView.addSubview(category)
        contentView.addSubview(moreButton)
        contentView.addSubview(separatorLine)
        
        NSLayoutConstraint.activate([
            // Icon constraints
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            icon.widthAnchor.constraint(equalToConstant: 48),
            icon.heightAnchor.constraint(equalToConstant: 48),
            
            // Name constraints
            name.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 15),
            name.topAnchor.constraint(equalTo: icon.topAnchor),
            name.trailingAnchor.constraint(lessThanOrEqualTo: moreButton.leadingAnchor, constant: -15),
            name.heightAnchor.constraint(equalToConstant: 22),
            
            // Detail constraints
            detail.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            detail.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            detail.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            detail.heightAnchor.constraint(equalToConstant: 20),
            
            // Category constraints
            category.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            category.topAnchor.constraint(equalTo: detail.bottomAnchor, constant: 5),
            category.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            category.heightAnchor.constraint(equalToConstant: 18),
            
            // More button constraints
            moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            moreButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 45),
            moreButton.heightAnchor.constraint(equalToConstant: 100),
            
            // Separator line constraints
            separatorLine.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    @objc private func clickMore() {
        if let delegate = delegate {
            let appId = appInfo?.appId ?? searchInfo?.appId ?? ""
            delegate.didClickMore(appId: appId)
        }
    }
}
