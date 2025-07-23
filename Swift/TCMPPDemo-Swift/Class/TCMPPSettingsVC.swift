//
//  TCMPPSettingsVC.swift
//  TCMPPDemo-Swift
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024 Tencent. All rights reserved.
//

import UIKit

class TCMPPSettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView!
    private var settingsItems: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Settings", comment: "")
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.systemBackground
        } else {
            self.view.backgroundColor = UIColor.white
        }
        
        setupTableView()
        setupData()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
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
    
    private func setupData() {
        settingsItems = [
            [
                "title": NSLocalizedString("User Information", comment: ""),
                "subtitle": NSLocalizedString("Edit profile, avatar, nickname and phone number", comment: ""),
                "icon": "person.circle",
                "type": "user_info"
            ],
            [
                "title": NSLocalizedString("Service Notice", comment: ""),
                "subtitle": NSLocalizedString("View service messages and notifications", comment: ""),
                "icon": "bell",
                "type": "subscribe_info"
            ]
        ]
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SettingsCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
            cell?.accessoryType = .disclosureIndicator
        }
        
        let item = settingsItems[indexPath.row]
        cell?.textLabel?.text = item["title"] as? String
        cell?.detailTextLabel?.text = item["subtitle"] as? String
        
        if #available(iOS 13.0, *) {
            cell?.detailTextLabel?.textColor = UIColor.secondaryLabel
        } else {
            cell?.detailTextLabel?.textColor = UIColor.lightGray
        }
        
        if #available(iOS 13.0, *) {
            cell?.imageView?.image = UIImage(systemName: item["icon"] as? String ?? "")
        }
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = settingsItems[indexPath.row]
        let type = item["type"] as? String
        
        switch type {
        case "user_info":
            let editVC = TCMPPUserInfoEditVC()
            navigationController?.pushViewController(editVC, animated: true)
        case "subscribe_info":
            let subscribeVC = TCMPPSubscribeInfoVC()
            navigationController?.pushViewController(subscribeVC, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
} 