//
//  TCMPPDemoLoginManager.swift
//  TCMPPDemo-Swift
//
//  Created by gavinjwxu on 2024/8/13.
//

import Foundation
import TCMPPSDK

// MARK: - Constants
private let TCMPP_LOGIN_URL = "https://openapi-sg.tcmpp.com/superappv2/"
private let TCMPP_API_AUTH = "login"
private let TCMPP_API_UPDATE_USERINFO = "user/updateUserInfo"
private let TCMPP_API_MESSAGE = "user/message"

// MARK: - Type Aliases
typealias LoginRequestHandler = (NSError?, String?, [String: Any]?) -> Void
typealias UpdateUserInfoSuccessBlock = (Bool, String) -> Void
typealias UpdateUserInfoFailureBlock = (NSError) -> Void
typealias GetSubscribeSuccessBlock = ([[String: Any]]) -> Void

class TCMPPDemoLoginManager {
    static let shared = TCMPPDemoLoginManager()
    
    private var urlSession: URLSession?
    private var userId: String?
    
    private init() {}
    
    // MARK: - Public Methods
    
    func getUserId() -> String? {
        return userId
    }
    
    func clearLoginInfo() {
        userId = nil
        TCMPPUserInfo.shared.clearUserInfo()
    }
    
    // MARK: - Login Methods
    
    func loginWithAccount(_ account: String, completionHandler: LoginRequestHandler?) {
        if urlSession == nil {
            urlSession = URLSession(configuration: .default)
        }
        
        let urlString = "\(TCMPP_LOGIN_URL)\(TCMPP_API_AUTH)"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "KTCMPPLoginRequestDomain", code: -1000, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completionHandler?(error, nil, nil)
            return
        }
        
        print("loginWithAccount url = \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let appId = TMFMiniAppSDKManager.sharedInstance().getConfigAppKey()
        let password = "123456"
        
        if appId.isEmpty {
            print("appID is nil")
            return
        }
        
        let jsonBody: [String: Any] = [
            "appId": appId,
            "userAccount": account,
            "userPassword": password
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
            request.httpBody = jsonData
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Error: \(error.localizedDescription) while creating JSON data"]
            let error = NSError(domain: "KWeiMengRequestDomain", code: -1000, userInfo: userInfo)
            completionHandler?(error, nil, nil)
            return
        }
        
        let dataTask = urlSession?.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("tcmpp login request error: \(error)")
                completionHandler?(error as NSError, nil, nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "KTCMPPLoginRequestDomain", code: -1001, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                completionHandler?(error, nil, nil)
                return
            }
            
            if httpResponse.statusCode != 200 {
                print("tcmpp login request error code: \(httpResponse.statusCode)")
                let userInfo = [NSLocalizedDescriptionKey: "request error code: \(httpResponse.statusCode)"]
                let error = NSError(domain: "KTCMPPLoginRequestDomain", code: -1001, userInfo: userInfo)
                completionHandler?(error, nil, nil)
                return
            }
            
            var errMsg = "received response data error"
            var errCode = -1002
            
            if let data = data {
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let jsonDict = jsonDict {
                        print("TCMPP login response jsonDict: \(String(data: data, encoding: .utf8) ?? "")")
                        
                        if let returnCode = jsonDict["returnCode"] as? String {
                            errCode = Int(returnCode) ?? -1
                            
                            if errCode == 0 {
                                if let dataJson = jsonDict["data"] as? [String: Any] {
                                    // Save user info to TCMPPUserInfo
                                    TCMPPUserInfo.shared.setUserInfo(dataJson)
                                    
                                    if let userId = dataJson["userId"] as? String {
                                        self?.userId = userId
                                        completionHandler?(nil, userId, dataJson)
                                        return
                                    }
                                }
                            } else {
                                errMsg = jsonDict["returnMessage"] as? String ?? errMsg
                            }
                        }
                    }
                } catch {
                    print("JSON parsing error: \(error)")
                }
            }
            
            let userInfo = [NSLocalizedDescriptionKey: errMsg]
            let error = NSError(domain: "KTCMPPLoginRequestDomain", code: errCode, userInfo: userInfo)
            completionHandler?(error, nil, nil)
        }
        
        dataTask?.resume()
    }
    
    // MARK: - Update User Info Methods
    func updateUserInfo(email: String?, avatar: Data?, nickName: String?, phoneNumber: String?, success: UpdateUserInfoSuccessBlock?, failure: UpdateUserInfoFailureBlock?) {
        if urlSession == nil {
            urlSession = URLSession(configuration: .default)
        }
        
        let urlString = "\(TCMPP_LOGIN_URL)\(TCMPP_API_UPDATE_USERINFO)"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "KTCMPPLoginRequestDomain", code: -1000, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            failure?(error)
            return
        }
        
        let appId = TMFMiniAppSDKManager.sharedInstance().getConfigAppKey()
        let token = TCMPPUserInfo.shared.token
        
        if appId.isEmpty {
            print("appId is nil")
            return
        }
        
        if token == nil || token!.isEmpty {
            print("token is nil")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"token\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(token!)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"appId\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(appId)\r\n".data(using: .utf8)!)
        
        if let email = email, !email.isEmpty {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"email\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(email)\r\n".data(using: .utf8)!)
        }
        
        if let avatarData = avatar {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"avatar\"; filename=\"avatar.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(avatarData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        if let nickName = nickName, !nickName.isEmpty {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"nickName\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(nickName)\r\n".data(using: .utf8)!)
        }
        
        if let phoneNumber = phoneNumber, !phoneNumber.isEmpty {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"phoneNumber\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(phoneNumber)\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let dataTask = urlSession?.dataTask(with: request) { data, response, error in
            if let error = error {
                print("tcmpp updateUserInfo error: \(error)")
                failure?(error as NSError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "KTCMPPLoginRequestUpdateUserInfo", code: -1001, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                failure?(error)
                return
            }
            
            if httpResponse.statusCode != 200 {
                print("tcmpp updateUserInfo request error code: \(httpResponse.statusCode)")
                let userInfo = [NSLocalizedDescriptionKey: "request error code: \(httpResponse.statusCode)"]
                let error = NSError(domain: "KTCMPPLoginRequestUpdateUserInfo", code: -1001, userInfo: userInfo)
                failure?(error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "KTCMPPLoginRequestUpdateUserInfo", code: -1002, userInfo: [NSLocalizedDescriptionKey: "No response data"])
                failure?(error)
                return
            }
            
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let jsonDict = jsonDict {
                    print("TCMPP updateUserInfo response jsonDict: \(String(data: data, encoding: .utf8) ?? "")")
                    
                    if let returnCode = jsonDict["returnCode"] as? String {
                        let errCode = Int(returnCode) ?? -1
                        
                        if errCode == 0 {
                            if let dataJson = jsonDict["data"] as? [String: Any],
                               let result = dataJson["result"] as? Bool,
                               result {
                                success?(true, "Update successful")
                                return
                            }
                        }
                        
                        let errMsg = jsonDict["returnMessage"] as? String ?? "Update failed"
                        let error = NSError(domain: "KTCMPPLoginRequestDomain", code: errCode, userInfo: [NSLocalizedDescriptionKey: errMsg])
                        failure?(error)
                        return
                    }
                }
            } catch {
                print("JSON parsing error: \(error)")
                let error = NSError(domain: "KTCMPPLoginRequestUpdateUserInfo", code: -1002, userInfo: [NSLocalizedDescriptionKey: "JSON parsing error"])
                failure?(error)
                return
            }
            
            let error = NSError(domain: "KTCMPPLoginRequestDomain", code: -1002, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
            failure?(error)
        }
        
        dataTask?.resume()
    }
    
    // MARK: - Get Message Methods
    
    func getMessage(token: String, appId: String, offset: Int, success: GetSubscribeSuccessBlock?, failure: UpdateUserInfoFailureBlock?) {
        if urlSession == nil {
            urlSession = URLSession(configuration: .default)
        }
        
        let urlString = "\(TCMPP_LOGIN_URL)\(TCMPP_API_MESSAGE)"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "KTCMPPLoginRequestDomain", code: -1000, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            failure?(error)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if appId.isEmpty {
            print("appId is nil")
            return
        }
        
        if token.isEmpty {
            print("token is nil")
            return
        }
        
        let jsonBody: [String: Any] = [
            "appId": appId,
            "token": token,
            "offset": offset
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
            request.httpBody = jsonData
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Error: \(error.localizedDescription) while creating JSON data"]
            let error = NSError(domain: "KWeiMengRequestDomain", code: -1000, userInfo: userInfo)
            failure?(error)
            return
        }
        
        let dataTask = urlSession?.dataTask(with: request) { data, response, error in
            if let error = error {
                print("tcmpp getMessage error: \(error)")
                failure?(error as NSError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "KTCMPPLoginRequestGetMessage", code: -1001, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                failure?(error)
                return
            }
            
            if httpResponse.statusCode != 200 {
                print("tcmpp getMessage request error code: \(httpResponse.statusCode)")
                let userInfo = [NSLocalizedDescriptionKey: "request error code: \(httpResponse.statusCode)"]
                let error = NSError(domain: "KTCMPPLoginRequestGetMessage", code: -1001, userInfo: userInfo)
                failure?(error)
                return
            }
            
            var errMsg = "received response data error"
            var errCode = -1002
            
            if let data = data {
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let jsonDict = jsonDict {
                        print("TCMPP getMessage response jsonDict: \(String(data: data, encoding: .utf8) ?? "")")
                        
                        if let returnCode = jsonDict["returnCode"] as? String {
                            errCode = Int(returnCode) ?? -1
                            
                            if errCode == 0 {
                                if let dataJson = jsonDict["data"] as? [[String: Any]] {
                                    success?(dataJson)
                                    return
                                }
                            } else {
                                errMsg = jsonDict["returnMessage"] as? String ?? errMsg
                            }
                        }
                    }
                } catch {
                    print("JSON parsing error: \(error)")
                }
            }
            
            let userInfo = [NSLocalizedDescriptionKey: errMsg]
            let error = NSError(domain: "KTCMPPLoginRequestDomain", code: errCode, userInfo: userInfo)
            failure?(error)
        }
        
        dataTask?.resume()
    }
    
    // MARK: - Legacy Methods for Backward Compatibility
    
    func loginUser(userId: String, completionHandler: @escaping (NSError?, String?) -> Void) {
        self.userId = userId
        loginWithAccount(userId) { error, userId, data in
            completionHandler(error, userId)
        }
    }
    
    func wxLogin(miniAppId: String, completionHandler: @escaping (NSError?, String?) -> Void) {
        // This method is kept for backward compatibility but should be updated to use the new API
        if TCMPPUserInfo.shared.token != nil {
            // If we have a token, try to get a code directly
            getToken(miniAppId: miniAppId, completionHandler: completionHandler)
        } else {
            // If no token, login first
            loginUser(userId: "demo_user") { [weak self] error, _ in
                if let error = error {
                    completionHandler(error, nil)
                } else {
                    self?.getToken(miniAppId: miniAppId, completionHandler: completionHandler)
                }
            }
        }
    }
    
    private func getToken(miniAppId: String, completionHandler: @escaping (NSError?, String?) -> Void) {
        // This is a simplified version for backward compatibility
        // In a real implementation, you would call the actual getCode API
        completionHandler(nil, "demo_code")
    }
} 
