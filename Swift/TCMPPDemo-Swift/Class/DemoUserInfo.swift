//
//  DemoUserInfo.swift
//  TCMPPDemo-Swift
//
//  Created by v_zwtzzhou on 2023/8/30.
//

import Foundation

class DemoUserInfo {
    static let shared = DemoUserInfo()

    var nickName: String? {
        didSet {
            if let nickName = nickName {
                writeInfoFile(nickName)
            } else {
                UserDefaults.standard.removeObject(forKey: "dev_login_name")
            }
        }
    }
    
    var avatarUrl: String?
    var country: String?
    var province: String?
    var gender: String?
    var city: String?

    private init() {
        readLoginInfo()
        if nickName == nil {
            nickName = "unknown"
        }
    }

    private func readLoginInfo() {
        let userDefaults = UserDefaults.standard

        let username = userDefaults.object(forKey: "dev_login_name") as? String
        if let username = username, !username.isEmpty {
            self.nickName = username
        }
        
        //example code
        self.avatarUrl = "https://upload.shejihz.com/2019/04/25704c14def5257a157f2d0f4b7ae581.jpg"
        self.country = "China"
        self.province = "Beijing"
        self.gender = "Male"
        self.city = "Chaoyang"
    }

    private func writeInfoFile(_ username: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(username, forKey: "dev_login_name")
    }
}
