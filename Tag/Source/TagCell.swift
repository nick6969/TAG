//
//  TagCell.swift
//  CHLtag
//
//  Created by UDT00016 on 8/16/16.
//  Copyright © 2016 UDT00016. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    static let identifier = "TagCell"
    
    var model : TagModel!
    var textLabel : UILabel = UILabel()
    var fontSize : CGFloat!
    var colorArray : Array<UIColor>!    // 顯示用的顏色
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.contentView.addSubview(textLabel)
        textLabel.textAlignment = .center
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addConstraints([
            NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: textLabel, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: textLabel, attribute: .width, relatedBy: .equal, toItem: self.contentView, attribute: .width, multiplier: 1, constant: 0)
            ])
        
    }
    
    func drawCell(){
        textLabel.layer.cornerRadius = (fontSize + 4) / 2
        textLabel.layer.masksToBounds = true
        textLabel.font = UIFont.systemFont(ofSize: fontSize)
        if !model.choose{
            textLabel.textColor = colorArray[1]
            textLabel.layer.borderColor = colorArray[1].cgColor
            textLabel.backgroundColor = UIColor.white
        }else{
            textLabel.textColor = UIColor.white
            textLabel.layer.borderColor = colorArray[0].cgColor
            textLabel.backgroundColor = colorArray[0]
        }
        textLabel.layer.borderWidth = 0.5
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
}
