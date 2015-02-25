//
//  TitleViewController.swift
//  ThreeDMaze
//
//  Created by yoshimura on 2015/02/25.
//  Copyright (c) 2015年 yoshimura. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class TitleViewController: UIViewController  {
    
    var ctrl:GameViewController? = nil
    
//    @IBOutlet weak var test3View: SCNView!
//    @IBOutlet weak var test2View: SCNView!
//    @IBOutlet weak var testView: SCNView!
 
//    @IBOutlet weak var t4v: UIView!
    
    @IBOutlet weak var t4v: SCNView!
//    @IBOutlet weak var t3v: SCNView!
    @IBAction func touchButton(sender: AnyObject) {
        
        // 読み込むストーリーボードファイル名（拡張子は含めない）と、ストーリーボードおよび関連リソースを含むバンドルを指定する
        // バンドルにnilを指定した場合は現在のアプリケーションのメインバンドルが対象となる
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"" bundle:nil];
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        // ストーリーボードでコントローラーのStoryboard IDとして設定した値を引数にインスタンスを生成する
//        FooController *fooController = [storyboard instantiateViewControllerWithIdentifier:@"fooController"];
        
        ctrl = storyboard.instantiateViewControllerWithIdentifier("3d") as GameViewController?
        
        
//        ctrl = GameViewController()
    
//        t3v = ctrl!.view as SCNView
        // t4v = ctrl!.view as SCNView
        
            println(sender)
    }
}