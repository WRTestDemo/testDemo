//
//  WRViewModal.swift
//  WRTest
//
//  Created by 王刃 on 2018/4/17.
//  Copyright © 2018年 W.R. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

let kUrl = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"

let kRequestDataFinishedNotification = "requestDataFinishedNotification"
let kLoadedImageNotification = "loadedImageNotification"

class WRViewModal: NSObject {
    var data: WRResponsData?
    
    lazy var request : WRDataRequest = {
        var request = WRDataRequest.sharedInstance
        request.delegate = self
        request.requestSerializer.timeoutInterval = 5
        
        return request
    }()
    
    lazy var imageManager: SDWebImageManager = {
        return SDWebImageManager.shared()
    }()
    
    lazy var imageCache: SDImageCache = {
        return SDImageCache.shared()
    }()
    
    /// request origin data
    func requestData() {
        request.requestData(kUrl)
    }
    
    /// download image by SDWebImage, if has cache, use it first
    ///
    /// - Parameter url: imageUrl
    /// - Returns: UIimage
    func downloadImage(_ url: String?, _ indexPath: IndexPath) {
        if url == nil { return}
        
        //cleartext
        let urlBody = url!//?.replacingOccurrences(of: "http://", with: "")
        
//        WRImageDownloader.shared.download(urlBody!)
        
        //get cache first
        if let img = imageCache.imageFromMemoryCache(forKey: urlBody) {
            print("----------- get cache")
            print(img, indexPath)
            print("---------------------")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLoadedImageNotification),
                                            object: nil,
                                            userInfo: ["img": img, "indexPath": indexPath])
        }else {
            let charSet = CharacterSet(charactersIn: "#%^{}\"[]|\\<>=")
            let imageURL = URL(string: (urlBody.addingPercentEncoding(withAllowedCharacters: charSet.inverted))!)
            
            weak var weakSelf = self
            imageManager.imageDownloader?.downloadImage(with: imageURL, options: .progressiveDownload, progress: { (min: Int, max: Int, url: URL?) in
                
            }, completed: { (img: UIImage?, data: Data?, error: Error?, finished: Bool) in
                //completed
                if img != nil && finished{
                    //store to cache
                    weakSelf?.imageCache.store(img, forKey: urlBody, completion: nil)
                    
                    print("----------- store")
                    print(img!, indexPath)
                    print(urlBody)
                    print("-----------------")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLoadedImageNotification),
                                                    object: nil,
                                                    userInfo: ["img": img!, "indexPath": indexPath])
                    
                }
            })
        }
        
        
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
