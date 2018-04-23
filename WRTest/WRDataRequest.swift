//
//  WRDataRequest.swift
//  WRTest
//
//  Created by 王刃 on 2018/4/16.
//  Copyright © 2018年 W.R. All rights reserved.
//

import UIKit
import AFNetworking

let kUrl = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"

protocol WRDataRequestDelegate {
    func dataRequestSuccessful(task: URLSessionDataTask, responseObject: Any?)
    func dataRequestFail(task: URLSessionDataTask?, error: ENetworkingStatue)
}

class WRDataRequest: AFHTTPSessionManager {
    var url: String?
    var delegate: WRDataRequestDelegate?
    
    func requestData() {
        self.url = kUrl
        
        //set response
        self.responseSerializer = AFHTTPResponseSerializer()
        self.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        //GET
        get(url!, parameters: nil, progress: { (progress: Progress) in
            
        }, success: { (task: URLSessionDataTask, responseObject: Any?) in
            
            do {
                var responsString = String.init(data: responseObject as! Data, encoding: .ascii)
                responsString = responsString?.replacingOccurrences(of: "\\'", with: "'")
                
                let data = responsString!.data(using: .utf8)
                
                let responseDic = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                let responseData = WRDataRequest.jsonParse(responseDic!)
                
                self.delegate?.dataRequestSuccessful(task: task, responseObject: responseData)
                
            }catch {
                
            }
            
        }) { (task: URLSessionDataTask?, error: Error) in
            let errState = WRDataRequest.errorState(code: (error as! URLError).code.rawValue)
            self.delegate?.dataRequestFail(task: task, error: errState)
        }
    }
    
    static func jsonParse(_ jsonDic: [String: Any]) -> WRResponsData? {
//        if jsonDic != nil {
            var responsData = WRResponsData(title: jsonDic["title"] as? String, rows: jsonDic["rows"] as? Array)
            
            var detailsArr = Array<Any>()

            for obj in responsData.rows! {
                let dic = obj as! [String: String?]
                
                let detail = WRDataDetails(title: dic["title"]!, imageUrl: dic["imageHref"]!, describe: dic["description"]!)
                if detail.isValid() {
                    detailsArr.append(detail)
                }
            }
            responsData.rows = detailsArr
            
            return responsData
//        }
//        
//        return nil
    }
    
    static func errorState(code: Int) -> ENetworkingStatue {
        if code == URLError.notConnectedToInternet.rawValue {
            return .no_Network
        }else if code == URLError.timedOut.rawValue {
            return .time_out
        }else {
            return .failed
        }
    }
}
