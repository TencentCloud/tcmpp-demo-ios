//
//  TCMPPSubscribeInfoVC.swift
//  TCMPPDemo-Swift
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024 Tencent. All rights reserved.
//

import UIKit
import TCMPPSDK

struct SubscribeInfoModel {
    let tmplID: String
    let content: String
    let dataTime: Int
    let messageID: String
    let tmplTitle: String
    let mnpName: String
    let mnpId: String
    let page: String
    let state: String
    
    init(jsonData: [String: Any]) {
        self.tmplID = jsonData["TmplID"] as? String ?? ""
        self.content = jsonData["Content"] as? String ?? ""
        self.dataTime = jsonData["DataTime"] as? Int ?? 0
        self.messageID = jsonData["MessageID"] as? String ?? ""
        self.tmplTitle = jsonData["TmplTitle"] as? String ?? ""
        self.mnpName = jsonData["MnpName"] as? String ?? ""
        self.mnpId = jsonData["MnpId"] as? String ?? ""
        self.page = jsonData["Page"] as? String ?? ""
        self.state = jsonData["State"] as? String ?? ""
    }
}

class SubscribeInfoCell: UITableViewCell {
    private let timeLabel = UILabel()
    private let cardView = UIView()
    private let appIconView = UIImageView()
    private let appNameLabel = UILabel()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let checkDetailsLabel = UILabel()
    private let separatorLine = UIView()
    private let separatorLine1 = UIView()
    private let topRightImg = UIImageView()
    private let bottomRightImg = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        backgroundColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1)
        selectionStyle = .none
        
        // Time label
        timeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        timeLabel.textColor = UIColor.lightGray
        timeLabel.textAlignment = .center
        contentView.addSubview(timeLabel)
        
        // Card view
        cardView.backgroundColor = UIColor.white
        cardView.layer.cornerRadius = 5.0
        cardView.layer.masksToBounds = true
        contentView.addSubview(cardView)
        
        // App icon
        if #available(iOS 13.0, *) {
            appIconView.image = UIImage(systemName: "app.fill")
        } else {
            appIconView.image = UIImage(named: "tmf_weapp_icon_default")
        }
        cardView.addSubview(appIconView)
        
        // Top right image
        if #available(iOS 13.0, *) {
            topRightImg.image = UIImage(systemName: "ellipsis")
        } else {
            topRightImg.image = UIImage(named: "more")
        }
        cardView.addSubview(topRightImg)
        
        // App name
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        appNameLabel.textColor = UIColor.black
        cardView.addSubview(appNameLabel)
        
        // Separator line
        separatorLine.backgroundColor = UIColor.lightGray
        cardView.addSubview(separatorLine)
        
        // Title
        cardView.addSubview(titleLabel)
        
        // Content
        contentLabel.numberOfLines = 0
        contentLabel.textColor = UIColor.black
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        cardView.addSubview(contentLabel)
        
        // Separator line 1
        separatorLine1.backgroundColor = UIColor.lightGray
        cardView.addSubview(separatorLine1)
        
        // Check details
        checkDetailsLabel.font = UIFont.systemFont(ofSize: 14)
        checkDetailsLabel.text = NSLocalizedString("Check the details", comment: "")
        checkDetailsLabel.textColor = UIColor.black
        cardView.addSubview(checkDetailsLabel)
        
        // Bottom right image
        if #available(iOS 13.0, *) {
            bottomRightImg.image = UIImage(systemName: "chevron.right")
        } else {
            bottomRightImg.image = UIImage(named: "more")
        }
        cardView.addSubview(bottomRightImg)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cardWidth = frame.width - 20
        let cardHeight = frame.height - 50
        
        timeLabel.frame = CGRect(x: 0, y: 20, width: frame.width - 20, height: 20)
        cardView.frame = CGRect(x: 10, y: 50, width: cardWidth, height: cardHeight)
        
        appIconView.frame = CGRect(x: 10, y: 10, width: 25, height: 25)
        appNameLabel.frame = CGRect(x: 45, y: 13, width: cardWidth - 55, height: 20)
        topRightImg.frame = CGRect(x: cardWidth - 45, y: 15, width: 35, height: 8)
        
        separatorLine.frame = CGRect(x: 0, y: 45, width: cardWidth, height: 0.5)
        titleLabel.frame = CGRect(x: 10, y: 55, width: cardWidth - 20, height: 20)
        
        let contentHeight = calculateContentHeight()
        contentLabel.frame = CGRect(x: 10, y: 80, width: cardWidth - 20, height: contentHeight)
        
        separatorLine1.frame = CGRect(x: 10, y: 85 + contentHeight, width: cardWidth - 20, height: 0.5)
        checkDetailsLabel.frame = CGRect(x: 10, y: 95 + contentHeight, width: 200, height: 20)
        bottomRightImg.frame = CGRect(x: cardWidth - 40, y: 95 + contentHeight, width: 10, height: 15)
    }
    
    private func calculateContentHeight() -> CGFloat {
        let maxSize = CGSize(width: frame.width - 40, height: CGFloat.greatestFiniteMagnitude)
        let contentSize = contentLabel.text?.boundingRect(with: maxSize,
                                                         options: .usesLineFragmentOrigin,
                                                         attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)],
                                                         context: nil).size
        return contentSize?.height ?? 0
    }
    
    func configure(with model: SubscribeInfoModel) {
        appNameLabel.text = model.mnpName
        titleLabel.text = model.tmplTitle
        contentLabel.text = model.content
        
        let date = Date(timeIntervalSince1970: TimeInterval(model.dataTime))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeLabel.text = formatter.string(from: date)
        
        setNeedsLayout()
    }
}

class TCMPPSubscribeInfoVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView: UITableView!
    private var refreshControl: UIRefreshControl!
    private var modelData: [SubscribeInfoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Service Notice", comment: "")
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.systemBackground
        } else {
            self.view.backgroundColor = UIColor.white
        }
        
        setupTableView()
        requestData()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1)
        tableView.register(SubscribeInfoCell.self, forCellReuseIdentifier: "SubscribeInfoCellID")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        requestData()
    }
    
    private func requestData() {
        guard let token = TCMPPUserInfo.shared.token else {
            showToast(NSLocalizedString("Please login first", comment: ""))
            refreshControl.endRefreshing()
            return
        }
        let appId = TMFMiniAppSDKManager.sharedInstance().getConfigAppKey()
        if appId.isEmpty {
            showToast(NSLocalizedString("AppId is empty", comment: ""))
            refreshControl.endRefreshing()
            return
        }
        
        TCMPPDemoLoginManager.shared.getMessage(token: token, appId: appId, offset: 0, success: { [weak self] messages in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                
                if messages.isEmpty {
                    self?.showToast(NSLocalizedString("No messages", comment: ""))
                    return
                }
                
                self?.modelData = messages.map { SubscribeInfoModel(jsonData: $0) }
                self?.tableView.reloadData()
            }
        }, failure: { [weak self] error in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.showToast(error.localizedDescription)
            }
        })
    }
    
    private func showToast(_ message: String) {
        let icon = UIImage(named: "success")
        let toast = ToastView(icon: icon!, title: message)
        toast.show(withDuration: 2.0)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscribeInfoCellID", for: indexPath) as! SubscribeInfoCell
        cell.configure(with: modelData[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = modelData[indexPath.row].content
        let maxSize = CGSize(width: view.frame.width - 40, height: CGFloat.greatestFiniteMagnitude)
        let contentSize = content.boundingRect(with: maxSize,
                                             options: .usesLineFragmentOrigin,
                                             attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)],
                                             context: nil).size
        
        return contentSize.height + 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = modelData[indexPath.row]
        var verType: TMAVersionType = .online
        
        if model.state == "developer" {
            verType = .develop
        } else if model.state == "trial" {
            verType = .preview
        }
        
        TMFMiniAppSDKManager.sharedInstance().startUpMiniApp(withAppID: model.mnpId,
                                                            verType: verType,
                                                            scene: .aioEntry,
                                                            firstPage: model.page,
                                                            paramsStr: nil,
                                                            parentVC: self) { [weak self] error in
            if let error = error {
                self?.showErrorInfo(error)
            }
        }
    }
    
    private func showErrorInfo(_ error: Error) {
        let errorMsg: String
        if !error.localizedDescription.isEmpty {
            errorMsg = "\(error.localizedDescription)\n\(error._code)\n\(error.localizedDescription)"
        } else {
            errorMsg = "\(error.localizedDescription)\n\(error._code)"
        }
        
        let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alert.dismiss(animated: true)
        }
    }
} 