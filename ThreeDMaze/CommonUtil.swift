//
//  ButtonUtil.swift
//  ThreeDMaze
//
//  Created by yoshimura on 2015/02/28.
//  Copyright (c) 2015年 yoshimura. All rights reserved.
//

import Foundation
import UIKit

class CommonUtil {
    
    class func font(size:CGFloat)->UIFont {
//        return "HelveticaNeue-UltraLight"
        return UIFont.boldSystemFontOfSize(size)
    }
    
    class func makeButton(title:String, point:CGPoint)->UIButton {
        
//        let _frame = self.view.frame
        
        let button = UIButton()
        
        //表示されるテキスト
        button.setTitle(title, forState: .Normal)
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        
        
        //テキストの色
        button.setTitleColor(UIColor.redColor(), forState: .Normal)
        
        //タップした状態のテキスト
        //        button.setTitle("Tapped!", forState: .Highlighted)
        
        //タップした状態の色
        button.setTitleColor(UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 1.0), forState: .Highlighted)
        
        //サイズ
        button.frame = CGRectMake(0, 0, 100, 25)
        
        //タグ番号
        //button.tag = 1
        
        //配置場所
        button.layer.position = point
        
        //背景色
        //        button.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        
        //角丸
        //        button.layer.cornerRadius = 5
        
        //ボーダー幅
        //        button.layer.borderWidth = 1
        
        //ボタンをタップした時に実行するメソッドを指定
//        button.addTarget(self, action: "touchButton:", forControlEvents:.TouchUpInside)
//        
//        //viewにボタンを追加する
//        self.view.addSubview(button)
        
        button.titleLabel?.font = CommonUtil.font(20)
        
        return button
    }
}