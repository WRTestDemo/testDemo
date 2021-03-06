//
//  WRTableViewCell.swift
//  WRTest
//
//  Created by 王刃 on 2018/4/17.
//  Copyright © 2018年 W.R. All rights reserved.
//

import UIKit
import Masonry

let kNormalGap = 10
let kMiddleGap = 8
let kSmallGap = 5

struct CellData {
    var title: String?
    var desc: String?
    var imageUrl: String?
    var image: UIImage?
}

class WRTableViewCell: UITableViewCell {
    
    var cellData: CellData?
    
    lazy var imgView: UIImageView = {
        var imgV = UIImageView(image: nil)
//        imgV.backgroundColor = .green
        self.addSubview(imgV)
        
        return imgV
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
//        label.backgroundColor = .red
        self.addSubview(label)
        
        return label
    }()
    
    lazy var descLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
//        label.backgroundColor = .yellow
        self.addSubview(label)
        
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imgView.mas_makeConstraints { (_ make: MASConstraintMaker!) in
            make.top.equalTo()(self)?.offset()(CGFloat(kNormalGap))
            make.centerX.equalTo()(self)
        }
        titleLabel.mas_makeConstraints { (_ make: MASConstraintMaker!) in
            make.top.equalTo()(imgView.mas_bottom)?.offset()(CGFloat(kMiddleGap))
            make.left.equalTo()(self)?.offset()(CGFloat(kNormalGap))
            make.right.equalTo()(self)?.offset()((CGFloat)(-kNormalGap))
        }
        descLabel.mas_makeConstraints { (_ make: MASConstraintMaker!) in
            make.top.equalTo()(titleLabel.mas_bottom)?.offset()(CGFloat(kSmallGap))
            make.left.equalTo()(titleLabel.mas_left)
            make.bottom.equalTo()(self)?.offset()((CGFloat)(-kNormalGap))
            make.right.equalTo()(titleLabel.mas_right)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var isFistTimeToUpdateImage = true
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if cellData != nil {
            titleLabel.text = cellData?.title
            descLabel.text = cellData?.desc
            imgView.image = cellData?.image
            
            if imgView.image != nil && isFistTimeToUpdateImage{
                //updateConstraints only once
                updateImgViewConstraints()
                
                isFistTimeToUpdateImage = false
            }
        }
    }
    
    func updateImgViewConstraints() {
        imgView.mas_updateConstraints({ (make: MASConstraintMaker!) in
            make.height.equalTo()(imgView.image?.size.height)
            make.width.equalTo()(imgView.image?.size.width)
            
        })
        
        imgView.setNeedsUpdateConstraints()
        imgView.updateConstraints()
        
//        titleLabel.setNeedsUpdateConstraints()
//        descLabel.setNeedsUpdateConstraints()
        
//        updateConstraints()
    }
}
