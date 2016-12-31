//
//  ViewController.swift
//  Tag
//
//  Created by nick on 2016/12/31.
//  Copyright © 2016年 nick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tagView: UIView!

    var TagEdit : TagEditVC!
    
    let TestTagArray = [
        TagModel(name:"測試001",choose:false),
        TagModel(name:"測試002",choose:false),
        TagModel(name:"測試003",choose:false),
        TagModel(name:"測試004",choose:false),
        ]
    

    override func viewDidLoad() {
        super.viewDidLoad()

    
        TagEdit = TagEditVC()
        TagEdit.show(rootView: tagView, fontSize: 12, selectArray: [], tagArray: TestTagArray, colorArray: [.blue,.red])
        
    }

}

