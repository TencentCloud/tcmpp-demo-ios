//
//  TCMPPLanguageSettingVC.swift
//  TCMPPDemo-Swift
//
//  Created by gavinjwxu on 2024/8/14.
//

import UIKit
import TCMPPSDK

class TCMPPLanguageSettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!
    var array: [String] = []
    var current: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backItem?.title = ""
        self.title = NSLocalizedString("Language", comment: "")
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = UIColor.tcmpp_color(withHex: "#F4F4F4")
        self.array = ["中文","English","Français","Indonesia"]
        let language = LanguageManager.shared.currentLanguage()
        if language == "zh-Hans" {
            self.current = 0
        } else if language == "en" {
            self.current = 1
        } else if language == "fr" {
            self.current = 2
        } else if language == "id" {
            self.current = 3
        }
        
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        self.tableView.backgroundColor = .clear
        self.tableView.isScrollEnabled = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorStyle = .singleLine
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = self.array[indexPath.row]
        if indexPath.row == self.current {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var language = "en"
        if indexPath.row == 0 {
            language = "zh-Hans"
        } else if indexPath.row == 1 {
            language = "en"
        } else if indexPath.row == 2 {
            language = "fr"
        } else if indexPath.row == 3 {
            language = "id"
        }
        LanguageManager.shared.setCurrentLanguage(language)
        
        TMFMiniAppSDKManager.sharedInstance().terminateAllApplications()
        
        let rootViewController = TCMPPMainVC()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            appearance.shadowColor = .clear
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController.navigationBar.barTintColor = .white
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
        
        let vc = TCMPPLanguageSettingVC()
        navigationController.pushViewController(vc, animated: false)
    }
}
