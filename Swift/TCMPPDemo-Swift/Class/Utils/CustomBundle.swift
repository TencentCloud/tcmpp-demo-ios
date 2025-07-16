//
//  CustomBundle.swift
//  TCMPPDemo-Swift
//
//  Created by gavinjwxu on 2024/8/13.
//

import Foundation

class CustomBundle: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        let customBundle = LanguageManager.shared.getBundle()
        return customBundle?.localizedString(forKey: key, value: value, table: tableName) ?? Bundle.main.localizedString(forKey: key, value: value, table: tableName)
    }
}
