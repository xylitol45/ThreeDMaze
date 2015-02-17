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

//protocol GameSceneDelegate{
//    func getCameraNode()->SCNNode
//    func setCameraRotateAndPosition(front:Direction, head:Direction, x:Int, y:Int, z:Int)
//}

class GameScene: SKScene {
    
//    var gameSceneDelegate:GameSceneDelegate! = nil
    
    var game2ViewController:Game2ViewController! = nil
    
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
        
        // return
        
        let _player = game2ViewController.player
        
        let _touch: AnyObject = touches.anyObject()!
        let _location = _touch.locationInNode(self)
        if let _node:SKNode = self.nodeAtPoint(_location) as SKNode!{
            var _name:String = ((_node.name == nil) ? "" : _node.name!)
  
//            if _name == "rotatex" || _name == "rotatey" || _name == "rotatez" {
//                
//                let _labelNode = _node as SKLabelNode
//                
//                switch _name {
//                case "rotatex":
//                    game2ViewController.rotateX = (game2ViewController.rotateX + 1) % 4
//                    _labelNode.text = "ROTATEX\(game2ViewController.rotateX)"
//                case "rotatey":
//                    game2ViewController.rotateY = (game2ViewController.rotateY + 1) % 4
//                    _labelNode.text = "ROTATEY\(game2ViewController.rotateY)"
//                case "rotatez":
//                    game2ViewController.rotateZ = (game2ViewController.rotateZ + 1) % 4
//                    _labelNode.text = "ROTATEZ\(game2ViewController.rotateZ)"
//                default:break;
//                }
//                
//                let _n = Float(M_PI_2)
//                
//                game2ViewController.cameraNode!.eulerAngles =
//                SCNVector3(x: game2ViewController.rotateX * _n, y:game2ViewController.rotateY * _n, z:game2ViewController.rotateZ * _n)
//                return
//            }
            
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
                    game2ViewController.rotateFront(_rotation!)
                } else {
                    return
                }
//            } else if _name == "rotate" {
//                
//                _player.head = _player.head.right(_player.front.opposite())
//                
            } else if _name == "debug" {
                
                game2ViewController.moveFront()
                
                
            } else {
                return
            }
        } else {
            return
        }
        
        
        if let _node:SKLabelNode = childNodeWithName("debug") as SKLabelNode! {
            _node.text = "FRONT:\(_player.front.toString()) HEAD:\(_player.head.toString())"
                + "(\(_player.x),\(_player.y),\(_player.z))"
        }
        
        if let _node:SKLabelNode = childNodeWithName("up") as SKLabelNode! {
            let _xyz = _player.front.calcXyz(_player.head, x: _player.x, y: _player.y, z: _player.z, xx:0, yy:0, zz:1);
            _node.text = "UP(\(_xyz[0]),\(_xyz[1]),\(_xyz[2]))";
        }
        if let _node:SKLabelNode = childNodeWithName("down") as SKLabelNode! {
            let _xyz = _player.front.calcXyz(_player.head, x: _player.x, y: _player.y, z: _player.z, xx:0, yy:0, zz:-1);
            _node.text = "DOWN(\(_xyz[0]),\(_xyz[1]),\(_xyz[2]))";
        }
        if let _node:SKLabelNode = childNodeWithName("right") as SKLabelNode! {
            let _xyz = _player.front.calcXyz(_player.head, x: _player.x, y: _player.y, z: _player.z, xx:1, yy:0, zz:0)
            _node.text = "RIGHT(\(_xyz[0]),\(_xyz[1]),\(_xyz[2]))";
        }
        if let _node:SKLabelNode = childNodeWithName("left") as SKLabelNode! {
            let _xyz = _player.front.calcXyz(_player.head, x: _player.x, y: _player.y, z: _player.z, xx:-1, yy:0, zz:0)
            _node.text = "LEFT(\(_xyz[0]),\(_xyz[1]),\(_xyz[2]))";
        }

    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
    }
    
    // MARK: シーン作成
    func createContentScene() {

        createLabel()
        
        
    }
    
    func createMiniMap(map:[Field], max:Int) {
        
        self.enumerateChildNodesWithName("wall") {
            node, stop in
            node.removeFromParent()
        }
        
        for _z in [1] {
            for _y in 0..<max {
                for _x in 0..<max {
                    let _field = map[_x + _y * max + _z * max * max]
                    if _field.wall == false {
                        continue
                    }
                    
                    let _shape =  SKShapeNode(rect: CGRectMake(0, 0, 5, 5));
                    _shape.strokeColor = SKColor.blackColor()
                    _shape.fillColor=SKColor.blackColor()
                    _shape.position = CGPointMake(CGFloat(_x*5+100), CGFloat(_y*5+100*_z))
                    _shape.name = "wall"
                    _shape.zPosition = 1000
                    self.addChild(_shape)
                }
            }
        }

        
    }
    
    func createLabel() {
        var _zPosition:CGFloat = 10000
        
        let _debugLabel = SKLabelNode(text: "")
        _debugLabel.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) - 100)
        _debugLabel.fontSize = 20
        
        _debugLabel.zPosition = _zPosition
        _debugLabel.name = "debug"
        _debugLabel.fontColor = UIColor.redColor()
        self.addChild(_debugLabel)
        
        let _upLabel = SKLabelNode(text: "UP")
        _upLabel.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) - 20)
        _upLabel.zPosition = _zPosition
        _upLabel.fontSize = 15
        _upLabel.fontColor = UIColor.redColor()
        _upLabel.name = "up"
        addChild(_upLabel)
        
        let _downLabel = SKLabelNode(text: "DOWN")
        _downLabel.position = CGPointMake(CGRectGetMidX(frame), 20)
        _downLabel.zPosition = _zPosition
        _downLabel.fontSize = 15
        _downLabel.fontColor = UIColor.redColor()
        _downLabel.name = "down"
        addChild(_downLabel)
        
        let _leftLabel = SKLabelNode(text: "LEFT")
        _leftLabel.position = CGPointMake(40, CGRectGetMidY(frame))
        _leftLabel.zPosition = _zPosition
        _leftLabel.fontSize = 15
        _leftLabel.fontColor = UIColor.redColor()
        _leftLabel.name = "left"
        addChild(_leftLabel)
        
        let _rightLabel = SKLabelNode(text: "RIGHT")
        _rightLabel.position = CGPointMake(CGRectGetMaxX(frame) - 40, CGRectGetMidY(frame))
        _rightLabel.zPosition = _zPosition
        _rightLabel.fontSize = 15
        _rightLabel.fontColor = UIColor.redColor()
        _rightLabel.name = "right"
        addChild(_rightLabel)
        
//        let _rotateLabel = SKLabelNode(text: "ROTATE")
//        _rotateLabel.position = CGPointMake(CGRectGetMaxX(frame) * 0.75, CGRectGetMaxY(frame) * 0.25)
//        _rotateLabel.zPosition = _zPosition
//        _rotateLabel.fontSize = 15
//        _rotateLabel.fontColor = UIColor.redColor()
//        _rotateLabel.name = "rotate"
//        addChild(_rotateLabel)
//        
//        let _rotateXLabel = SKLabelNode(text: "ROTATEX")
//        _rotateXLabel.position = CGPointMake(CGRectGetMaxX(frame) * 0.25, CGRectGetMaxY(frame) * 0.25 )
//        _rotateXLabel.zPosition = _zPosition
//        _rotateXLabel.fontSize = 15
//        _rotateXLabel.fontColor = UIColor.redColor()
//        _rotateXLabel.name = "rotatex"
//        addChild(_rotateXLabel)
//
//        let _rotateYLabel = SKLabelNode(text: "ROTATEY")
//        _rotateYLabel.position = CGPointMake(CGRectGetMaxX(frame) * 0.25, CGRectGetMaxY(frame) * 0.25 - 20 )
//        _rotateYLabel.zPosition = _zPosition
//        _rotateYLabel.fontSize = 15
//        _rotateYLabel.fontColor = UIColor.redColor()
//        _rotateYLabel.name = "rotatey"
//        addChild(_rotateYLabel)
//        
//        let _rotateZLabel = SKLabelNode(text: "ROTATEZ")
//        _rotateZLabel.position = CGPointMake(CGRectGetMaxX(frame) * 0.25, CGRectGetMaxY(frame) * 0.25 - 40)
//        _rotateZLabel.zPosition = _zPosition
//        _rotateZLabel.fontSize = 15
//        _rotateZLabel.fontColor = UIColor.redColor()
//        _rotateZLabel.name = "rotatez"
//        addChild(_rotateZLabel)
//        
        
    }
    
//    func getField(x:Int, y:Int, z:Int, map:[Field])->Field {
//        let _max = 15
//        
//        if (x < 0 || x >= _max || y < 0 || y >= _max || z < 0 || z >= _max) {
//            return Field()
//        }
//        
//        let _n = x + y * _max + z * _max * _max;
//        if ( _n < 0 || _n >= map.count) {
//            return Field()
//        }
//        return map[_n]
//    }
    
    
    func getDirection(xyz:[Int])->Direction {
        let _directions:[Direction] = [.N, .S, .E, .W, .C, .F]
        for _d in _directions {
            if _d.xyz() == xyz {
                return _d
            }
        }
        return .N
    }
    
    
    func refreshScreenMiniMap(front:Direction, head:Direction, map:[Field]) {
        
        self.enumerateChildNodesWithName("minimap") {
            node, stop in
            node.removeFromParent()
        }
        
        for (var _y = -7;_y<=7;_y++)  {
            for (var _x = -7;_x<=7;_x++) {
                let _xyz = front.calcXyz(.C, x: 7, y: 7, z: 1, xx: _x, yy: _y, zz: 0)
                let _wall = Map.getField(_xyz[0], y:_xyz[1], z:_xyz[2], map:map, max:15)
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
    
}
