//
//  GameScene.swift
//  ThreeDMaze
//
//  Created by yoshimura on 2015/02/03.
//  Copyright (c) 2015年 yoshimura. All rights reserved.
//

// これが正しいもの 20150210

import SpriteKit

class GameScene: SKScene {
    
    var contentCreated = false
    
    var player = (front:Direction.N, head:Direction.C, xyz:[3,5,1])
//    var playerFront = Direction.N
//    var playerHead = Direction.C
//    var playerXyz:[Int] = [3,5,1]
    var map:[Field] = []
    
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
            var _name:String = ((_node.name == nil) ? "" : _node.name!)
            
            if _name == "right" || _name == "left" || _name == "up" || _name == "down" {
                var _rotation:Rotation? = nil
                switch _name {
                case "right":_rotation = .RIGHT
                case "left":_rotation = .LEFT
                case "up":_rotation = .UP
                case "down":_rotation = .DOWN
                default:break;
                }
                if _rotation != nil {
                    let _res = player.front.rotate(player.head, rotation:_rotation!)
                    player.front = _res[0];
                    player.head = _res[1];
                }
            } else if _name == "rotate" {
                
                player.head = player.head.right(player.front.opposite())
                
            } else if _name == "debug" {
                var _xyz = player.front.xyz()
                _xyz = [player.xyz[0]+_xyz[0], player.xyz[1]+_xyz[1], player.xyz[2]+_xyz[2]]
                let _frontField = getField(_xyz[0], y: _xyz[1], z:_xyz[2] , map: map)
                if _frontField.wall == false {
                    player.xyz = [player.xyz[0]+_xyz[0], player.xyz[1]+_xyz[1], player.xyz[2]+_xyz[2]]
                    
                }
                
            }
        }
        
        
        let _fields = getFields(player.front, head: player.head, x: player.xyz[0], y: player.xyz[1], z: player.xyz[2], map: map)
        refreshScreenFields(_fields)
        
        refreshScreenMiniMap(player.front, head: player.head, map: map)
        
        if let _node:SKLabelNode = childNodeWithName("debug") as SKLabelNode! {
            _node.text = "FRONT:\(player.front.toString()) HEAD:\(player.head.toString())"
                + "(\(player.xyz[0]),\(player.xyz[1]),\(player.xyz[2]))"
        }
        
        if let _node:SKLabelNode = childNodeWithName("up") as SKLabelNode! {
            let _xyz = player.front.calcXyz(player.head, x: player.xyz[0], y: player.xyz[1], z: player.xyz[2], xx:0, yy:0, zz:1);
            _node.text = "UP(\(_xyz[0]),\(_xyz[1]),\(_xyz[2]))";
        }
        if let _node:SKLabelNode = childNodeWithName("down") as SKLabelNode! {
            let _xyz = player.front.calcXyz(player.head, x: player.xyz[0], y: player.xyz[1], z: player.xyz[2], xx:0, yy:0, zz:-1);
            _node.text = "DOWN(\(_xyz[0]),\(_xyz[1]),\(_xyz[2]))";
        }
        if let _node:SKLabelNode = childNodeWithName("right") as SKLabelNode! {
            let _xyz = player.front.calcXyz(player.head, x: player.xyz[0], y: player.xyz[1], z: player.xyz[2], xx:1, yy:0, zz:0)
            _node.text = "RIGHT(\(_xyz[0]),\(_xyz[1]),\(_xyz[2]))";
        }
        if let _node:SKLabelNode = childNodeWithName("left") as SKLabelNode! {
            let _xyz = player.front.calcXyz(player.head, x: player.xyz[0], y: player.xyz[1], z: player.xyz[2], xx:-1, yy:0, zz:0)
            _node.text = "LEFT(\(_xyz[0]),\(_xyz[1]),\(_xyz[2]))";
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
        var _x = player.xyz[0]
        var _y = player.xyz[1]
        var _z = player.xyz[2]
        
        let _fields = self.getFields(player.front, head: player.head, x: _x, y: _y, z: _z, map: map)
        refreshScreenFields(_fields)
        
        let _max=15
        for _z in [1] {
            for _y in 0..<_max {
                for _x in 0..<_max {
                    let _field = getField(_x, y:_y, z:_z, map:map)
                    if _field.wall == false {
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
        refreshScreenMiniMap(player.front, head:.C, map: map)
        
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
        _upLabel.fontSize = 15
        _upLabel.name = "up"
        addChild(_upLabel)
        
        let _downLabel = SKLabelNode(text: "DOWN")
        _downLabel.position = CGPointMake(CGRectGetMidX(frame), 20)
        _downLabel.zPosition = _zPosition
        _downLabel.fontSize = 15
        _downLabel.name = "down"
        addChild(_downLabel)
        
        let _leftLabel = SKLabelNode(text: "LEFT")
        _leftLabel.position = CGPointMake(40, CGRectGetMidY(frame))
        _leftLabel.zPosition = _zPosition
        _leftLabel.fontSize = 15
        _leftLabel.name = "left"
        addChild(_leftLabel)
        
        let _rightLabel = SKLabelNode(text: "RIGHT")
        _rightLabel.position = CGPointMake(CGRectGetMaxX(frame) - 40, CGRectGetMidY(frame))
        _rightLabel.zPosition = _zPosition
        _rightLabel.fontSize = 15
        _rightLabel.name = "right"
        addChild(_rightLabel)
        
        let _rotateLabel = SKLabelNode(text: "ROTATE")
        _rotateLabel.position = CGPointMake(CGRectGetMaxX(frame) * 0.75, CGRectGetMaxY(frame) * 0.25)
        _rotateLabel.zPosition = _zPosition
        _rotateLabel.fontSize = 15
        _rotateLabel.name = "rotate"
        addChild(_rotateLabel)
        
    }
    
    func getField(x:Int, y:Int, z:Int, map:[Field])->Field {
        let _max = 15
        
        if (x < 0 || x >= _max || y < 0 || y >= _max || z < 0 || z >= _max) {
            return Field()
        }
        
        let _n = x + y * _max + z * _max * _max;
        if ( _n < 0 || _n >= map.count) {
            return Field()
        }
        return map[_n]
    }
    
    func createMap()->[Field] {
        
        var _nowall:[String]=[]
        //
        let _max = 15
        var _x = 1
        var _y = 1
        var _z = 1
        
        var _map:[Field]=[Field](count: _max*_max*_max, repeatedValue: Field())
        var _roads:[Int]=[]
        
        var _xx = 0
        var _yy = 0
        var _zz = 0
        
        let _vecs=[[1,0,0],[-1,0,0],[0,1,0],[0,-1,0],[0,0,1],[0,0,-1]]
        var _v=0
        var _key = ""
        
        
        _map[_x+_y*_max+_z*_max*_max].wall = false
        
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
                            if _n.wall == true {
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
                    _map[_xyz].wall = false
                    
                    _x += _xx
                    _y += _yy
                    _z += _zz
                    println("x:\(_x) y:\(_y) z:\(_z)")
                    _map[_x+(_y*_max)+(_z * _max*_max)].wall = false
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
    
     
    func getDirection(xyz:[Int])->Direction {
        let _directions:[Direction] = [.N, .S, .E, .W, .C, .F]
        for _d in _directions {
            if _d.xyz() == xyz {
                return _d
            }
        }
        return .N
    }
    
    func calcXyz(front:Direction, head:Direction, x:Int, y:Int, z:Int, xx:Int, yy:Int, zz:Int)->[Int] {
        
        var _xyz:[Int] = [xx,yy,zz]
        
        switch front {
        case .N:
            switch head {
            case .C:_xyz = [xx,yy,zz] //
            case .F:_xyz=[(-1*xx), yy,(-1*zz)]
            case .E:_xyz=[zz,yy, (-1 * xx)]
            case .W:_xyz = [(-1 * zz),yy, xx]
            default:break;
            }
        case .S:
            switch head {
            case .C:_xyz=[(-1*xx),(-1*yy),zz] //
            case .F:_xyz=[xx, (-1*yy),(-1*zz)] //
            case .E:_xyz=[zz,(-1*yy),xx]
            case .W:_xyz=[(-1*zz), (-1*yy),(-1*xx)]
            default:break;
            }
        case .E:
            switch head {
            case .C:_xyz=[(yy),(-1*xx),zz] //
            case .F:_xyz=[yy, xx, (-1*zz)]
                
            case .N:_xyz=[yy, zz, xx]
            case .S:_xyz=[yy, (-1*zz), (-1 * xx)]
                
            default:break;
            }
        case .W:
            switch head {
            case .C:_xyz=[(-1*yy),(xx),zz] //
            case .F:_xyz=[(-1*yy),(-1*xx),(-1*zz)]
            case .N:_xyz=[(-1*yy),zz,(-1*xx)]
            case .S:_xyz=[(-1*yy),(-1*zz),(xx)]
            default:break;
            }
        case .C:
            switch head {
            case .N:_xyz=[ (-1*xx), zz, (yy)]
            case .S:_xyz=[ (xx), (-1*zz), (yy)] //
            case .E:_xyz=[ zz, (xx), yy] //
            case .W:_xyz=[ (-1*zz), (-1*xx), yy] //
            default:break;
            }
        case .F:
            switch head {
            case .N:_xyz=[ (xx), (-1*zz), (-1*yy)] //
            case .S:_xyz=[ (-1*xx),      (-1*zz), (-1*yy)]
            case .E:_xyz=[ (zz),  (-1*xx), (yy)]
            case .W:_xyz=[ (-1*zz), (xx), (-1*yy)]
            default:break;
            }
            break;
        default:break;
        }
        
        return [_xyz[0]+x, _xyz[1]+y, _xyz[2]+z]
    }
    
    func getFields(front:Direction, head:Direction, x:Int,y:Int,z:Int, map:[Field])->[Field] {
        
        let _max = 15
        func _func(x1:Int,y1:Int,z1:Int)->Field {
            if (x1 < 0 || x1 >= _max || y1 < 0 || y1 >= _max || z1 < 0 || z1 >= _max) {
                return Field()
            }
            var _index = x1+y1*_max+z1*_max*_max
            if (_index < 0 || map.count<=_index){
                return Field()
            }
            return map[_index]
        }
        
        var _res:[Field]=[]
        
        for _zz in [-1,0,1] {
            for _yy in [0,1,2,3,4] {
                for _xx in [-1,0,1] {
                    let _xyz = front.calcXyz(head, x: x, y: y, z: z, xx: _xx, yy:_yy, zz:_zz)
                    let _field = _func(_xyz[0], _xyz[1], _xyz[2])
                    _res += [_field]
                }
            }
        }
        
        
        return _res
    }
    
    func refreshScreenMiniMap(front:Direction, head:Direction, map:[Field]) {
        
        self.enumerateChildNodesWithName("minimap") {
            node, stop in
            node.removeFromParent()
        }
        
        for (var _y = -7;_y<=7;_y++)  {
            for (var _x = -7;_x<=7;_x++) {
                let _xyz = front.calcXyz(.C, x: 7, y: 7, z: 1, xx: _x, yy: _y, zz: 0)
                let _wall = getField(_xyz[0], y:_xyz[1], z:_xyz[2], map:map)
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
    
    func refreshScreenFields(map:[Field]) {
        
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
                    if (map[_x+_y*3+_z*3*5].wall == false) {
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
                    
                    self.addChild(_sprite)
                }
            }
        }
        
    }
}
