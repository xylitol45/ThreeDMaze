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
    var playerXyz:[Int] = [3,3,1]
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
        
        let _touch: AnyObject = touches.anyObject()!
        let _location = _touch.locationInNode(self)
        if let _node:SKNode = self.nodeAtPoint(_location) as SKNode!{
            var _rotation:Rotation? = nil
            var _name:String = ((_node.name == nil) ? "" : _node.name!)
            switch _name {
            case "right":_rotation = .RIGHT
            case "left":_rotation = .LEFT
            case "up":_rotation = .UP
            case "down":_rotation = .DOWN
            case "debug":
                    let _xyz = playerFront.xyz()
                    playerXyz = [playerXyz[0]+_xyz[0], playerXyz[1]+_xyz[1], playerXyz[2]+_xyz[2]]
            default: break;
            }
            if _rotation != nil {
                let _res = changeFrontAndHead(playerFront, head:playerHead, rotation:_rotation!)
                playerFront = _res[0];
                playerHead = _res[1];
            }
        }
        
//        SKNode *node = [self nodeAtPoint:location];
//        if (YES) NSLog(@"Node name where touch began: %@", node.name);
//
//        switch playerHead {
//        case .C:
//            playerHead = .W
//        case .W:
//            playerHead = .F
//        case .F:
//            playerHead = .E
//        case .E:
//            playerHead = .C
//        default:
//            playerHead = .C
//        }
        
        let _walls = self.getWalls(playerFront, head: playerHead, x: playerXyz[0], y: playerXyz[1], z: playerXyz[2], map: map)
        refreshScreenWall(_walls)
        
        refreshScreenMiniMap(playerFront, head: playerHead, map: map)
        
        if let _node:SKLabelNode = childNodeWithName("debug") as SKLabelNode! {
            _node.text = "FRONT:" + playerFront.toString() +  " HEAD:" + playerHead.toString()
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
    }
    
    // MARK: シーン作成
    func createContentScene() {
        
        
        self.backgroundColor = UIColor.whiteColor()
        
        createLabel()
        
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
                    _shape.zPosition = 1000
                    self.addChild(_shape)
                }
            }
        }
        
        
        // TEST
        refreshScreenMiniMap(playerFront, head:.C, map: map)
    
    }
    
    func createLabel() {
        var _zPosition:CGFloat = 10000
        
        let _debugLabel = SKLabelNode(text: "")
        _debugLabel.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) - 100)
        _debugLabel.fontSize = 20
       
        _debugLabel.zPosition = _zPosition
        _debugLabel.name = "debug"
        self.addChild(_debugLabel)
        
        let _upLabel = SKLabelNode(text: "UP")
        _upLabel.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) - 20)
        _upLabel.zPosition = _zPosition
        _upLabel.fontSize = 10
        _upLabel.name = "up"
        addChild(_upLabel)

        let _downLabel = SKLabelNode(text: "DOWN")
        _downLabel.position = CGPointMake(CGRectGetMidX(frame), 20)
        _downLabel.zPosition = _zPosition
        _downLabel.fontSize = 10
        _downLabel.name = "down"
        addChild(_downLabel)

        let _leftLabel = SKLabelNode(text: "LEFT")
        _leftLabel.position = CGPointMake(40, CGRectGetMidY(frame))
        _leftLabel.zPosition = _zPosition
        _leftLabel.fontSize = 10
        _leftLabel.name = "left"
        addChild(_leftLabel)
        
        let _rightLabel = SKLabelNode(text: "RIGHT")
        _rightLabel.position = CGPointMake(CGRectGetMaxX(frame) - 40, CGRectGetMidY(frame))
        _rightLabel.zPosition = _zPosition
        _rightLabel.fontSize = 10
        _rightLabel.name = "right"
        addChild(_rightLabel)
        
        
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
        case S
        case E
        case W
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
        
        func opposite()->Direction {
            switch self {
            case .N: return .S;
            case .W: return .E;
            case .S: return .N;
            case .E: return .W;
            case .C: return .F;
            case .F: return .C;
            }
        }
        
        func toValue()->Int {
            let _xyz = self.xyz()
            return _xyz[0]+_xyz[1]+_xyz[2]
        }
        
        func xyz()->[Int] {
            switch self {
            case .N:
                return [0,1,0];
            case .S:
                return [0,-1,0];
            case .E:
                return [1,0,0];
            case .W:
                return [-1,0,0];
            case .C:
                return [0,0,1];
            case .F:
                return [0,0,-1];
            }
        }
    }

    func getDirection(xyz:[Int])->Direction {
        let _directions:[Direction] = [.N, .S, .E, .W, .C, .F]
        for _d in _directions {
            if _d.xyz() == xyz {
                return _d
            }
        }
        return .N
    }

    func getDirectionRight(front:Direction, head:Direction)->Direction {

        switch front {
        case .N:
            switch head {
            case .C: return .E;
            case .F: return .W;
            case .E: return .F;
            case .W: return .C;
            default:break;
            }
        case .S:
            switch head {
            case .C: return .W;
            case .F: return .E;
            case .E: return .C;
            case .W: return .F;
            default:break;
            }
        case .E:
            switch head {
            case .C: return .S;
            case .F: return .N;
            case .N: return .C;
            case .S: return .F;
            default:break;
            }
        case .W:
            switch head {
            case .C: return .N;
            case .F: return .S;
            case .N: return .F;
            case .S: return .C;
            default:break;
            }
        case .C:
            switch head {
            case .N: return .W;
            case .S: return .E;
            case .E: return .N;
            case .W: return .S;
            default:break;
            }
        case .F:
            switch head {
            case .N: return .E;
            case .S: return .W;
            case .E: return .S;
            case .W: return .N;
            default:break;
            }
        default:break;
            
        }
        
        return .C
    }

    enum Rotation {
        case RIGHT
        case LEFT
        case UP
        case DOWN

        func toInt()->Int {
            switch self {
            case .RIGHT: return 0;
            case .LEFT: return 1;
            case .UP: return 2;
            case .DOWN: return 3;
            }
        }
    }
    
    func changeFrontAndHead(front:Direction, head:Direction, rotation:Rotation)->[Direction] {
        
        var _res = [front,head]
        var _front = front
        var _head = head

        if rotation == .UP {
            let _opp = _front.opposite()
            _front = _head
            _head = _opp
        } else if rotation == .DOWN {
            let _opp = _head.opposite()
            _head = _front
            _front = _opp
        } else if rotation == .RIGHT {
            _front = getDirectionRight(_front, head: _head)
        } else if rotation == .LEFT {
            _front = getDirectionRight(_front, head: _head)
            _front = _front.opposite()
        }

        return [_front, _head]
    }
    
    func convertMap(front:Direction, head:Direction, max:Int, map:[Int])->[Int] {
        return []
    }
    
    func calcXyz(front:Direction, head:Direction, x:Int, y:Int, z:Int, xx:Int, yy:Int, zz:Int)->[Int] {
        
        var _xyz:[Int] = [xx,yy,zz]
        
        switch front {
        case .N:
            switch head {
            case .C:_xyz = [xx,yy,zz]
            case .F:_xyz=[(-1*xx), yy,(-1*zz)]
            case .E:_xyz=[zz,yy, (-1 * xx)]
            case .W:_xyz = [(-1 * zz),yy, xx]
            default:break;
            }
        case .S:
            switch head {
            case .C:_xyz=[(-1*xx),(-1*yy),zz]
            case .F:_xyz=[xx, (-1*yy),(-1*zz)]
            case .E:_xyz=[zz,(-1*yy),xx]
            case .W:_xyz=[(-1*zz), (-1*yy),(-1*xx)]
            default:break;
            }
        case .E:
            switch head {
            case .C:_xyz=[(-1*yy),xx,zz]
            case .F:_xyz=[yy, xx, (-1*zz)]
            case .N:_xyz=[zz, xx, yy]
            case .S:_xyz=[(-1*zz),xx, (-1 * yy)]
            default:break;
            }
        case .W:
            switch head {
            case .C:_xyz=[(yy),(-1*xx),zz]
            case .F:_xyz=[yy,(-1*xx),(-1*zz)]
            case .N:_xyz=[zz,(-1*xx),yy]
            case .S:_xyz=[(-1*zz),(-1*xx),(-1*yy)]
            default:break;
            }
        case .C:
            switch head {
            case .N:_xyz=[ (-1*xx), zz, yy]
            case .S:_xyz=[ xx, zz, (-1*yy)]
            case .E:_xyz=[ yy, zz, xx]
            case .W:_xyz=[ (-1*yy), zz, (-1*xx)]
            default:break;
            }
        case .F:
            switch head {
            case .N:_xyz=[ xx, (-1*zz), yy]
            case .S:_xyz=[ (-1*xx), (-1*zz), (-1*yy)]
            case .E:_xyz=[ yy, (-1*zz), (-1*xx)]
            case .W:_xyz=[ (-1*yy), (-1*zz), xx]
            default:break;
            }
        default:break;
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
                _shape.zPosition = 1000
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
                        var _rz = CGFloat((_z == 2) ? 1 : 0);
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
                            
                            if (_y > 0) {
                                _path.moveToPoint(CGPointMake(_maxX * _r1, _maxY * _ry1))
                                _path.addLineToPoint(CGPointMake(_maxX * (1 - _r1), _maxY * _ry1))
                                _path.addLineToPoint(CGPointMake(_maxX * (1 - _r1), _maxY * _rz))
                                _path.addLineToPoint(CGPointMake(_maxX * _r1, _maxY * _rz))
                                _path.closePath()
                            }
                            
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
