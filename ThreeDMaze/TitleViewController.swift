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
    
    var max = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _scene = SCNScene()
        
        let scnView = self.view as SCNView
        
        println(scnView.frame)
        
        scnView.allowsCameraControl = false
        scnView.showsStatistics = false
        
        scnView.backgroundColor = UIColor.blackColor()
        
        scnView.scene = _scene
        
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y:0, z: 5)
        _scene.rootNode.addChildNode(cameraNode)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: -10, y: 10, z: 50)
        _scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.grayColor()
        _scene.rootNode.addChildNode(ambientLightNode)
        
        // create box
        let _box = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0)
        let _material = SCNMaterial()
        _material.diffuse.contents = self.drawText(UIImage(named: "100x100_0.png")!)
        _box.firstMaterial = _material
        
        
        
        let _boxNode = SCNNode(geometry: _box)
        _boxNode.position = SCNVector3(x:-1.5, y:0, z:0)
        
        let _action = SCNAction.rotateByAngle(CGFloat(M_PI) * -2, aroundAxis: SCNVector3(x: 1, y: 1, z: 1), duration: 10)
        
        _boxNode.runAction(
            SCNAction.repeatActionForever(_action))
        
        _scene.rootNode.addChildNode(_boxNode)
        
        let _frame = self.view.frame
        
        let _btn = CommonUtil.makeButton("[5x5x5]", point:CGPointMake(CGRectGetMaxX(_frame) * 0.7, CGRectGetMidY(_frame) - 60))
        _btn.addTarget(self, action: "touchButton:", forControlEvents:.TouchUpInside)
        view.addSubview(_btn)
        
        let _btn2 = CommonUtil.makeButton("[7x7x7]", point:CGPointMake(CGRectGetMaxX(_frame) * 0.7, CGRectGetMidY(_frame)  ))
        _btn2.addTarget(self, action: "touchButton:", forControlEvents:.TouchUpInside)
        view.addSubview(_btn2)
        
        let _btn3 = CommonUtil.makeButton("[11x11x11]", point:CGPointMake(CGRectGetMaxX(_frame) * 0.7, CGRectGetMidY(_frame) + 60))
        _btn3.addTarget(self, action: "touchButton:", forControlEvents:.TouchUpInside)
        view.addSubview(_btn3)

        
        //        let _lbl = UILabel(frame: CGRectMake(CGRectGetMidX(_frame), CGRectGetMidY(_frame), 100, 20))
        //        _lbl.backgroundColor = UIColor.redColor()
        //        _lbl.textColor = UIColor.whiteColor()
        //        _lbl.text = "HELLO"
        //        self.view.addSubview(_lbl)
        
        //        let _gameScene = ControllerScene(size:CGSizeMake(667,375))
        //        _gameScene.gameViewController = self
        //        _gameScene.scaleMode = .AspectFit
        //        _gameScene.createMiniMap(map, max: _max, z:player.z)
        //        scnView.overlaySKScene = _gameScene
        
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "openGameViewController" {
            let _ctrl = segue.destinationViewController as GameViewController
            _ctrl.max = self.max
        }
    }
    
    
    func drawText(image :UIImage) ->UIImage
    {
        
        let font = UIFont.boldSystemFontOfSize(32)
        let imageRect = CGRectMake(0,0,image.size.width,image.size.height)
        
        UIGraphicsBeginImageContext(image.size);
        
        image.drawInRect(imageRect)
        
        let textRect  = CGRectMake(5, 5, image.size.width - 5, image.size.height - 5)
        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as NSMutableParagraphStyle
        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSParagraphStyleAttributeName: textStyle
        ]
        let text = "ThreeDMaze\n\n[5x5x5]"
        text.drawInRect(textRect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func createButton(title:String, point:CGPoint) {
        
        let _frame = self.view.frame
        
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
        button.frame = CGRectMake(CGRectGetMidX(_frame), CGRectGetMidY(_frame), 100, 25)
        
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
        button.addTarget(self, action: "touchButton:", forControlEvents:.TouchUpInside)
        
        //viewにボタンを追加する
        self.view.addSubview(button)
    }
    
    func touchButton(sender: UIButton){
        
        println(sender)
        let _text = sender.titleLabel?.text
        if _text == nil {
            return
        }
        switch(_text!) {
        case "[5x5x5]":max=5;
        case "[7x7x7]":max=7;
        case "[9x9x9]":max=9;
        case "[11x11x11]":max=11;
        default:return
        }
        
        performSegueWithIdentifier("openGameViewController", sender: self)
    }
}