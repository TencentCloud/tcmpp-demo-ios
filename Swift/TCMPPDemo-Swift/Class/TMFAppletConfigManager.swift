//
//  TMFAppletConfigManager.swift
//  TCMPPDemo-Swift
//
//  Created by v_zwtzzhou on 2023/11/29.
//

import UIKit

class TMFAppletConfigItem: NSObject, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool = false;
    
    var title: String?;
    var subTitle: String?;
    var filePath: String?;
    var content: String?;
    lazy var updateTime: Date = Date();
    var checkmark = false;
    
    override init() {
    }
    
    static func config(_ file: String) -> TMFAppletConfigItem?{
        let filePath = URL(fileURLWithPath: TMFAppletConfigManager.homeDirectory).appendingPathComponent(file).path;
        if let data = FileManager.default.contents(atPath: filePath),
           let config = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? TMFAppletConfigItem {
            config.filePath = file;
            return config;
        } else {
            return nil;
        }
    }
    
    required init?(coder: NSCoder) {
        super.init();
        title = coder.decodeObject(forKey: "title") as? String;
        subTitle = coder.decodeObject(forKey: "subTitle") as? String;
        content = coder.decodeObject(forKey: "content") as? String;
        updateTime = coder.decodeObject(forKey: "updateTime") as? Date ?? Date();
        checkmark = coder.decodeBool(forKey: "checkmark");
    }

    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title");
        coder.encode(subTitle, forKey: "subTitle");
        coder.encode(content, forKey: "content");
        coder.encode(updateTime, forKey: "updateTime");
        coder.encode(checkmark, forKey: "checkmark");
    }
    /// public
    func writefile(){
        let data = try! NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false);
        try! data.write(to: URL(filePath: TMFAppletConfigManager.homeDirectory).appendingPathComponent(self.filePath!));
    }
    
    func changeCheckmark(_ checkmark: Bool){
        if (self.checkmark != checkmark) {
            self.checkmark = checkmark;
            if (self.filePath?.count ?? 0 > 0){
                self.writefile();
            }
        }
    }
}

class TMFAppletConfigManager: NSObject {
    /// Public
    static let shared = TMFAppletConfigManager();

    static let homeDirectory: String = {
        let directoryPath: String;
        let fileManager = FileManager.default;
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        directoryPath = (documentDirectory as NSString).appendingPathComponent(".TMFApplet/configfiles");
        print("configfiles: \(directoryPath)");
        var isDirectory: ObjCBool = false;
        if !fileManager.fileExists(atPath: directoryPath, isDirectory: &isDirectory) || !isDirectory.boolValue {
            try? fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil);
            var urlToExclude = NSURL(fileURLWithPath: directoryPath);
            try? urlToExclude.setResourceValue(true, forKey: .isExecutableKey);
        }
        return directoryPath;
    }();
    
    lazy var configList: [TMFAppletConfigItem] = {
        return [];
    }();
    
    override init() {
        super.init();
        self.loadLocalConfig();
    }
    
    private func loadLocalConfig(){
        if let files = try? FileManager.default.contentsOfDirectory(atPath: Self.homeDirectory) {
            for file in files {
                if let item = TMFAppletConfigItem.config(file) {
                    self.configList.append(item);
                }
            }
            
            self.configList.sort { item1, item2 in
                return item1.updateTime < item2.updateTime;
            }
        }
    }
    
    func getCurrentConfigItem() -> TMFAppletConfigItem?{
        for item in self.configList {
                if item.checkmark {
                    return item;
                }
            }
        return nil;
    }
    
    func addAppletConfig(_ title: String?, _ content: String?) -> Bool{
        guard let content = content else {
            return false;
        }
        guard let jsonData = content.data(using: .utf8) else {
            return false;
        }
        do {
            guard let dic = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any], dic.count > 0 else {
                return false;
            }
            let item = TMFAppletConfigItem();
            let productId = dic["productId"];
            let shark = dic["shark"] as! Dictionary<String, Any>;
            let httpUrl = shark["httpUrl"];
            item.subTitle = "\(productId ?? "") \(httpUrl ?? "")";
            if item.subTitle!.isEmpty {
                return false;
            }
            let filename = "\(Date.timeIntervalSinceReferenceDate).json";
            item.title = title;
            item.checkmark = self.configList.isEmpty;
            item.content = content;
            item.filePath = filename;
            item.writefile();
            self.configList.insert(item, at: 0);
            return true;
        } catch {
            return false;
        }
    }
    
    func removeAppletConfigItem(_ path: String) {
        for (index, item) in self.configList.enumerated() {
            if item.filePath == path {
                self.configList.remove(at: index);
                break;
            }
        }
        
        do {
            let filePath = (TMFAppletConfigManager.homeDirectory as NSString).appendingPathComponent(path);
            try FileManager.default.removeItem(atPath: filePath);
        } catch {
            print("Error removing file: \(error.localizedDescription)");
        }
    }
    
    func checkAppletConfigTitle(_ title: String) -> Bool {
        for item in self.configList {
            if item.title == title {
                return true;
            }
        }
        return false;
    }
}
