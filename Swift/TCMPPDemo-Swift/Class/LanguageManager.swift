//
//  LanguageManager.swift
//  TCMPPDemo-Swift
//
//  Created by gavinjwxu on 2024/8/13.
//

import Foundation

class LanguageManager {
    
    static let shared: LanguageManager = {
        let instance = LanguageManager()
        return instance
    }()
    
    private init() {
        
    }
    
    func reloadBundleClass() {
        object_setClass(Bundle.main, CustomBundle.self)
    }
    
    func currentLanguage() -> String {
        if let language = UserDefaults.standard.string(forKey: "currentLanguage") {
            return language
        }
        
        var language = Locale.preferredLanguages.first ?? "en"
        
        if language.hasPrefix("en") {
            language = "en"
        } else if language.hasPrefix("zh") {
            language = "zh-Hans"
        } else if language.hasPrefix("fr") {
            language = "fr";
        } else if language.hasPrefix("id") {
            language = "id";
        }
        return language
    }
    
    func setCurrentLanguage(_ language: String) {
        UserDefaults.standard.set(language, forKey: "currentLanguage")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: Notification.Name("LanguageChanged"), object: nil)
    }
    
    func getBundle() -> Bundle? {
        if let bundlePath = Bundle.main.path(forResource: currentLanguage(), ofType: "lproj") {
            return Bundle(path: bundlePath)
        }
        return nil
    }
}
