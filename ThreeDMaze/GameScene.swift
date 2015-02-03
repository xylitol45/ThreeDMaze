//
//  GameScene.swift
//  ThreeDMaze
//
//  Created by yoshimura on 2015/02/03.
//  Copyright (c) 2015年 yoshimura. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var contentCreated = false
    
    override func didMoveToView(view: SKView) {
        if (!contentCreated) {
            createContentScene()
            contentCreated = true
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    // MARK: シーン作成
    func createContentScene() {
        self.backgroundColor = UIColor.whiteColor()
        let _map:[Int]=[]
        var _x = 0, _y = 0
        let _max=15
        
        for _y in 0..<_max {
            for _x in 0..<_max {
                let _shape =  SKShapeNode(rect: CGRectMake(0, 0, 10, 10));
                _shape.strokeColor = SKColor.blackColor()
                _shape.fillColor=SKColor.grayColor()
                _shape.position = CGPointMake(CGFloat(_x*10 + 100), CGFloat(_y*10 + 100))
                _shape.name = "w" + "\(_x+_y*_max)"
                self.addChild(_shape)
            }
        }
        
        var _nowall:[String]=[]
        _x = Int(arc4random_uniform(15)+1)
        _y = Int(arc4random_uniform(15)+1)
        
        _x = 1
        _y = 1
        
        var _roads:[Int]=[]
        
        var _xx = 1
        var _yy = 0
        let _vecs=[[1,0],[-1,0],[0,1],[0,-1]]
        var _v=0
        var _key = ""
        
        
        _key = "w" + "\(_x+_y*_max)"
        if let _node = self.childNodeWithName(_key) {
            _node.hidden=true
        }
        _nowall.append(_key)
        while(true) {
            
            
            while(true) {
                
                
                var _flg=false
                _v = Int(arc4random_uniform(UInt32(_vecs.count)))
                for i in 0..<_vecs.count {
                    
                    _xx = _vecs[(_v+i) % 4][0]
                    _yy = _vecs[(_v+i) % 4][1]
                    
                    if ((!(_xx < 0 && _x < 3)) &&  (!(_xx > 0 && _x > (_max-4)))
                        && (!(_yy < 0 && _y < 3)) && (!(_yy > 0 && _y > (_max-4)))) {
                        
                        println("hit _x:\(_x) _y:\(_y) _xx:\(_xx) _yy:\(_yy)")
                        
                        
                        var _key1 = "w\(_x+_xx*2+(_y+_yy*2)*_max)"
                        //                    var _key2 = "w\(_x+_xx*1+(_y+_yy*1)*16)"
                        if !contains(_nowall, _key1) {
                            //                        _x += _xx
                            //                        _y += _yy
                            //                        _v = (_v + i) % 4
                            _flg=true
                            break
                        }
                    }
                    
                }
                
                
                if (_flg) {
                    _x += _xx
                    _y += _yy
                    println("x:\(_x) y:\(_y)")
                    _key = "w" + "\(_x+_y*_max)"
                    if let _node = self.childNodeWithName(_key) {
                        _node.hidden=true
                    }
                    _nowall.append(_key)
                    _x += _xx
                    _y += _yy
                    println("x:\(_x) y:\(_y)")
                    _key = "w" + "\(_x+_y*_max)"
                    if let _node = self.childNodeWithName(_key) {
                        _node.hidden=true
                    }
                    _nowall.append(_key)
                    _roads.append(_x+_y*_max)
                    continue
                }
                
                break
            }
            
            if _roads.count == 0 {
                break
            }
            
            var _road = _roads[0]
            _roads.removeAtIndex(0)
            
            _x = _road % _max
            _y = (_road - _x) / _max
        }
        
        
    }
}
