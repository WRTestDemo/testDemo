//
//  WRResponsData.swift
//  WRTest
//
//  Created by 王刃 on 2018/4/17.
//  Copyright © 2018年 W.R. All rights reserved.
//

import Foundation

struct WRResponsData {
    var title: String?
    var rows: Array<Any>?
}

struct WRDataDetails {
    var title: String?
    var imageUrl: String?
    var describe: String?
    
    func isValid() -> Bool {
        if title == nil
        && imageUrl == nil
        && describe == nil {
            return false
        }
        return true
    }
}
