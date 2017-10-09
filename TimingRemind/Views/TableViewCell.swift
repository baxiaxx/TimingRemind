//
//  TableViewCell.swift
//  TimingRemind
//
//  Created by Channing Kuo on 2017/10/9.
//  Copyright © 2017年 Channing Kuo. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    var labelName, labelValue: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.none
        accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        labelName = UILabel()
        labelName.textColor = .white
        labelName.textAlignment = .left
        labelName.backgroundColor = .clear
        contentView.addSubview(labelName)
        
        labelValue = UILabel()
        labelValue.textColor = .white
        labelValue.textAlignment = .right
        labelValue.backgroundColor = .clear
        labelValue.lineBreakMode = .byTruncatingTail
        contentView.addSubview(labelValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelName.frame = CGRect(x: 20, y: 0, width: 100, height: 50)
        labelValue.frame = CGRect(x: 120, y: 0, width: contentView.bounds.width - 120, height: 50)
    }
    
    public func updateUIString(name: String, value: String) {
        labelName.text = name
        labelValue.text = value
    }
}
