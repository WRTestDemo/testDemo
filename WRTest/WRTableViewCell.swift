//
//  WRTableViewCell.swift
//  WRTest
//
//  Created by 王刃 on 2018/4/17.
//  Copyright © 2018年 W.R. All rights reserved.
//

import UIKit
import Masonry

struct CellData {
    var title: String?
    var desc: String?
    var imageUrl: String?
}

class WRTableViewCell: UITableViewCell {
    
    var cellData: CellData?
    
    lazy var imgView: UIImageView = {
        var imgV = UIImageView(image: nil)
        imgV.backgroundColor = .green
        self.addSubview(imgV)
        
        return imgV
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .red
        self.addSubview(label)
        
        return label
    }()
    
    lazy var descLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 3
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = .yellow
        self.addSubview(label)
        
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imgView.mas_makeConstraints { (_ make: MASConstraintMaker!) in
            make.top.equalTo()(self)?.offset()(10)
            make.left.equalTo()(self)?.offset()(10)
            make.bottom.equalTo()(self)?.offset()(-10)
        }
        titleLabel.mas_makeConstraints { (_ make: MASConstraintMaker!) in
            make.top.equalTo()(imgView.mas_top)
            make.left.equalTo()(imgView.mas_right)?.offset()(8)
            make.right.equalTo()(self)?.offset()(-10)
        }
        descLabel.mas_makeConstraints { (_ make: MASConstraintMaker!) in
            make.top.equalTo()(titleLabel.mas_bottom)?.offset()(5)
            make.left.equalTo()(titleLabel.mas_left)
            make.bottom.equalTo()(self)?.offset()(-10)
            make.right.equalTo()(titleLabel.mas_right)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if cellData != nil {
            titleLabel.text = cellData?.title
            descLabel.text = cellData?.desc
            
            titleLabel.sizeToFit()
            descLabel.sizeToFit()
        }
    }
}
