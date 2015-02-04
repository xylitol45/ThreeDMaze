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
        
        var _maps = createMap()
        
        self.backgroundColor = UIColor.whiteColor()
        // let _map:[Int]=[]
        var _x = 0, _y = 0
        let _max=15
        
        //for _z in 0..<6 {
            for _y in 0..<_max {
                for _x in 0..<_max {
                    
                    if _maps[_x+_y*_max+_max*_max*14] == 0 {
                        continue
                    }
                    
                    let _shape =  SKShapeNode(rect: CGRectMake(0, 0, 5, 5));
                    _shape.strokeColor = SKColor.blackColor()
                    _shape.fillColor=SKColor.blackColor()
                    _shape.position = CGPointMake(CGFloat(_x*5+100), CGFloat(_y*5+100*1))
                    _shape.name = "w" + "\(_x+_y*_max)"
                    self.addChild(_shape)
                }
            }
        //}
    }
    
    func createMap()->[Int] {
        
        var _nowall:[String]=[]
        //        _x = Int(arc4random_uniform(15)+1)
        //        _y = Int(arc4random_uniform(15)+1)
        //
        let _max = 15
        var _x = 1
        var _y = 1
        var _z = 1
        
        var _map:[Int]=[Int](count: _max*_max*_max, repeatedValue: 1)
        var _roads:[Int]=[]
        
        var _xx = 0
        var _yy = 0
        var _zz = 0
        
        let _vecs=[[1,0,0],[-1,0,0],[0,1,0],[0,-1,0],[0,0,1],[0,0,-1]]
        var _v=0
        var _key = ""
        
        
        //        _key = "w" + "\(_x+_y*_max)"
        //        if let _node = self.childNodeWithName(_key) {
        //            _node.hidden=true
        //        }
        //        _nowall.append(_key)
        
        _map[_x+_y*_max+_z*_max*_max]=0
        
        while(true) {
            while(true) {
                var _flg=false
                _v = Int(arc4random_uniform(UInt32(_vecs.count)))
                for i in 0..<_vecs.count {
                    
                    _xx = _vecs[(_v+i) % 6][0]
                    _yy = _vecs[(_v+i) % 6][1]
                    _zz = _vecs[(_v+i) % 6][2]
                    
                    if ((!(_xx < 0 && _x < 3)) &&  (!(_xx > 0 && _x > (_max-4)))
                        && (!(_yy < 0 && _y < 3)) && (!(_yy > 0 && _y > (_max-4)))
                        && (!(_zz < 0 && _z < 3)) && (!(_zz > 0 && _z > (_max-4)))
                        ) {
                            
                            println("hit _x:\(_x) _y:\(_y) _z:\(_z) _xx:\(_xx) _yy:\(_yy) _zz:\(_zz)")
                            
                            var _n = _map[(_x+_xx*2)+(_y+_yy*2)*_max+(_z+_zz*2)*_max*_max]
                            // var _key1 = "w\(_x+_xx*2+(_y+_yy*2)*_max)"
                            //                    var _key2 = "w\(_x+_xx*1+(_y+_yy*1)*16)"
                            if _n == 1 {
                                
                                //}!contains(_nowall, _key1) {
                                //                        _x += _xx
                                //                        _y += _yy
                                //                        _v = (_v + i) % 4
                                _flg=true
                                break
                            }
                    }
                    
                }
                
                
                if (_flg) {
                    
                    var _xyz = 0
                    
                    _x += _xx
                    _y += _yy
                    _z += _zz
                    
                    println("x:\(_x) y:\(_y) z:\(_z)")
                    //                    _key = "w" + "\(_x+_y*_max)"
                    //                    if let _node = self.childNodeWithName(_key) {
                    //                        _node.hidden=true
                    //                    }
                    
                    _xyz = _x + (_y * _max) + (_z * _max * _max)
                    _map[_xyz]=0
                    
                    // _nowall.append(_key)
                    _x += _xx
                    _y += _yy
                    _z += _zz
                    println("x:\(_x) y:\(_y) z:\(_z)")
                    _map[_x+(_y*_max)+(_z * _max*_max)]=0
                    
                    //                    _key = "w" + "\(_x+_y*_max)"
                    //                    if let _node = self.childNodeWithName(_key) {
                    //                        _node.hidden=true
                    //                    }
                    //                    _nowall.append(_key)
                    _roads += [_x+_y * _max + _z*_max*_max]
                    continue
                }
                
                break
            }
            
            if _roads.count == 0 {
                break
            }
            
            var _road = _roads[0]
            _roads.removeAtIndex(0)
            
            // x,y,z
            _x = _road % _max
            _y = ((_road - _x) % (_max*_max)) / _max
            _z = (_road - _x - _y * _max) / (_max*_max)
            
            println("road:\(_road) x:\(_x) y:\(_y) z:\(_z)")
            
        }
        
        return _map
    }
    
    func getWalls(x:Int,y:Int,z:Int,vec:Int,map:[Int])->[Int] {
        
        let _max = 15
        func _func(x1:Int,y1:Int,z1:Int)->Int {
            var _index = x1+y1*_max+z1*_max*_max
            if (map.count<=_index){
                return -1
            }
            return map[_index]
        }
        
        var _res:[Int]=[Int](count: 3*5, repeatedValue: 1)
    
        _res=[]
        
        // 北
        if vec==0 {
            for _yy in [0,1,2,3,4] {
                for _xx in [-1,0,1] {
                    if _func(x+_xx,y+_yy,z) == 0 {
                        _res += [0]
                    } else {
                        _res += [1]
                    }
                }
            }
            return []
        }
        
        // 回転による反転
        
        return []
    }
    
}
