//
//  WRImageRequest.swift
//  WRTest
//
//  Created by 王刃 on 2018/4/18.
//  Copyright © 2018年 W.R. All rights reserved.
//

import Foundation
import AFNetworking

class WRImageDownloader: AFURLSessionManager {
    static let shared = WRImageDownloader()
    
    var urlString: String?
    
    func download(_ url: String) {
        urlString = url
        
        let configuration = URLSessionConfiguration.default
        let manager = WRImageDownloader(sessionConfiguration: configuration)
        manager.securityPolicy.allowInvalidCertificates = true
        
//        manager.responseSerializer = AFURLResponseSerializer()
//        manager.requestSerializer = AFURLRequestSerializer()
        
        let Url = URL(string: urlString!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        let request = URLRequest(url: Url!)
        let downloadTask = manager.downloadTask(with: request, progress: { (progress: Progress) in
            //progress
            print(progress)
        }, destination: { (url: URL, response: URLResponse) -> URL in
            print("destination")
            return url
        }, completionHandler: { (response: URLResponse, url: URL?, error: Error?) in
            print("completionHandler")
        })
        
        downloadTask.resume()
        /*
         NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
         // 1. 创建会话管理者
         AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
         
         // 2. 创建下载路径和请求对象
         NSURL *URL = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
         NSURLRequest *request = [NSURLRequest requestWithURL:URL];
         NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
         
         // 下载进度
         self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
         self.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
         
         } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
         
         NSURL *path = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
         return [path URLByAppendingPathComponent:@"QQ_V5.4.0.dmg"];
         
         } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
         NSLog(@"File downloaded to: %@", filePath);
         }];
         
         // 4. 开启下载任务
         [downloadTask resume];
 */
    }
}
