//
//  MIniAppDemoSDKDelegateImpl.swift
//  TCMPPDemo-Swift
//
//  Created by v_zwtzzhou on 2023/8/30.
//

import Foundation
import TCMPPSDK

class MIniAppDemoSDKDelegateImpl : NSObject, TMFMiniAppSDKDelegate {
    
    static public let shared = MIniAppDemoSDKDelegateImpl();
    private static var noServer = true
    
    func log(_ level: MALogLevel, msg: String) {
        var strLevel = "Undef";
        switch (level){
        case .error:  strLevel = "Error"; break;
        case .warn:   strLevel = "Warn";  break;
        case .info:   strLevel = "Info";  break;
        case .debug:  strLevel = "Debug"; break;
        default: break;
        }
        NSLog("TMFMiniApp %@|%@", strLevel, msg);
    }
    
    // TMFMiniAppSDKDelegate
    func appName() -> String {
        return "TCMPP";
    }
    
    func fetchAppUserInfo(withScope scope: String, block: @escaping TMAAppFetchUserInfoBlock) {
        let filePath = Bundle.main.resourcePath?.appending("/avatar.png");
        let defaultAvatar = UIImage(contentsOfFile: filePath!);
        let avatarView = UIImageView(image: defaultAvatar);
        let userInfo = TMAAppUserInfo();
        userInfo.avatarView = avatarView;
        userInfo.nickName = TCMPPUserInfo.shared.nickName!;
        block(userInfo);
    }
    
    func getAppUID() -> String {
        return TCMPPUserInfo.shared.nickName!;
    }
    
    func shareMessage(with shareModel: TMAShareModel, appInfo: TMFMiniAppInfo, completionBlock: ((Error?) -> Void)? = nil) {
        NSLog("shareMessageWithModel \(shareModel.config.shareTarget)");

    }
    
    func getUserProfile(_ app: TMFMiniAppInfo, params: [AnyHashable : Any], completionHandler: @escaping MACommonCallback) {
        let userInfo = ["nickName": TCMPPUserInfo.shared.nickName!,
                        "avatarUrl": TCMPPUserInfo.shared.avatarUrl!,
                        "gender": TCMPPUserInfo.shared.gender!,
                        "country": TCMPPUserInfo.shared.country!,
                        "province": TCMPPUserInfo.shared.province!,
                        "city": TCMPPUserInfo.shared.city!,
                        "language": "zh_CN"] as [String : Any];
        
        completionHandler(userInfo, nil);
    }
    
    func getUserInfo(_ app: TMFMiniAppInfo, params: [AnyHashable : Any], completionHandler: @escaping MACommonCallback) {
        let userInfo = ["nickName": TCMPPUserInfo.shared.nickName!,
                        "avatarUrl": TCMPPUserInfo.shared.avatarUrl!,
                        "gender": TCMPPUserInfo.shared.gender!,
                        "country": TCMPPUserInfo.shared.country!,
                        "province": TCMPPUserInfo.shared.province!,
                        "city": TCMPPUserInfo.shared.city!,
                        "language": "zh_CN"] as [String : Any];
        
        completionHandler(userInfo, nil);
    }
    
    // After receiving the payment request from the mini program, the App uses the prepayId parameter in params to first call the order query interface to obtain detailed order information.
    // Then a pop-up window will pop up requesting the user to enter the payment password.
    // After the user successfully enters the password, the payment interface will be called. After success, the corresponding result will be returned to the mini program.
    func requestPayment(_ app: TMFMiniAppInfo, params: [AnyHashable : Any], completionHandler: @escaping MACommonCallback) {
        
        let prePayId: String = params["prepayId"] as! String
        PaymentManager.checkPreOrder(prePayId) { error, result in
            guard error == nil else {
                completionHandler(["retmsg":error?.localizedDescription ?? ""],error)
                return
            }
            
            let tradeNo = result?["out_trade_no"]
            let prePayId = result?["prepay_id"]
            let totalFee = result?["total_fee"]
            let totalFeeNo = Float(totalFee ?? "")
            
            DispatchQueue.main.async {
                let payAlert = TCMPPPayView()
                payAlert.title = NSLocalizedString("Please enter the payment password", comment: "")
                payAlert.detail = NSLocalizedString("Payment", comment: "")
                payAlert.money = totalFeeNo
                payAlert.defaultPass = NSLocalizedString("Default password:666666", comment: "")
                payAlert.show()
                payAlert.completeHandle = { inputPassword in
                    if let inputPassword = inputPassword {
                        if inputPassword == "666666" {
                            // Note: The payment interface is only a simple example. Both the client's signature and the server's signature verification are omitted.
                            // For the signature algorithm, please refer to WeChat Pay's signature algorithm:
                            // https://pay.weixin.qq.com/wiki/doc/api/wxa/wxa_api.php?chapter=4_3
                            PaymentManager.payOrder(tradeNo!, prePayId: prePayId!, totalFee: Int(totalFeeNo!)) { (err, result) in
                                if err == nil {
                                    DispatchQueue.main.async {
                                        let vc = TCMPPPaySucessVC()
                                        vc.iconURL = app.appIcon
                                        vc.name = app.appTitle
                                        vc.price = Double(totalFeeNo ?? 0)
                                        vc.dismissBlock = {
                                            completionHandler(["pay_time": Int(Date().timeIntervalSince1970), "order_no": tradeNo ?? ""], nil)
                                        }
                                        vc.modalPresentationStyle = .fullScreen
                                        let current = UIApplication.shared.keyWindow?.rootViewController
                                        if let nav = current?.presentedViewController as? UINavigationController {
                                            nav.topViewController?.present(vc, animated: true, completion: nil)
                                        }
                                    }
                                    return
                                } else {
                                    completionHandler(["retmsg": err?.localizedDescription ?? ""], err)
                                }
                            }
                        } else {
                            let userInfo = [NSLocalizedDescriptionKey: "wrong password"]
                            let error = NSError(domain: "KPayRequestDomain", code: -1003, userInfo: userInfo)
                            completionHandler(["retmsg": error.localizedDescription], error)
                        }
                    }
                }
                
                payAlert.cancelHandle = {
                    let userInfo = [NSLocalizedDescriptionKey: "pay cancel"]
                    let error = NSError(domain: "KPayRequestDomain", code: -1003, userInfo: userInfo)
                    completionHandler(["retmsg": error.localizedDescription], error)
                }
            }
        }
    }

    func whether(toUseCustomOpenApi app: TMFMiniAppInfo) -> Bool {
        true
    }
    
    func createAuthorizeAlertView(withFrame frame: CGRect, scope: String, title: String, desc: String, privacyApi: String, appInfo: TMFMiniAppInfo?, allow allowBlock: @escaping () -> Void, denyBlock: @escaping () -> Void) -> UIView {

        return AuthorizeAlertView(
            frame: UIScreen.main.bounds,
            scope: scope,
            title: title,
            desc: desc,
            privacyApi: privacyApi,
            appInfo: appInfo,
            allowBlock: {
                print("allow")
            },
            denyBlock: {
                print("reject")
            }
        )
    }
    
    func handleStartUpSuccess(withApp app: TMFMiniAppInfo) {
        NSLog("handleStartUpSuccess \(app)", app);
        NotificationCenter.default.post(name: Notification.Name("com.tencent.tcmpp.apps.change.notification"), object: nil);
    }
    
    func handleStartUpError(_ error: Error, app: String?, parentVC: UIViewController) {
        NSLog("handleStartUpError \(String(describing: app)) \(error)");
    }
    
    func uploadLogFile(withAppID appID: String) -> Bool {
        var path = TMFMiniAppSDKManager.sharedInstance().sandBoxPath(withAppID: appID);
        path.append("/usr/miniprogramLog/");
        NSLog(path);
        return true;
    }
    
    func vConsoleEnabled() -> Bool {
        return true;
    }
    
    func inspectableEnabled() -> Bool {
        return true;
    }
    
    func customizedConfig(forMoreButtonActions moreButtonTitleAndActions: NSMutableArray, withApp app: TMFMiniAppInfo) {
        // change restart icon
        for case let obj as TMASheetItemInfo in moreButtonTitleAndActions {
            if obj.type == .typeHomePage {
                obj.title = "Restart"
                obj.icon = UIImage(named: "success")!
            }
        }
        
        // add whatsapp share
        let whatsapp = TMASheetItemInfo(title: "WhatsApp",
                                        type: .typeCustomizedShare,
                                       shareTarget: 101,
                                       shareKey: "WhatsApp")
        whatsapp.icon = UIImage(named: "whatsapp")!
        moreButtonTitleAndActions.insert(whatsapp, at: 0)
    }
    
    func getCurrentLocalLanguage() -> String {
        return LanguageManager.shared.currentLanguage()
    }
}
