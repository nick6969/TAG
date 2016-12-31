//
//  editTagVC.swift
//  CHLtag
//
//  Created by UDT00016 on 8/11/16.
//  Copyright © 2016 UDT00016. All rights reserved.
//

import UIKit

struct TagModel{
    var name    : String  = ""      // 顯示名稱
    var choose  : Bool    = false   // 是否已選
}

protocol AddTagDelegate : NSObjectProtocol{
    // 增加標籤
    func addTag(model:TagModel)
    // 刪除最後一個標籤
    func deleteTag()
}


class TagEditVC: UIViewController  {
    fileprivate var menu = UIMenuController.shared
    
    var selectArray : [TagModel]!                   // 顯示用的資料
    var tagArray : [TagModel]!                      // 顯示選取用的資料
    fileprivate var deleteModel : TagModel!         // 長按刪除時用的變數
    fileprivate var colorArray : [UIColor]!         // 顯示用的顏色
    fileprivate var fontSize : CGFloat!             // 設定顯示文字大小
    
    // 可編輯的
    var editCollectionView = UICollectionView(frame: .zero, collectionViewLayout: LeftAlignedLayout())
    // 只能看的
    var showCollectionView = UICollectionView(frame: .zero, collectionViewLayout: LeftAlignedLayout())
    
    // 可編輯的抬頭
    var editHeader = UILabel()
    // 只能看的抬頭
    var showHeader = UILabel()
    
    func reload(){
        editCollectionView.reloadData()
        showCollectionView.reloadData()
        updateSelectedCollectionView()
    }
    
    /// 可以使用 Show in View 的方式添加在某一個 UIView 裡面
    ///
    /// - Parameters:
    ///   - rootView: 要加進去的 View
    ///   - fontSize: 文字的大小
    ///   - selectArray: 輸入的列表
    ///   - tagArray: 被選擇的列表
    ///   - colorArray: 兩個顏色 第一個是選取後的顏色 第二個是未選取的顏色
    func show(rootView:UIView,fontSize:CGFloat,selectArray:[TagModel],tagArray:[TagModel],colorArray:[UIColor]){
        
        self.fontSize = fontSize
        self.selectArray = selectArray
        
        self.tagArray = tagArray
        self.colorArray = colorArray
        
        view.frame = rootView.frame
        view.backgroundColor = UIColor.white
        rootView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        rootView.addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: rootView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: rootView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: rootView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: rootView, attribute: .bottom, multiplier: 1, constant: 0)
            ])

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        editHeader.text = "  標籤"
        showHeader.text = "  常用的標籤"
        editHeader.font = .systemFont(ofSize: 11)
        showHeader.font = .systemFont(ofSize: 11)
        editHeader.textColor = .black
        showHeader.textColor = .black
        
        setEditCV()
        setShowCV()
        setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSelectedCollectionView()
    }
    
    func setEditCV(){
        editCollectionView.backgroundColor = UIColor.white
        editCollectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        editCollectionView.register(TagTextFieldCell.self, forCellWithReuseIdentifier: TagTextFieldCell.identifier)
        editCollectionView.delegate = self
        editCollectionView.dataSource = self
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.TagLongPress(_:)))
        editCollectionView.addGestureRecognizer(longPress)
        
    }
    
    func setShowCV(){
        showCollectionView.backgroundColor = .white
        showCollectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        showCollectionView.delegate = self
        showCollectionView.dataSource = self
        
    }

    
    func setLayout(){
        self.view.addSubview(showCollectionView)
        self.view.addSubview(editCollectionView)
        self.view.addSubview(showHeader)
        self.view.addSubview(editHeader)
        editHeader.translatesAutoresizingMaskIntoConstraints = false
        showHeader.translatesAutoresizingMaskIntoConstraints = false

        showCollectionView.translatesAutoresizingMaskIntoConstraints = false
        editCollectionView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addConstraints([
            NSLayoutConstraint(item: editHeader, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: editHeader, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: editHeader, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: editHeader, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 16)
        ])
        
        self.view.addConstraints([
            NSLayoutConstraint(item: editCollectionView, attribute: .top, relatedBy: .equal, toItem: editHeader, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: editCollectionView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: editCollectionView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: editCollectionView, attribute: .height, relatedBy: .greaterThanOrEqual , toItem: nil, attribute: .height, multiplier: 1, constant: 25)
            ])
        
        self.view.addConstraints([
            NSLayoutConstraint(item: showHeader, attribute: .top, relatedBy: .equal, toItem: editCollectionView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: showHeader, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: showHeader, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: showHeader, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 16)
            ])
        
        
        
        self.view.addConstraints([
            NSLayoutConstraint(item: showCollectionView, attribute: .top, relatedBy: .equal, toItem: showHeader, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: showCollectionView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: showCollectionView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: showCollectionView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: showCollectionView, attribute: .height, relatedBy: .greaterThanOrEqual , toItem: nil, attribute: .height, multiplier: 1, constant: 25)
            ])

    }
}

extension TagEditVC : UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == editCollectionView{
            return 1
        }else{
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == editCollectionView{
            return selectArray.count + 1
        }else{
            return tagArray.count
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == editCollectionView{

            if indexPath.row < selectArray.count{
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as! TagCell
                cell.model = selectArray[indexPath.row]
                cell.colorArray = colorArray
                cell.textLabel.text = selectArray[indexPath.row].name
                cell.fontSize = fontSize
                cell.drawCell()
                return cell
                
            }else{
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagTextFieldCell.identifier, for: indexPath) as! TagTextFieldCell
                cell.delegate = self
                cell.fontSize = self.fontSize
                cell.drawCell()
                return cell
                
            }
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as! TagCell
            cell.model = tagArray[indexPath.row]
            cell.colorArray = colorArray
            cell.textLabel.text = tagArray[indexPath.row].name
            cell.fontSize = fontSize
            cell.drawCell()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == showCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as! TagCell
            if tagArray[indexPath.row].choose {
                tagArray[indexPath.row].choose = false
                cell.model = tagArray[indexPath.row]
                deleteTag(model: cell.model)
            }else{
                tagArray[indexPath.row].choose = true
                cell.model = tagArray[indexPath.row]
                addTag(model: cell.model)
            }
            showCollectionView.reloadData()
        }
    }
    
}


// CollcotionView 佈局
extension TagEditVC : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == showCollectionView{
            let size = (tagArray[indexPath.row].name as NSString).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: self.fontSize)])
            return CGSize( width: size.width + fontSize*1.5 , height: fontSize + 6)
        }else{
            if indexPath.row < selectArray.count{
                let size = (selectArray[indexPath.row].name as NSString).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: self.fontSize)])
                return CGSize( width: size.width + fontSize*1.5 , height: fontSize + 6)
            }
            return CGSize( width: fontSize * 5, height: fontSize + 6)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    
}


// 這是 TextField 回 Call
extension TagEditVC : AddTagDelegate{
    
    // 增加標籤
    func addTag(model:TagModel){
        var inoutModel = model
        // 確認是否重複 若重複更新位置
        for (i,select) in selectArray.enumerated(){
            if select.name == model.name{
                let from = IndexPath(item: i, section: 0)
                let to = IndexPath(item: selectArray.count - 1, section: 0)
                selectArray.move(from: i, to: selectArray.count - 1)
                
                editCollectionView.performBatchUpdates({
                    self.editCollectionView.moveItem(at: from, to: to)
                    }, completion: { (finished) in
                        if finished {
                            self.updateSelectedCollectionView()
                        }
                })
                return // 因為有重複的了
            }
        }
        // 確認是否選擇的隊列已經有了 有了就改為已選擇
        if tagArray.count != 0{
            loop: for i in 0...tagArray.count-1{
                if  tagArray[i].name == model.name{
                    inoutModel.choose = true
                    tagArray[i].choose = true
                    break loop
                }
            }
        }
        
        // 沒有重複 直接新增
        selectArray.append(inoutModel)
        editCollectionView.performBatchUpdates({
            self.editCollectionView.insertItems(at: [IndexPath(item: self.selectArray.count - 1, section: 0)])
            }) { (finished) in
                if finished {
                    self.updateSelectedCollectionView()
                }
            self.showCollectionView.reloadData()
        }
        
    }
    
    // 刪除最後一個標籤
    func deleteTag(){
        if selectArray.count > 0 {
            self.deleteTag(model: selectArray.last!)
        }
    }

}

// Action 區
extension TagEditVC{
    
    // 長按
    func TagLongPress(_ sender:UILongPressGestureRecognizer){
        if sender.state == .began{
            if let indexPath = editCollectionView.indexPathForItem(at: sender.location(in: editCollectionView)){
                if indexPath.row != selectArray.count{
                    let cell = editCollectionView.cellForItem(at: indexPath)! as! TagCell
                    deleteModel = cell.model
                    cell.becomeFirstResponder()
                    showMenuViewController(showInView: cell.textLabel)
                }
            }
        }
    }
    
    func showMenuViewController(showInView: UIView){
        let deleteItem = UIMenuItem(title: "刪除", action: #selector(self.deleteMenuAction(_:)))
        menu.menuItems = [deleteItem]
        menu.setTargetRect( showInView.bounds  , in: showInView.superview!)
        menu.setMenuVisible(true, animated: true)
    }
    
    func deleteMenuAction(_ sender:AnyObject){
        deleteTag(model: deleteModel)
    }
    
    // 刪除特定的 Tag
    func deleteTag(model: TagModel) {
        if tagArray.count != 0 {
            for i in 0...tagArray.count-1{
                var value = tagArray[i]
                if value.name == model.name{
                    value.choose = false
                    tagArray[i] = value
                    let index = IndexPath(item: i, section: 0)
                    let cell = showCollectionView.cellForItem(at: index) as! TagCell
                    cell.model = value
                    showCollectionView.performBatchUpdates({
                        self.showCollectionView.reloadItems(at: [index])
                        }, completion: nil)
                    break
                }
            }
        }
        var index = -1
        for (i,value) in selectArray.enumerated(){
            if value.name == model.name {
                index = i
                break
            }
        }
        selectArray.remove(at: index)
        editCollectionView.performBatchUpdates({
            self.editCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            }) { (finished) in
                self.updateSelectedCollectionView()
        }

        
    }
    
    // 更新 collectionView 畫面
    func updateSelectedCollectionView(){
        
        // 自適應高度
        super.updateViewConstraints()
        
        let editCV_ContentSizeHeight = editCollectionView.contentSize.height
        var height : CGFloat = 50.0
        if editCV_ContentSizeHeight != 0 && editCV_ContentSizeHeight < self.view.frame.height - 85{
            height = editCV_ContentSizeHeight
        }else if editCV_ContentSizeHeight == 0{
            height = 50.0
        }else{
            height = self.view.frame.height - 85
        }
        
        if self.view.constraints.count != 0{
            self.view.removeConstraints(self.view.constraints)
        }
        // 高度設定
        self.view.addConstraints([
            NSLayoutConstraint(item: editHeader, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: editHeader, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: editHeader, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: editHeader, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 16)
            ])
        
        self.view.addConstraints([
            NSLayoutConstraint(item: editCollectionView, attribute: .top, relatedBy: .equal, toItem: editHeader, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: editCollectionView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: editCollectionView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: editCollectionView, attribute: .height, relatedBy: .equal , toItem: nil, attribute: .height, multiplier: 1, constant: height)
            ])
        
        self.view.addConstraints([
            NSLayoutConstraint(item: showHeader, attribute: .top, relatedBy: .equal, toItem: editCollectionView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: showHeader, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: showHeader, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: showHeader, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 16)
            ])
        
        
        self.view.addConstraints([
            NSLayoutConstraint(item: showCollectionView, attribute: .top, relatedBy: .equal, toItem: showHeader, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: showCollectionView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: showCollectionView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: showCollectionView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: showCollectionView, attribute: .height, relatedBy: .greaterThanOrEqual , toItem: nil, attribute: .height, multiplier: 1, constant: 40)

            ])


        UIView.animate(withDuration: 0.1) {
            self.updateViewConstraints()
            self.view.layoutIfNeeded()
        }
        if selectArray.count != 0{
        editCollectionView.scrollToItem(at: IndexPath(item: selectArray.count-1 ,section:0), at: .top, animated: true)
        }

    }
    

}















