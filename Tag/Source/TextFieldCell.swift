//
//  TextFieldCell.swift
//  CHLtag
//
//  Created by UDT00016 on 8/16/16.
//  Copyright © 2016 UDT00016. All rights reserved.
//

import UIKit

class TagTextFieldCell: UICollectionViewCell {
    static let identifier = "TextFieldCell"
    var delegate : AddTagDelegate?
    var textField = UITextField()
    var fontSize : CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView(){
        textField.delegate = self
        textField.tintColor = UIColor.blue
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor.black
        textField.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
        self.contentView.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addConstraints([
            NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: textField, attribute: .right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: textField, attribute: .left, relatedBy: .equal, toItem: self.contentView, attribute: .left, multiplier: 1, constant: -3.5)
            ])
    }
    
    func drawCell(){
        textField.font = UIFont.systemFont(ofSize: fontSize)
        textField.placeholder = "輸入標籤"
    }
    
}
extension TagTextFieldCell : UITextFieldDelegate{
    
    func textFieldChanged(_ sender:UITextField){
        let toString = textField.text!
        let languge = UIApplication.shared.textInputMode!.primaryLanguage
        let max = 10
        
        if (languge == "zh-Hans" || languge == "zh-Hant"){

            if let selecteRange = textField.markedTextRange{
                let position = textField.position(from: selecteRange.start, offset: 0)
                if position != nil{
                    if toString.characters.count > max{
                        textField.text = toString[Range(0...max)]
                    }
                }
            }else{
                if toString.characters.count > max{
                    textField.text = toString[Range(0...max-1)]
                }
            }
        }else{
            if toString.characters.count > max{
                textField.text = toString[Range(0...max-1)]
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text!.trimmingCharacters(in: .whitespaces)
        if text.characters.count == 0{
            self.endEditing(true)
            return true
        }
        var model = TagModel()
        model.name = text
        textField.text = " "
        self.delegate!.addTag(model:model)
        
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text! == " "{
            textField.text = ""
        }else{
            var model = TagModel()
            model.name = textField.text!
            textField.text = ""
            self.delegate!.addTag(model: model)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text!.characters.count == 0 {
            textField.text = " "
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (range.length == 1 && range.length == 0){
            self.delegate!.deleteTag()
            return false
        }
        return true
    }
    
}
