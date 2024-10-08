//
//  TCMPPLoginManager.swift
//  TCMPPDemo-Swift
//
//  Created by gavinjwxu on 2024/8/13.
//

import Foundation

class TCMPPLoginManager {
    static let shared = TCMPPLoginManager()
    
    private var token: String?
    private var urlSession: URLSession?
    private var appId: String?
    private var userId: String?
    
    private let loginURL = "https://openapi-sg.tcmpp.com/superapp/login"
    private let getCodeURL = "https://openapi-sg.tcmpp.com/superapp/getMiniProgramAuthCode"
    
    private init() {}
    
    func getAppId() -> String? {
        if appId == nil {
            if let debugInfo = TMFMiniAppSDKManager.sharedInstance().getDebugInfo() as? [String: Any] {
                appId = debugInfo["AppKey"] as? String
            }
        }
        return appId
    }
    
    func writeInfoFile(username: String?, expires: Int) {
        token = username
    }
    
    func getToken() -> String? {
        return token
    }
    
    func getUserId() -> String? {
        if let userId = userId, !userId.isEmpty {
            return userId
        }
        return nil
    }
    
    func loginUser(userId: String, completionHandler: @escaping (NSError?, String?) -> Void) {
        self.userId = userId
        login(completionHandler: completionHandler)
    }
    
    private func login(completionHandler: @escaping (NSError?, String?) -> Void) {
        if urlSession == nil {
            urlSession = URLSession(configuration: .default)
        }
        
        guard let url = URL(string: loginURL),
              let appId = getAppId(),
              let userId = getUserId() else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody: [String: Any] = [
            "appId": appId,
            "userAccount": userId,
            "userPassword": ""
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
            request.httpBody = jsonData
        } catch {
            completionHandler(NSError(domain: "KTCMPPLoginRequestDomain", code: -1000, userInfo: [NSLocalizedDescriptionKey: "Error while creating JSON data: \(error.localizedDescription)"]), nil)
            return
        }
        
        let dataTask = urlSession?.dataTask(with: request) { [weak self] (data:Data?, response:URLResponse?, error:Error?) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                completionHandler(NSError(domain: "KTCMPPLoginRequestDomain", code: -1002, userInfo: [NSLocalizedDescriptionKey: "network error: \(error.localizedDescription)"]), nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                let userInfo = [NSLocalizedDescriptionKey: "Request error code: \((response as? HTTPURLResponse)?.statusCode ?? -1)"]
                completionHandler(NSError(domain: "KTCMPPLoginRequestDomain", code: -1001, userInfo: userInfo), nil)
                return
            }
            
            do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let returnCode = jsonDict["returnCode"] as? String ?? "-1"
                        let errCode = Int(returnCode) ?? -1
                        if errCode == 0 {
                            if let dataJson = jsonDict["data"] as? [String: Any], let token = dataJson["token"] as? String {
                                strongSelf.writeInfoFile(username: token, expires: 0)
                                completionHandler(nil, nil)
                                return
                            }
                        } else {
                            let errMsg = jsonDict["returnMessage"] as? String ?? "Received response data error"
                            let userInfo = [NSLocalizedDescriptionKey: errMsg]
                            completionHandler(NSError(domain: "KTCMPPLoginRequestDomain", code: errCode, userInfo: userInfo), nil)
                            return
                        }
                    } else {
                        let userInfo = [NSLocalizedDescriptionKey: "Received response data error"]
                        completionHandler(NSError(domain: "KTCMPPLoginRequestDomain", code: -1002, userInfo: userInfo), nil)
                    }
                } catch {
                    completionHandler(NSError(domain: "KTCMPPLoginRequestDomain", code: -1002, userInfo: [NSLocalizedDescriptionKey: "JSON parsing error: \(error.localizedDescription)"]), nil)
                }
        }
        
        dataTask?.resume()
    }
    
    func getToken(miniAppId: String, completionHandler: @escaping (NSError?, String?) -> Void) {
        if urlSession == nil {
            urlSession = URLSession(configuration: .default)
        }
        
        guard let url = URL(string: getCodeURL),
              let appId = getAppId(),
              let token = token else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody: [String: Any] = [
            "appId": appId,
            "token": token,
            "miniAppId": miniAppId
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
            request.httpBody = jsonData
        } catch {
            completionHandler(NSError(domain: "KTCMPPLoginRequestDomain", code: -1000, userInfo: [NSLocalizedDescriptionKey: "Error while creating JSON data: \(error.localizedDescription)"]), nil)
            return
        }
        
        let dataTask = urlSession?.dataTask(with: request) { [weak self] data, response, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                completionHandler(NSError(domain: "KTCMPPLoginRequestDomain", code: -1002, userInfo: [NSLocalizedDescriptionKey: "network error: \(error.localizedDescription)"]), nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                let userInfo = [NSLocalizedDescriptionKey: "Request error code: \((response as? HTTPURLResponse)?.statusCode ?? -1)"]
                completionHandler(NSError(domain: "KTCMPPLoginRequestDomain", code: -1001, userInfo: userInfo), nil)
                return
            }
            
            do {
                // 解析 JSON 数据
                if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // 获取 returnCode 并转换为 Int
                    let returnCode = jsonDict["returnCode"] as? String ?? "-1"
                    let errCode = Int(returnCode) ?? -1
                    
                    if errCode == 0 {
                        // 请求成功，返回 code
                        if let codeData = jsonDict["data"] as? [String: Any], let code = codeData["code"] as? String {
                            completionHandler(nil, code)
                            return
                        }
                    } else if errCode == 100006 {
                        // 特定错误码的处理
                        strongSelf.writeInfoFile(username: nil, expires: 0)
                    }

                    // 处理其他错误情况
                    let errMsg = jsonDict["returnMessage"] as? String ?? "Received response data error"
                    let userInfo = [NSLocalizedDescriptionKey: errMsg]
                    completionHandler(NSError(domain: "KTCMPPLoginRequestDomain", code: errCode, userInfo: userInfo), nil)
                } else {
                    // 如果 JSON 解析失败，处理错误
                    let userInfo = [NSLocalizedDescriptionKey: "Invalid JSON format"]
                    completionHandler(NSError(domain: "KTCMPPLoginRequestDomain", code: -1002, userInfo: userInfo), nil)
                }
            } catch {
                // JSON 解析抛出错误
                completionHandler(NSError(domain: "KTCMPPLoginRequestDomain", code: -1002, userInfo: [NSLocalizedDescriptionKey: "JSON parsing error: \(error.localizedDescription)"]), nil)
            }
        }
        
        dataTask?.resume()
    }
    
    func wxLogin(miniAppId: String, completionHandler: @escaping (NSError?, String?) -> Void) {
        if let token = token {
            getToken(miniAppId: miniAppId) { [weak self] err, value in
                if let err = err, err.code == 100006 {
                    self?.login { err, _ in
                        if let err = err {
                            completionHandler(err, nil)
                        } else {
                            self?.getToken(miniAppId: miniAppId, completionHandler: completionHandler)
                        }
                    }
                } else {
                    completionHandler(nil, value)
                }
            }
        } else {
            login { [weak self] err, _ in
                if let err = err {
                    completionHandler(err, nil)
                } else {
                    self?.getToken(miniAppId: miniAppId, completionHandler: completionHandler)
                }
            }
        }
    }
    
    func clearLoginInfo() {
        token = nil
        appId = nil
    }
}
