//
//  AppDelegate.swift
//  TCMPPDemo-Swift
//
//  Created by v_zwtzzhou on 2023/8/30.
//

import UIKit
import TCMPPSDK

// Swift 文件
@_silgen_name("_TMARegisterExternalJSPlugin")
func TMARegisterExternalJSPlugin(_ pluginClass: AnyClass)

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?;

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.prepareApplet();
        self.registJSApis();
        LanguageManager.shared.reloadBundleClass()
        autoLogin();
        
        return true;
    }
    
    func autoLogin() {
        let currentUser = DemoUserInfo.shared.nickName
        if currentUser?.count ?? 0 > 0 {
            let rootViewController = TCMPPMainVC()
            let navigationController = UINavigationController(rootViewController: rootViewController)
            self.window?.rootViewController = navigationController
            if #available(iOS 13.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = .white
                appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
                appearance.shadowColor = .clear
                navigationController.navigationBar.standardAppearance = appearance
                navigationController.navigationBar.scrollEdgeAppearance = appearance
            } else {
                navigationController.navigationBar.barTintColor = .white
                navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            }
            TCMPPDemoLoginManager.shared.loginUser(userId: currentUser!) { (err, value) in
                if err == nil {
                    DispatchQueue.main.async {
                        let icon = UIImage(named: "success")
                        let toast = ToastView(icon: icon!, title: NSLocalizedString("Logged in successfully", comment: ""))
                        toast.show(withDuration: 2)
                    }
                } else {
                    DispatchQueue.main.async {
                        UserDefaults.standard.removeObject(forKey: "currentUser")
                        let loginVC = TCMPPLoginVC()
                        self.window?.rootViewController = loginVC
                    }
                }
            }
        } else {
            let loginVC = TCMPPLoginVC()
            self.window?.rootViewController = loginVC
        }
        self.window?.makeKeyAndVisible()
    }
    
    func prepareApplet(){
        let configItem = TMFAppletConfigManager.shared.getCurrentConfigItem();
     
        
        // 配置使用环境
        let filePath = Bundle.main.path(forResource: "tcsas-ios-configurations", ofType: "json");
        if ((filePath) != nil){
            let config = TMAServerConfig(file: filePath!);
            TMFMiniAppSDKManager.sharedInstance().setConfiguration(config);
        }
        
        let apiConfigPath = Bundle.main.path(forResource: "api-custom-config", ofType: "json");
        if ((apiConfigPath) != nil){
            TMFMiniAppSDKManager.sharedInstance().setCustomApiConfigFile(apiConfigPath!);
        }
        
        TMFMiniAppSDKManager.sharedInstance().miniAppSdkDelegate = MIniAppDemoSDKDelegateImpl.shared;
    }
    
    func registJSApis(){
        TMARegisterExternalJSPlugin(PayRequestJSApi.self);
    }

}

