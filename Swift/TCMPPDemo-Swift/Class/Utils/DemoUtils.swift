//
//  DemoUtils.swift
//  TCMPPDemo-Swift
//
//  Created by gavinjwxu on 2024/8/13.
//

import Foundation

class DemoUtils {
    static func convertToJsonData(_ dict: [String: Any]) -> String {
        var jsonString = ""
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
            jsonString = String(data: jsonData, encoding: .utf8) ?? ""
        } else {
            print("Error serializing JSON")
        }

        let mutStr = NSMutableString(string: jsonString)
        let fullRange = NSRange(location: 0, length: mutStr.length)
        mutStr.replaceOccurrences(of: " ", with: "", options: .literal, range: fullRange)
        mutStr.replaceOccurrences(of: "\n", with: "", options: .literal, range: fullRange)
        mutStr.replaceOccurrences(of: "\\/\\/", with: "//", options: .literal, range: fullRange)

        return mutStr as String
    }

    static func executeOnMainThread(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }

    static func validNSString(_ str: String?) -> String {
        return str ?? ""
    }
}
