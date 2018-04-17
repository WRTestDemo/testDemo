//
//  ViewController.swift
//  WRTest
//
//  Created by 王刃 on 2018/4/16.
//  Copyright © 2018年 W.R. All rights reserved.
//

import UIKit

class ViewController: UINavigationController {
    
    var tableViewController = TableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pushViewController(tableViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
