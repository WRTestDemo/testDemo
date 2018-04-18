//
//  WRTipsView.swift
//  WRTest
//
//  Created by 王刃 on 2018/4/18.
//  Copyright © 2018年 W.R. All rights reserved.
//

import UIKit
import Masonry

let kTipsViewTag = 1010

enum ETipsType: String {
    case successed
    case failed
}

class WRTipsView: UIView {
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        
        self.addSubview(label)
        label.mas_makeConstraints({ (make: MASConstraintMaker!) in
            make.edges.equalTo()(self)
        })
        return label
    }()
    
    func setupBasicUI() {
        backgroundColor = .black
        alpha = 0.7
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    static func showTipsView(_ type: ETipsType, _ superView: UIView) {
        //protect
        WRTipsView.hideTipsView(superView)
        
        let tipsView = WRTipsView()
        tipsView.tag = kTipsViewTag
        tipsView.setupBasicUI()
        
        superView.addSubview(tipsView)
        tipsView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.center.equalTo()(superView)
            make.width.equalTo()(95)
            make.height.equalTo()(65)
        }
        
        tipsView.tipsLabel.text = type.rawValue
    }
    
    static func hideTipsView(_ superView: UIView) {
//        let tipsView = WRTipsView().viewWithTag(kTipsViewTag)
//        tipsView?.removeFromSuperview()
        for view in superView.subviews {
            if view.tag == kTipsViewTag {
                view.removeFromSuperview()
                break
            }
        }
    }
}