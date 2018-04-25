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

//enum ETipsType: String {
//    case successed
//    case failed
//}

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
    
    /// show tipsView then dismiss
    ///
    /// - Parameters:
    ///   - duration: after duration tipsView will dismiss
    ///   - tips: notice string
    static func showTipsView(_ duration: DispatchTime, _ tips: String, _ superview: UIView) {
        WRTipsView.showTipsView(tips, superview)
        DispatchQueue.main.asyncAfter(deadline: duration, execute: {
            WRTipsView.hideTipsView(superview)
        })
    }
    
    /// show tipsView (will not dismiss), dismiss by hideTipsView(:)
    ///
    /// - Parameters:
    ///   - type: <#type description#>
    ///   - superView: <#superView description#>
    static func showTipsView(_ tips: String, _ superView: UIView) {
        //protect
        WRTipsView.hideTipsView(superView)
        
        let tipsView = WRTipsView()
        tipsView.tag = kTipsViewTag
        tipsView.setupBasicUI()
        
        superView.addSubview(tipsView)
        tipsView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.centerX.equalTo()(superView)
            make.centerY.equalTo()(superView)?.offset()(superView.bounds.origin.y)
            make.width.equalTo()(100)
            make.height.equalTo()(45)
        }
        
        tipsView.tipsLabel.text = tips
    }
    
    /// hide tipsView
    ///
    /// - Parameter superView: <#superView description#>
    static func hideTipsView(_ superView: UIView) {
        let tipsView = superView.viewWithTag(kTipsViewTag)
        tipsView?.removeFromSuperview()
    }
}
