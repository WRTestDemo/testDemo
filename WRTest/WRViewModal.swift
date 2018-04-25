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

let kRequestDataFinishedNotification = "requestDataFinishedNotification"
let kLoadedImageNotification = "loadedImageNotification"

/// operation about data(request/response)
class WRViewModal: NSObject {
    //MARK: - data request
    var data: WRResponsData?
    
    lazy var request : WRDataRequest = {
        var request = WRDataRequest()
        request.delegate = self
        request.requestSerializer.timeoutInterval = 5
        
        return request
    }()

    /// request origin data
    func requestData() {
        request.requestData()
    }
    
    //MARK: - image
    lazy var imageManager: SDWebImageManager = {
        return SDWebImageManager()
    }()
    
    lazy var imageCache: SDImageCache = {
        return SDImageCache()
    }()
    
    func getCacheImage(_ url: String?) -> UIImage? {
        return imageCache.imageFromCache(forKey: url)
    }
    
    /// download image by SDWebImage, if has cache, use it first
    ///
    /// - Parameter url: imageUrl
    /// - Returns: UIimage
    func downloadImage(_ url: String?, _ indexPath: IndexPath) {
        if url == nil { return}
        
        let urlBody = url!
        
        //get cache first
        if getCacheImage(urlBody) != nil {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLoadedImageNotification),
                                            object: nil,
                                            userInfo: ["imgUrl": urlBody, "indexPath": indexPath])
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
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLoadedImageNotification),
                                                    object: nil,
                                                    userInfo: ["imgUrl": urlBody, "indexPath": indexPath])
                }
            })
        }
        
        
    }
}

//MARK: - WRDataRequestDelegate
extension WRViewModal: WRDataRequestDelegate {
    func dataRequestSuccessful(task: URLSessionDataTask, responseObject: Any?) {
        if (responseObject != nil) {
            self.data = responseObject as? WRResponsData
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kRequestDataFinishedNotification), object: nil, userInfo: ["state": ENetworkingStatue.success])
        }
    }
    func dataRequestFail(task: URLSessionDataTask?, error: ENetworkingStatue) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kRequestDataFinishedNotification), object: nil, userInfo: ["state": error])
    }
}
