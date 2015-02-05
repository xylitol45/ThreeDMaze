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

        let _maxX = CGRectGetMaxX(frame)
        let _maxY = CGRectGetMaxY(frame)
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(_maxX,0))
        _path.addLineToPoint(CGPointMake(_maxX,_maxY))
        _path.addLineToPoint(CGPointMake(0,_maxY))
        _path.closePath()
        _path.addLineToPoint(CGPointMake(_maxX, _maxY))
        _path.moveToPoint(CGPointMake(_maxX, 0))
        _path.addLineToPoint(CGPointMake(0, _maxY))
        
        _path.moveToPoint(CGPointMake(_maxX * 0.1, _maxY * 0.1))
        _path.addLineToPoint(CGPointMake(_maxX * 0.1, _maxY * (1 - 0.1)))
        
        let _sprite = SKShapeNode(path: _path.CGPath)
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 4
        _sprite.userData!["ap"] = 25
        _sprite.userData!["score"] = 100
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 100

        addChild(_sprite)
        
        
        var _maps = createMap()
        
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
                //self.addChild(_shape)
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
    
    enum Direction {
        case N
        case W
        case S
        case E
        case C
        case F
        
        func xyz()->[Int] {
            switch self {
            case .N:
                return [0,1,0];
            case .W:
                return [1,0,0];
            case .S:
                return [0,-1,0];
            case .E:
                return [-1,0,0];
            case .C:
                return [0,0,1];
            case .F:
                return [0,0,-1];
            }
        }
    }
    
    func calcXyz(front:Direction, head:Direction, x:Int, y:Int, z:Int, xx:Int, yy:Int, zz:Int)->[Int] {
        
        switch front {
        case .N:
            switch head {
            case .C:
                return [x+xx,y+yy,z+zz]
            case .W:
                return [z+(-1*xx),y+yy,x+zz]
            case .F:
                return [x+(-1*xx), y+yy,z+(-1*zz)]
            case .E:
                return [z+xx,y+yy,x+(-1*zz)]
            default:
                return [x,y,z]
            }
        case .W:
            switch head {
            case .C:
                return [y+(-1*xx),x+yy,z+zz]
            case .S:
                return [z+(-1*xx),x+yy,y+zz]
            case .F:
                return [y+xx,x+yy,z+(-1*zz)]
            case .N:
                return [z+xx,x+yy,y+(-1*zz)]
            default:
                return [x,y,z]
            }
        case .S:
            switch head {
            case .C:
                return [x+(-1*xx),y+(-1*yy),z+zz]
            case .W:
                return [z+xx,y+(-1*yy),x+zz]
            case .F:
                return [x+xx, y+(-1*yy),z+(-1*zz)]
            case .E:
                return [z+(-1*xx), y+(-1*yy),x+(-1*zz)]
            default:
                return [x,y,z]
            }
        case .E:
            switch head {
            case .C:
                return [y+xx,x+(-1*yy),z+zz]
            case .S:
                return [z+xx,x+(-1*yy),y+(-1*zz)]
            case .F:
                return [y+(-1*xx),x+(-1*yy),z+(-1*zz)]
            case .N:
                return [z+(-1*xx),x+(-1*yy),y+zz]
            default:
                return [x,y,z]
            }
        case .C:
            switch head {
            case .N:
                return [x+(-1*xx),z+yy,y+zz]
            case .W:
                return [y+xx,z+yy,x+zz]
            case .S:
                return [x+xx,z+yy,y+(-1*zz)]
            case .E:
                return [y+(-1*xx),z+yy,x+(-1*zz)]
            default:
                return [x,y,z]
            }
        case .F:
            switch head {
            case .N:
                return [x+xx,z+(-1*yy),y+zz]
            case .W:
                return [y+(-1*xx),z+(-1*yy),x+zz]
            case .S:
                return [x+(-1*xx),z+(-1*yy),y+(-1*zz)]
            case .E:
                return [y+xx,z+(-1*yy),x+(-1*zz)]
            default:
                return [x,y,z]
            }
        default:
            return [x,y,z]
        }
                
    }
    
    func getWalls(front:Direction, head:Direction, x:Int,y:Int,z:Int, map:[Int])->[Int] {
        
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
        
        for _zz in [-1,0,1] {
            for _yy in [0,1,2,3,4] {
                for _xx in [-1,0,1] {
                    let _xyz = self.calcXyz(front, head: head, x: x, y: y, z: z, xx: _xx, yy:_yy, zz:_zz)
                    
                    if _func(_xyz[0], _xyz[1], _xyz[2]) == 0 {
                        _res += [0]
                    } else {
                        _res += [1]
                    }
                }
            }
        }
        
        
        return _res
    }
    
}
