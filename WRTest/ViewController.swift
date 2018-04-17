//
//  ViewController.swift
//  WRTest
//
//  Created by 王刃 on 2018/4/16.
//  Copyright © 2018年 W.R. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = UIButton.init(type: .custom)
        button.frame = CGRectFromString("{{0,0},{100,50}}")
        button.center = view.center
        button.backgroundColor = UIColor.orange
        button.addTarget(self, action: .button_clicked, for: .touchUpInside)
        view.addSubview(button)
        
    }
    
    var tableVC = TableViewController()
    
    func buttonClicked(_ sender: Any?) {
        let url = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
        WRDataRequest.sharedInstance.delegate = self
        WRDataRequest.sharedInstance.requestData(url)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: WRDataRequestDelegate {
    func dataRequestSuccessful(task: URLSessionDataTask, responseObject: Any?) {
        if (responseObject != nil) {
            let data = responseObject as! WRResponsData
            print(data)
        }
    }
    
    func dataRequestFail(task: URLSessionDataTask?, _ error: Error) {
        
    }
}

private extension Selector {
    static let button_clicked = #selector(ViewController.buttonClicked(_:))
}
