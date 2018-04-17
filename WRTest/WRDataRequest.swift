//
//  WRDataRequest.swift
//  WRTest
//
//  Created by 王刃 on 2018/4/16.
//  Copyright © 2018年 W.R. All rights reserved.
//

import UIKit
import AFNetworking

protocol WRDataRequestDelegate {
    func dataRequestSuccessful(task: URLSessionDataTask, responseObject: Any?)
    func dataRequestFail(task: URLSessionDataTask?, _ error: Error)
}

class WRDataRequest: AFHTTPSessionManager {
    static let sharedInstance = WRDataRequest()
    
    var delegate: WRDataRequestDelegate?
    
    func requestData(_ url: String!) {
        
        //set response
        self.responseSerializer = AFHTTPResponseSerializer()
        self.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        //GET
        _ = [get(url, parameters: nil, progress: { (progress: Progress) in
            
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
            self.delegate?.dataRequestFail(task: task, error)
        }]
    }
    
    static func jsonParse(_ jsonDic: [String: Any]) -> WRResponsData? {
//        if jsonDic != nil {
            var responsData = WRResponsData()
            responsData.title = jsonDic["title"] as? String
            responsData.rows = jsonDic["rows"] as? Array
            
            var detailsArr = Array<Any>()

            for obj in responsData.rows! {
                let dic = obj as! [String: String?]
                
                var detail = WRDataDetails()
                detail.title = dic["title"]!
                detail.describe = dic["description"]!
                detail.imageUrl = dic["imageHref"]!
                
                detailsArr.append(detail)
            }
            responsData.rows = detailsArr
            
            return responsData
//        }
//        
//        return nil
    }
}
