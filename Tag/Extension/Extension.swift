//
//  Extension.swift
//  Tag
//
//  Created by nick on 2016/12/31.
//  Copyright © 2016年 nick. All rights reserved.
//

import UIKit

extension String{
    // 取得特定區間的文字 Ex: "abcde"[Range(1...2)]  return "bc"
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let max = characters.count < r.upperBound ? characters.count : r.upperBound
        let end = index(start, offsetBy: max - r.lowerBound)
        return self[Range(start ..< end)]
    }
}
extension Array{
    // 要宣告成 mutating 才能修改自己
    /// 將 array中的某個位置物件 移動到某個位置
    mutating func move(from:Int,to:Int){
        if from != to {
            let obj = self[from]
            self.remove(at: from)
            
            if to >= self.count {
                self.append(obj)
            }else{
                self.insert(obj, at: to)
            }
        }
    }
}

