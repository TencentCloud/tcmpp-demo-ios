//
//  PaymentManager.swift
//  TCMPPDemo-Swift
//
//  Created by gavinjwxu on 2024/8/14.
//

import Foundation
import TCMPPSDK

class XMLParser: NSObject, XMLParserDelegate {
    var resultDict = [String: String]()
    var currentElementValue = ""

    func dictionary(fromXMLData xmlData: Data) -> [String: String]? {
        let parser = Foundation.XMLParser(data: xmlData)
        parser.delegate = self
        if parser.parse() {
            return resultDict
        } else {
            print("Parse error: \(parser.parserError?.localizedDescription ?? "")")
            return nil
        }
    }

    func parser(_ parser: Foundation.XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElementValue = ""
    }

    func parser(_ parser: Foundation.XMLParser, foundCharacters string: String) {
        currentElementValue.append(string)
    }

    func parser(_ parser: Foundation.XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName != "xml" {
            resultDict[elementName] = currentElementValue
        }
    }
}

class PaymentManager {
    static let TCMPP_PAY_URL = "https://openapi-sg.tcmpp.com/superapp/pay/"
    static let TCMPP_API_QUERY = "queryPreOrder"
    static let TCMPP_API_PAY = "payOrder"

    typealias TCMPPPayRequestHandler = (NSError?, [String: String]?) -> Void

    static func checkPreOrder(_ prePayId: String, completion handler: @escaping TCMPPPayRequestHandler) {
        guard let url = URL(string: TCMPP_PAY_URL + TCMPP_API_QUERY) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/xml", forHTTPHeaderField: "Content-Type")

        let xmlString = "<xml><prepay_id>\(prePayId)</prepay_id></xml>"
        let xmlData = xmlString.data(using: .utf8)
        request.httpBody = xmlData

        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error as? NSError {
                print("tcmpp pay query error: \(error)")
                handler(error, nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            if httpResponse.statusCode != 200 {
                print("tcmpp login request error code: \(httpResponse.statusCode)")
                let userInfo = [NSLocalizedDescriptionKey: "request error code: \(httpResponse.statusCode)"]
                handler(NSError(domain: "KTCMPPPayQueryDomain", code: -1001, userInfo: userInfo), nil)
                return
            }
            
            var errMsg = "received response data error"
            let errCode = -1002
            
            if let data = data {
                let parser = XMLParser()
                if let result = parser.dictionary(fromXMLData: data),
                   let returnCode = result["return_code"], returnCode == "SUCCESS" {
                    handler(nil, result)
                    return
                } else {
                    let result = parser.dictionary(fromXMLData: data)
                    errMsg = result?["return_msg"] ?? ""
                }
            }
            
            let userInfo = [NSLocalizedDescriptionKey: errMsg]
            handler(NSError(domain: "KTCMPPPayQueryDomain", code: errCode, userInfo: userInfo), nil)
        }
        dataTask.resume()
    }

    static func payOrder(_ tradeNo: String, prePayId: String, totalFee: Int, completion handler: @escaping TCMPPPayRequestHandler) {
        guard let url = URL(string: TCMPP_PAY_URL + TCMPP_API_PAY) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
        
        let xmlString = "<xml><out_trade_no>\(tradeNo)</out_trade_no><prepay_id>\(prePayId)</prepay_id><total_fee>\(totalFee)</total_fee></xml>"
        let xmlData = xmlString.data(using: .utf8)
        request.httpBody = xmlData
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error as? NSError {
                print("tcmpp pay query error: \(error)")
                handler(error, nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            if httpResponse.statusCode != 200 {
                print("tcmpp login request error code: \(httpResponse.statusCode)")
                let userInfo = [NSLocalizedDescriptionKey: "request error code: \(httpResponse.statusCode)"]
                handler(NSError(domain: "KTCMPPPayQueryDomain", code: -1001, userInfo: userInfo), nil)
                return
            }
            
            var errMsg = "received response data error"
            let errCode = -1002
            
            if let data = data {
                let parser = XMLParser()
                if let result = parser.dictionary(fromXMLData: data),
                   let returnCode = result["return_code"], returnCode == "SUCCESS" {
                    handler(nil, result)
                    return
                } else {
                    let result = parser.dictionary(fromXMLData: data)
                    errMsg = result?["return_msg"] ?? ""
                }
            }
            
            let userInfo = [NSLocalizedDescriptionKey: errMsg]
            handler(NSError(domain: "KTCMPPPayQueryDomain", code: errCode, userInfo: userInfo), nil)
        }
        dataTask.resume()
    }
}
