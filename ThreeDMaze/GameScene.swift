//
//  GameScene.swift
//  ThreeDMaze
//
//  Created by yoshimura on 2015/02/03.
//  Copyright (c) 2015年 yoshimura. All rights reserved.
//

// これが正しいもの 20150210

import SpriteKit
import SceneKit


class GameScene: SKScene {
    
    
    
    var gameViewController:GameViewController! = nil
    
    var contentCreated = false
    var startTime:CFTimeInterval? = nil
    var lastTime:CFTimeInterval = 0
    
    var displayLink:CADisplayLink? = nil
    
    
    // MARK:イベント
    override func didMoveToView(view: SKView) {
        if (!contentCreated) {
            createContentScene()
            contentCreated = true
        }
    }
    
    // 呼ばれない
    //    override func update(currentTime: CFTimeInterval) {
    //        /* Called before each frame is rendered */
    //        if (currentTime-lastUpdateTime) > 0.2 {
    //            refreshTimeLabel(Int(currentTime))
    //            lastUpdateTime = currentTime
    //        }
    //    }
    
    func loop(link:CADisplayLink) {
        
        
        if startTime == nil {
            startTime = link.timestamp
        }
        
        println("loop \(link.timestamp)")
        
        if link.timestamp - lastTime > 0.01 {
            
            lastTime = link.timestamp
            
            refreshTimeLabel(Double(lastTime - startTime!))
            
            self.view!.setNeedsDisplay()
        }
    }
    
    func touchButton(sender: UIButton){
        println(sender)
        
        if sender.titleLabel?.text == nil {
            return
        }
        
        
        let _text = sender.titleLabel!.text!
        
        let _player = gameViewController.player
        
        if _text == "[EXIT]" {
            
            displayLink?.invalidate()
            displayLink = nil
            
            gameViewController.dismissViewControllerAnimated(false, completion: nil)
            return
        }
        
        if _text == "[RIGHT]" || _text == "[LEFT]" || _text == "[UP]" || _text == "[DOWN]" {
            if gameEnd {
                return
            }
            var _rotation:Rotation? = nil
            
            switch (_text) {
            case "[RIGHT]":
                _rotation = .RIGHT
            case "[LEFT]":
                _rotation = .LEFT
            case "[UP]":
                _rotation = .UP
            case "[DOWN]":
                _rotation = .DOWN
            default:break;
            }
            if _rotation != nil {
                gameViewController.rotateFront(_rotation!)
            } else {
                return
            }
        } else if _text == "[FRONT]" {
            if gameEnd {
                return
            }
            gameViewController.moveFront()
            
        } else {
            return
        }
        
        createMiniMap(gameViewController.map, max: gameViewController.max, z: _player.z)
        
    }
    
    
    
    // MARK: シーン作成
    func createContentScene() {
        
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: Selector("loop:"))
            displayLink!.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        }
        
        createLabel()
        
        createButton()
        
    }
    
    func createMiniMap(map:[Field], max:Int, z:Int) {
        
        self.enumerateChildNodesWithName("wall") {
            node, stop in
            node.removeFromParent()
        }
        for _y in 0..<max {
            for _x in 0..<max {
                let _field = map[_x + _y * max + z * max * max]
                if _field.wall == false {
                    continue
                }
                
                let _shape =  SKShapeNode(rect: CGRectMake(0, 0, 5, 5));
                _shape.strokeColor = SKColor.blackColor()
                _shape.fillColor=SKColor.blackColor()
                _shape.position = CGPointMake(CGFloat(_x*5+50), CGFloat(_y*5+50))
                _shape.name = "wall"
                _shape.zPosition = 1000
                self.addChild(_shape)
            }
        }
        
        var _x = gameViewController.player.x
        var _y = gameViewController.player.y
        
        let _redShape =  SKShapeNode(rect: CGRectMake(0, 0, 5, 5));
        _redShape.strokeColor = SKColor.blackColor()
        _redShape.fillColor=SKColor.redColor()
        _redShape.position = CGPointMake(CGFloat(_x*5+50), CGFloat(_y*5+50))
        _redShape.name = "wall"
        _redShape.zPosition = 1000
        self.addChild(_redShape)
        
    }
    
    func createLabel() {
        var _zPosition:CGFloat = 10000
        
        let _debugLabel = SKLabelNode(text: "")
        _debugLabel.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) - 100)
        _debugLabel.fontSize = 20
        
        refreshTimeLabel(10)
        
        refreshCoinLabel()
    }
    
    func createButton() {
        
        let _btn = CommonUtil.makeButton("[UP]", point:CGPointMake(CGRectGetMaxX(frame) * 0.5, 20))
        _btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        _btn.addTarget(self, action: "touchButton:", forControlEvents:.TouchUpInside)
        view!.addSubview(_btn)
        
        let _btn2 = CommonUtil.makeButton("[DOWN]", point:CGPointMake(CGRectGetMaxX(frame) * 0.5, CGRectGetMaxY(frame)-20))
        _btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        _btn2.addTarget(self, action: "touchButton:", forControlEvents:.TouchUpInside)
        view!.addSubview(_btn2)
        
        let _btn3 = CommonUtil.makeButton("[LEFT]", point:CGPointMake(40, CGRectGetMidY(frame)-10))
        _btn3.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        _btn3.addTarget(self, action: "touchButton:", forControlEvents:.TouchUpInside)
        view!.addSubview(_btn3)
        
        let _btn4 = CommonUtil.makeButton("[RIGHT]", point:CGPointMake(CGRectGetMaxX(frame) - 40, CGRectGetMidY(frame)-10))
        _btn4.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        _btn4.addTarget(self, action: "touchButton:", forControlEvents:.TouchUpInside)
        view!.addSubview(_btn4)
        
        let _btn5 = CommonUtil.makeButton("[FRONT]", point:CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame)-10))
        _btn5.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        _btn5.addTarget(self, action: "touchButton:", forControlEvents:.TouchUpInside)
        view!.addSubview(_btn5)
        
        let _btn6 = CommonUtil.makeButton("[EXIT]", point:CGPointMake(CGRectGetMaxX(frame) - 40, 20))
        _btn6.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        _btn6.addTarget(self, action: "touchButton:", forControlEvents:.TouchUpInside)
        view!.addSubview(_btn6)
        
    }
    
    
    func refreshCoinLabel() {
        var _coinLabel = childNodeWithName("coin") as SKLabelNode?
        if _coinLabel == nil {
            _coinLabel = SKLabelNode(text: "")
            _coinLabel!.position = CGPointMake(20, CGRectGetMaxY(frame) - 40)
            _coinLabel!.zPosition = 1000
            _coinLabel!.fontSize = 15
            _coinLabel!.fontName = CommonUtil.font(15).fontName
            _coinLabel!.fontColor = UIColor.redColor()
            _coinLabel!.horizontalAlignmentMode = .Left
            _coinLabel!.name = "coin"
            addChild(_coinLabel!)
        }
        
        var _total = 0
        for _field in gameViewController!.map {
            if _field.coin {
                _total += 1
            }
        }
        
        _coinLabel!.text = "COIN \(_total)"
        
        if _total == 0 {
            doGameEnd()
        }
    }
    
    func refreshTimeLabel(time:Double) {
        var _label = childNodeWithName("time") as SKLabelNode?
        if _label == nil {
            _label = SKLabelNode(text: "")
            _label!.position = CGPointMake(20, CGRectGetMaxY(frame) - 20)
            _label!.zPosition = 1000
            _label!.fontSize = 15
            _label!.fontName = CommonUtil.font(15).fontName
            _label!.fontColor = UIColor.redColor()
            _label!.horizontalAlignmentMode = .Left
            _label!.name = "time"
            addChild(_label!)
        }
        
        _label!.text = "TIME \(time)"
    }
    
    var gameEnd = false
    
    func doGameEnd() {
        
        if gameEnd {
            return
        }
        
        gameEnd = true
        
        var _label = SKLabelNode(text: "GAME CLEAR.\nOK!!")
        _label.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) * 0.75)
        _label.zPosition = 1000
        _label.fontSize = 15
        _label.fontName = CommonUtil.font(15).fontName
        _label.fontColor = UIColor.redColor()
        addChild(_label)
        
        gameViewController?.titleViewController?.setHighscore(lastTime)
    }
    
    
    /*
    func refreshScreenMiniMap(front:Direction, head:Direction, map:[Field], max:Int) {
    
    self.enumerateChildNodesWithName("minimap") {
    node, stop in
    node.removeFromParent()
    }
    
    for (var _y = -7;_y<=7;_y++)  {
    for (var _x = -7;_x<=7;_x++) {
    let _xyz = front.calcXyz(.C, x: 7, y: 7, z: 1, xx: _x, yy: _y, zz: 0)
    let _wall = Map.getField(_xyz[0], y:_xyz[1], z:_xyz[2], map:map, max:max)
    if _wall.wall == false {
    continue
    }
    let _shape =  SKShapeNode(rect: CGRectMake(0, 0, 5, 5));
    _shape.strokeColor = SKColor.blackColor()
    _shape.fillColor=SKColor.blackColor()
    _shape.position = CGPointMake(CGFloat(_x*5+300), CGFloat(_y*5+100))
    _shape.zPosition = 1000
    _shape.name="minimap"
    self.addChild(_shape)
    }
    }
    }
    */
}
