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
    var playerFront = Direction.N
    var playerHead = Direction.C
    var map:[Int] = []
    
    override func didMoveToView(view: SKView) {
        if (!contentCreated) {
            createContentScene()
            contentCreated = true
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        if touches.count != 1 {
            return
        }
        
        switch playerHead {
        case .C:
            playerHead = .W
        case .W:
            playerHead = .F
        case .F:
            playerHead = .E
        case .E:
            playerHead = .C
        default:
            playerHead = .C
        }
        
        let _walls = self.getWalls(playerFront, head: playerHead, x: 3, y: 3, z: 1, map: map)
        refreshScreenWall(_walls)
        
        refreshScreenMiniMap(playerFront, head: playerHead, map: map)
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        var _node = self.childNodeWithName("debug") as SKLabelNode?
        if _node == nil {
            _node = SKLabelNode(text: "")
           _node!.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) - 100)
            _node!.zPosition = 100000
            _node!.name = "debug"
            self.addChild(_node!)
        }
        _node!.text = "FRONT:" + playerFront.toString() +  " HEAD:" + playerHead.toString()
        
    }
    
    // MARK: シーン作成
    func createContentScene() {
        
        
        self.backgroundColor = UIColor.whiteColor()
        
        let _maxX = CGRectGetMaxX(frame)
        let _maxY = CGRectGetMaxY(frame)
        
        
        map = createMap()
        
        // let _map:[Int]=[]
        var _x = 3, _y = 3, _z = 1
        
        let _walls = self.getWalls(playerFront, head: .C, x: _x, y: _y, z: _z, map: map)
        refreshScreenWall(_walls)
        
        let _max=15
        for _z in [1,2,3] {
            for _y in 0..<_max {
                for _x in 0..<_max {
                    let _wall = getWall(_x, y:_y, z:_z, map:map)
                    if _wall < 1 {
                        continue
                    }

                    let _shape =  SKShapeNode(rect: CGRectMake(0, 0, 5, 5));
                    _shape.strokeColor = SKColor.blackColor()
                    _shape.fillColor=SKColor.blackColor()
                    _shape.position = CGPointMake(CGFloat(_x*5+100), CGFloat(_y*5+100*_z))
                    _shape.name = "w" + "\(_x+_y*_max)"
                    _shape.zPosition = 10000
                    self.addChild(_shape)
                }
            }
        }
        
        
        // TEST
        refreshScreenMiniMap(playerFront, head:.C, map: map)
    
    }
    
    func getWall(x:Int, y:Int, z:Int, map:[Int])->Int {
        let _max = 15
        let _n = x + y * _max + z * _max * _max;
        if ( _n < 0 || _n >= map.count) {
            return 0
        }
        return map[_n]
    }
    
    func createMap()->[Int] {
        
        var _nowall:[String]=[]
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
                    
                    _xyz = _x + (_y * _max) + (_z * _max * _max)
                    _map[_xyz]=0
                    
                    // _nowall.append(_key)
                    _x += _xx
                    _y += _yy
                    _z += _zz
                    println("x:\(_x) y:\(_y) z:\(_z)")
                    _map[_x+(_y*_max)+(_z * _max*_max)]=0
                    
                    
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
        
        func toString()->String {
            switch self {
            case .N:
                return "N";
            case .W:
                return "W";
            case .S:
                return "S";
            case .E:
                return "E";
            case .C:
                return "C";
            case .F:
                return "F";
            }
        
        }
        
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
    
    func convertMap(front:Direction, head:Direction, max:Int, map:[Int])->[Int] {
        return []
    }
    
    func calcXyz(front:Direction, head:Direction, x:Int, y:Int, z:Int, xx:Int, yy:Int, zz:Int)->[Int] {
        
        var _xyz:[Int] = [xx,yy,zz]
        
        switch front {
        case .N:
            switch head {
            case .C:
                _xyz = [xx,yy,zz]
            case .W:
                _xyz = [zz,yy,(-1 * xx)]
            case .F:
                _xyz=[(-1*xx), yy,(-1*zz)]
            case .E:
                _xyz=[(-1 * zz),yy,xx]
            default:
                _xyz=[xx,yy,zz]
            }
        case .W:
            switch head {
            case .C:
                _xyz=[yy,(-1*xx),zz]
                

            case .S:
                _xyz=[(-1*xx),yy,zz]
            case .F:
                _xyz=[xx,yy,(-1*zz)]
            case .N:
                _xyz=[xx,yy,(-1*zz)]
            default:
                _xyz=[xx,yy,zz]
            }
        case .S:
            switch head {
            case .C:
                _xyz=[(-1*xx),(-1*yy),zz]
            case .W:
                _xyz=[xx,(-1*yy),zz]
            case .F:
                _xyz=[xx, (-1*yy),(-1*zz)]
            case .E:
                _xyz=[(-1*xx), (-1*yy),(-1*zz)]
            default:
                _xyz=[xx,yy,zz]
            }
        case .E:
            switch head {
            case .C:
                _xyz=[(-1*yy),xx,zz]

            case .S:
                _xyz=[xx, (-1*yy), (-1*zz)]
            case .F:
                _xyz=[ (-1*xx), (-1*yy), (-1*zz)]
            case .N:
                _xyz=[ (-1*xx), (-1*yy), zz]
            default:
                _xyz=[xx,yy,zz]
            }
        case .C:
            switch head {
            case .N:
                _xyz=[ (-1*xx), yy, zz]
            case .W:
                _xyz=[ xx, yy, zz]
            case .S:
                _xyz=[ xx, yy, (-1*zz)]
            case .E:
                _xyz=[ (-1*xx), yy, (-1*zz)]
            default:
                _xyz=[xx,yy,zz]
            }
        case .F:
            switch head {
            case .N:
                _xyz=[ xx, (-1*yy), zz]
            case .W:
                _xyz=[ (-1*xx), (-1*yy), zz]
            case .S:
                _xyz=[ (-1*xx), (-1*yy), (-1*zz)]
            case .E:
                _xyz=[ xx, (-1*yy), (-1*zz)]
            default:
                _xyz=[xx,yy,zz]
            }
        default:
            _xyz=[xx,yy,zz]
        }
        
        return [x+_xyz[0], y+_xyz[1], z+_xyz[2]]
        
    }
    
    func getWalls(front:Direction, head:Direction, x:Int,y:Int,z:Int, map:[Int])->[Int] {
        
        let _max = 15
        func _func(x1:Int,y1:Int,z1:Int)->Int {
            var _index = x1+y1*_max+z1*_max*_max
            if (_index < 0 || map.count<=_index){
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

    func refreshScreenMiniMap(front:Direction, head:Direction, map:[Int]) {
        
        self.enumerateChildNodesWithName("minimap") {
            node, stop in
            node.removeFromParent()
        }

        for (var _y = -7;_y<=7;_y++)  {
            for (var _x = -7;_x<=7;_x++) {
                let _xyz = calcXyz(front, head: .C, x: 7, y: 7, z: 1, xx: _x, yy: _y, zz: 0)
                let _wall = getWall(_xyz[0], y:_xyz[1], z:_xyz[2], map:map)
                if _wall < 1 {
                    continue
                }
                let _shape =  SKShapeNode(rect: CGRectMake(0, 0, 5, 5));
                _shape.strokeColor = SKColor.blackColor()
                _shape.fillColor=SKColor.blackColor()
                _shape.position = CGPointMake(CGFloat(_x*5+300), CGFloat(_y*5+100))
                _shape.zPosition = 10000
                _shape.name="minimap"
                self.addChild(_shape)
            }
        }
    }

    func refreshScreenWall(map:[Int]) {
        
        
        self.enumerateChildNodesWithName("wall") {
            node, stop in
            node.removeFromParent()
        }
        
        let _maxX = CGRectGetMaxX(frame)
        let _maxY = CGRectGetMaxY(frame)
        let _ratios:[CGFloat] = [0.0, 0.2,0.35,0.425,0.475,0.5]
        
        for _y in [4,3,2,1,0] {
            var _r1 = _ratios[_y]
            var _r2 = _ratios[_y+1]
            var _r3:CGFloat = -1
            if _y > 0 {
                _r3 = _ratios[_y-1]
            }
            for _z in [0,2,1]  {
                for _x in [0,2,1] {
                    if (map[_x+_y*3+_z*3*5] == 0) {
                        continue;
                    }
                    
                    let _path = UIBezierPath()
                    
                    // 天地
                    if _z == 0 || _z == 2 {
                        var _ry1 = _r1
                        var _ry2 = _r2
                        
                        // 天
                        if (_z == 2) {
                            _ry1 = 1 - _ry1
                            _ry2 = 1 - _ry2
                        }
                        // 中央
                        if (_x == 1) {
                            _path.moveToPoint(CGPointMake(_maxX * _r1, _maxY * _ry1))
                            _path.addLineToPoint(CGPointMake(_maxX * (1 - _r1), _maxY * _ry1))
                            _path.addLineToPoint(CGPointMake(_maxX * (1 - _r2), _maxY * _ry2))
                            _path.addLineToPoint(CGPointMake(_maxX * _r2, _maxY * _ry2))
                            _path.closePath()
                        } else if (_x == 0){
                            // 左
                            _path.moveToPoint(CGPointMake(0, _maxY * _ry1))
                            _path.addLineToPoint(CGPointMake(_maxX * _r1, _maxY * _ry1))
                            _path.addLineToPoint(CGPointMake(_maxX * _r2, _maxY * _ry2))
                            _path.addLineToPoint(CGPointMake(0, _maxY * _ry2))
                            _path.closePath()
                        } else if (_x == 2) {
                            // 右
                            _path.moveToPoint(CGPointMake(_maxX, _maxY * _ry1))
                            _path.addLineToPoint(CGPointMake(_maxX * (1 - _r1), _maxY * _ry1))
                            _path.addLineToPoint(CGPointMake(_maxX * (1 - _r2), _maxY * _ry2))
                            _path.addLineToPoint(CGPointMake(_maxX, _maxY * _ry2))
                            _path.closePath()
                        }
                    } else
                    if _z == 1 {

                    
                    
                    if (_x == 0 || _x == 2) {
                        
                        if (_x == 2) {
                            _r1 = 1 - _r1
                            _r2 = 1 - _r2
                            if _r3 >= 0 {
                                _r3 = 1 - _r3
                            }
                        }
                        
                        _path.moveToPoint(CGPointMake(_maxX * _r1, _maxY * _r1))
                        _path.addLineToPoint(CGPointMake(_maxX * _r1, _maxY * (1 - _r1)))
                        _path.addLineToPoint(CGPointMake(_maxX * _r2, _maxY * (1 - _r2)))
                        _path.addLineToPoint(CGPointMake(_maxX * _r2, _maxY * _r2))
                        _path.closePath()
                        
                        
                        if _r3 >= 0 {
                            _path.moveToPoint(CGPointMake(_maxX * _r3, _maxY * _r1))
                            _path.addLineToPoint(CGPointMake(_maxX * _r3, _maxY * (1 - _r1)))
                            _path.addLineToPoint(CGPointMake(_maxX * _r1, _maxY * (1 - _r1)))
                            _path.addLineToPoint(CGPointMake(_maxX * _r1, _maxY * _r1))
                            _path.closePath()
                            
                        }
                    } else {
                        _path.moveToPoint(CGPointMake(_maxX * _r1, _maxY * _r1))
                        _path.addLineToPoint(CGPointMake(_maxX * _r1, _maxY * (1-_r1)))
                        _path.addLineToPoint(CGPointMake(_maxX * (1-_r1), _maxY * (1-_r1)))
                        _path.addLineToPoint(CGPointMake(_maxX * (1-_r1), _maxY * _r1))
                        _path.closePath()
                    }
                    } else {
                        continue
                    }
                    
                    let _sprite = SKShapeNode(path: _path.CGPath)
                    _sprite.userData = [:]
                    _sprite.userData!["hp"] = 4
                    _sprite.userData!["ap"] = 25
                    _sprite.userData!["score"] = 100
                    _sprite.fillColor = SKColor.redColor()
                    _sprite.strokeColor = SKColor.blackColor()
                    _sprite.name = "wall"
                    _sprite.zPosition = 100
                    
                    // _sprite.zRotation = CGFloat(M_PI * 2)
                    
                    
                    self.addChild(_sprite)
                }
            }
        }
        
    }
}
