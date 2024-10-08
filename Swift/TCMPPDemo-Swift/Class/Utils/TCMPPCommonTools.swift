//
//  File.swift
//  TCMPPDemo-Swift
//
//  Created by gavinjwxu on 2024/8/13.
//

import UIKit

class TCMPPCommonTools {

    static var safeAreaInsets: UIEdgeInsets {
        var window = UIApplication.shared.windows.first
        if !(window?.isKeyWindow ?? false) {
            let keyWindow = UIApplication.shared.keyWindow
            if keyWindow?.bounds == UIScreen.main.bounds {
                window = keyWindow
            }
        }
        if #available(iOS 11.0, *) {
            let insets = window?.safeAreaInsets ?? UIEdgeInsets.zero
            return insets
        }
        return UIEdgeInsets.zero
    }

    static func getImageWith(_ path: String?, completion: @escaping (_ image: UIImage?, _ error: NSError?) -> ()) {
        guard let path = path, !path.isEmpty else {
            completion(nil,NSError(domain: "get image error", code: -1, userInfo: [NSLocalizedDescriptionKey: "path is nil"]))
            return
        }
        DispatchQueue.global(qos: .default).async {
            let tempPath = NSTemporaryDirectory()
            let localFilePath = tempPath + (path as NSString).lastPathComponent
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: localFilePath) {
                let image = UIImage(contentsOfFile: localFilePath)
                DispatchQueue.main.async {
                    completion(image, nil)
                }
            } else {
                if let url = URL(string: path), let data = try? Data(contentsOf: url) {
                    let image = UIImage(data: data)
                    try? data.write(to: URL(fileURLWithPath: localFilePath), options: .atomic)
                    DispatchQueue.main.async {
                        completion(image, nil)
                    }
                }
            }
        }
    }
}
