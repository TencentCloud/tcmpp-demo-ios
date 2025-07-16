//
//  TCMPPUserInfo.swift
//  TCMPPDemo-Swift
//
//  Created by v_zwtzzhou on 2023/8/30.
//

import Foundation

class TCMPPUserInfo {
    static let shared = TCMPPUserInfo()

    var nickName: String?
    
    var avatarUrl: String?
    var country: String?
    var province: String?
    var gender: String?
    var city: String?
    
    var token: String?
    var email: String?
    var userId: String?
    var phoneNumber: String?

    private init() {
        loadUserInfo()
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
    
    // MARK: - Persistence Methods
    private func loadUserInfo() {
        let userDefaults = UserDefaults.standard
        
        nickName = userDefaults.string(forKey: "tcmpp_user_nickname")
        avatarUrl = userDefaults.string(forKey: "tcmpp_user_avatar_url")
        country = userDefaults.string(forKey: "tcmpp_user_country")
        province = userDefaults.string(forKey: "tcmpp_user_province")
        gender = userDefaults.string(forKey: "tcmpp_user_gender")
        city = userDefaults.string(forKey: "tcmpp_user_city")
        token = userDefaults.string(forKey: "tcmpp_user_token")
        email = userDefaults.string(forKey: "tcmpp_user_email")
        userId = userDefaults.string(forKey: "tcmpp_user_id")
        phoneNumber = userDefaults.string(forKey: "tcmpp_user_phone")
        
        // Legacy support
        if nickName == nil {
            let username = userDefaults.object(forKey: "dev_login_name") as? String
            if let username = username, !username.isEmpty {
                self.nickName = username
            }
        }
        
        // Set default values if not loaded
        if avatarUrl == nil {
            avatarUrl = "https://upload.shejihz.com/2019/04/25704c14def5257a157f2d0f4b7ae581.jpg"
        }
        if country == nil {
            country = "China"
        }
        if province == nil {
            province = "Beijing"
        }
        if gender == nil {
            gender = "Male"
        }
        if city == nil {
            city = "Chaoyang"
        }
    }
    
    func saveUserInfo() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(nickName, forKey: "tcmpp_user_nickname")
        userDefaults.set(avatarUrl, forKey: "tcmpp_user_avatar_url")
        userDefaults.set(country, forKey: "tcmpp_user_country")
        userDefaults.set(province, forKey: "tcmpp_user_province")
        userDefaults.set(gender, forKey: "tcmpp_user_gender")
        userDefaults.set(city, forKey: "tcmpp_user_city")
        userDefaults.set(token, forKey: "tcmpp_user_token")
        userDefaults.set(email, forKey: "tcmpp_user_email")
        userDefaults.set(userId, forKey: "tcmpp_user_id")
        userDefaults.set(phoneNumber, forKey: "tcmpp_user_phone")
        
        // Legacy support
        if let nickName = nickName {
            userDefaults.set(nickName, forKey: "dev_login_name")
        }
        
        userDefaults.synchronize()
    }
    
    func setUserInfo(_ userInfo: [String: Any]) {
        if let nickName = userInfo["nickName"] as? String {
            self.nickName = nickName
        }
        if let avatarUrl = userInfo["iconUrl"] as? String {
            self.avatarUrl = avatarUrl
        }
        if let country = userInfo["country"] as? String {
            self.country = country
        }
        if let province = userInfo["province"] as? String {
            self.province = province
        }
        if let gender = userInfo["gender"] as? String {
            self.gender = gender
        }
        if let city = userInfo["city"] as? String {
            self.city = city
        }
        if let token = userInfo["token"] as? String {
            self.token = token
        }
        if let email = userInfo["email"] as? String {
            self.email = email
        }
        if let userId = userInfo["userId"] as? String {
            self.userId = userId
        }
        if let phoneNumber = userInfo["phoneNumber"] as? String {
            self.phoneNumber = phoneNumber
        }
        
        saveUserInfo()
    }
    
    func clearUserInfo() {
        nickName = nil
        avatarUrl = nil
        country = nil
        province = nil
        gender = nil
        city = nil
        token = nil
        email = nil
        userId = nil
        phoneNumber = nil
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.removeObject(forKey: "tcmpp_user_nickname")
        userDefaults.removeObject(forKey: "tcmpp_user_avatar_url")
        userDefaults.removeObject(forKey: "tcmpp_user_country")
        userDefaults.removeObject(forKey: "tcmpp_user_province")
        userDefaults.removeObject(forKey: "tcmpp_user_gender")
        userDefaults.removeObject(forKey: "tcmpp_user_city")
        userDefaults.removeObject(forKey: "tcmpp_user_token")
        userDefaults.removeObject(forKey: "tcmpp_user_email")
        userDefaults.removeObject(forKey: "tcmpp_user_id")
        userDefaults.removeObject(forKey: "tcmpp_user_phone")
        userDefaults.removeObject(forKey: "dev_login_name")
        
        userDefaults.synchronize()
    }
}
