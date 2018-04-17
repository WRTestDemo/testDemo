//
//  WRViewModal.swift
//  WRTest
//
//  Created by 王刃 on 2018/4/17.
//  Copyright © 2018年 W.R. All rights reserved.
//

import Foundation
import UIKit
//import "UIImageView+WebCache.h"

let kUrl = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
let kRequestDataFinishedNotification = "requestDataFinishedNotification"

class WRViewModal: NSObject {
    var data: WRResponsData?
    
    lazy var request : WRDataRequest = {
        var request = WRDataRequest.sharedInstance
        request.delegate = self
        request.requestSerializer.timeoutInterval = 5
        
        return request
    }()
    
    /// request origin data
    func requestData() {
        request.requestData(kUrl)
    }
    
    /// download image by SDWebImage
    ///
    /// - Parameter url: imageUrl
    /// - Returns: UIimage
    func downloadImage(_ url: String) -> UIImage? {
        
        return nil
    }
}

extension WRViewModal: WRDataRequestDelegate {
    func dataRequestSuccessful(task: URLSessionDataTask, responseObject: Any?) {
        if (responseObject != nil) {
            self.data = responseObject as? WRResponsData
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kRequestDataFinishedNotification), object: nil, userInfo: ["state": ENetworkingStatue.success])
        }
    }
    func dataRequestFail(task: URLSessionDataTask?, _ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kRequestDataFinishedNotification), object: nil, userInfo: ["state": ENetworkingStatue.failed])
    }
}
