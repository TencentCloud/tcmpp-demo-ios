//
//  PayRequestJsApi.swift
//  TCMPPDemo-Swift
//
//  Created by v_zwtzzhou on 2023/9/4.
//

import Foundation

@objc class PayRequestJSApi : NSObject{
   
    @objc func __tma_external_api__requestPayment(_ name: String, params: [String : Any]?, context: TMAExternalJSContextProtocol) -> TMAExternalJSPluginResult?{
        let appInfo = context.tmfAppInfo;
        let data = params?["data"] as! [String : Any];
        
        NSLog("************ invokeNativePlugin test,appId:\(appInfo?.appId ?? ""),data is \(String(describing: data))");
        
        DispatchQueue.main.async {
            let money = data["money"] as! String;
            if (Double(money) ?? 0 <= 0){
                let pluginResult = TMAExternalJSPluginResult();
                let userInfo = [NSLocalizedDescriptionKey: "parameter error"];
                pluginResult.error = NSError(domain: "KPayRequestDomain", code: -1001, userInfo: userInfo);
                context.doCallback(pluginResult);
            } else {
                let payAlert = TCMPPPayView();
                payAlert.title = NSLocalizedString("Please enter the payment password", comment: "");
                payAlert.detail = NSLocalizedString("Payment", comment: "");
                payAlert.money = money;
                payAlert.defaultPass = NSLocalizedString("Default password:666666", comment: "");
                payAlert.completeHandle = {(inputPassword: String?) in
                    if (inputPassword != nil) {
                        if (inputPassword == "666666") {
                            let pluginResult = TMAExternalJSPluginResult();
                            pluginResult.result = ["result": "pay sucess"];
                            context.doCallback(pluginResult);
                        } else {
                            let pluginResult = TMAExternalJSPluginResult();
                            let userInfo = [NSLocalizedDescriptionKey: "password error"];
                            pluginResult.error = NSError(domain:"KPayRequestDomain", code:-1002, userInfo:userInfo);
                            context.doCallback(pluginResult);
                        }
                    }
                }
                payAlert.cancelHandle = {() in
                    let pluginResult = TMAExternalJSPluginResult();
                    let userInfo = [NSLocalizedDescriptionKey: "pay cancel"];
                    pluginResult.error = NSError(domain:"KPayRequestDomain", code:-1003, userInfo:userInfo);
                    context.doCallback(pluginResult);
                };
                
                payAlert.show();
            }
        }
        return nil;
    }
}
