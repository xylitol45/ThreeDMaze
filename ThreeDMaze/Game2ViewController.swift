//
//  GameViewController.swift
//  TestSceneKit
//
//  Created by yoshimura on 2015/02/12.
//  Copyright (c) 2015年 yoshimura. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class Game2ViewController: UIViewController  {
    
    var cameraNode:SCNNode? = nil
    var player:Player = Player(front:.N, head:.C, x:3, y:5, z:1)
    
    var rotateX:Float = 0
    var rotateY:Float = 0
    var rotateZ:Float = 0
    
    var boxNode:SCNNode? = nil
    
    var map:[Field] = [Field]()
    
    func getCameraNode()->SCNNode {
        return cameraNode!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _max = 15
        map = Map.create(_max)
        
        // create a new scene
        // let scene = SCNScene(named: "art.scnassets/ship.dae")!
        //      let scene = SCNScene()
        // retrieve the SCNView
        
        let _scene = SCNScene()
        
        let scnView = self.view as SCNView
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.backgroundColor = UIColor.blackColor()
        
        scnView.scene = _scene
        
        
        // create and add a camera to the scene
        cameraNode = SCNNode()
        cameraNode!.camera = SCNCamera()
        // place the camera
        //        cameraNode!.position = SCNVector3(x: 0, y: 0, z: 50)
        // Degrees, not radians
        cameraNode!.camera!.xFov = 90
        cameraNode!.position = SCNVector3(x: Float(player.x * 2), y:Float(player.y * 2) - 1, z: Float(player.z * 2 ))
        
        //        cameraNode!.rotation = SCNVector4(x: 3, y: 1, z: 0, w: Float(M_PI) / 2)
        //        cameraNode!.rotation = SCNVector4(x: rotateX, y: rotateY, z: rotateZ, w: Float(M_PI) / 2)
        
        cameraNode!.eulerAngles = SCNVector3(x: Float(M_PI_2), y: 0, z: 0)
        
        //cameraNode!.position = SCNVector3(x: 10, y:10, z: 10)
        //cameraNode!.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)
        
        _scene.rootNode.addChildNode(cameraNode!)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 15*2+10, z: 50)
        _scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.grayColor()
        _scene.rootNode.addChildNode(ambientLightNode)
        
        #if false
            createBox(10, y: 20, z: 10, no:1)
            createBox(10, y:  0, z: 10, no:2)
            createBox( 0, y: 10, z: 10, no:3) // 左
            createBox(20, y: 10, z: 10, no:4) // 右
            boxNode = createBox(10, y: 10, z:  0, no:5)
            createBox(10, y: 10, z: 20, no:6)
        #endif
        
        for _z in 0..<_max  {
            for _y in 0..<_max {
                for _x in 0..<_max {
                    
                    let _field = map[_x + _y * _max + _z * _max * _max]
                    if _field.wall == false {
                        continue
                    }
                    let _box = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0)
                    
                    let _material = SCNMaterial()
                    _material.diffuse.contents = UIImage(named: "100x100.png")
                    
                    let _material2 = SCNMaterial()
                    _material2.diffuse.contents = UIColor.blueColor()
                    _box.firstMaterial = _material
                    
                    let _boxNode = SCNNode(geometry: _box)
                    _boxNode.position = SCNVector3(x: Float(_x)*2,  y: Float(_y)*2, z: Float(_z)*2)
                    _scene.rootNode.addChildNode(_boxNode)
                    
                    
                }
            }
        }
        
        // add a tap gesture recognizer
        //        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        //        let gestureRecognizers = NSMutableArray()
        //        gestureRecognizers.addObject(tapGesture)
        //        if let existingGestureRecognizers = scnView.gestureRecognizers {
        //            gestureRecognizers.addObjectsFromArray(existingGestureRecognizers)
        //        }
        //        scnView.gestureRecognizers = gestureRecognizers
        
        
        
        
        let _gameScene = GameScene(size:CGSizeMake(667,375))
        _gameScene.game2ViewController = self
        _gameScene.scaleMode = .AspectFit
        _gameScene.createMiniMap(map, max: _max)
        scnView.overlaySKScene = _gameScene
        
    }
    
    func refreshCameraRotateAndPosition() {
        
        var _xx=0, _yy=0, _zz=0
        
        // 実際の座標に対し、少し引く
        switch(player.front) {
        case .N: _yy = -1;
        case .S: _yy = 1;
        case .E: _xx = -1;
        case .W: _xx = 1;
        case .C: _zz = -1;
        case .F: _zz = 1;
        default: break;
        }
        
        let _pi2 = Float(M_PI_2)
        var _vec:SCNVector3? = nil
        
        switch(player.front) {
        case .N:
            switch(player.head) {
            case .C: _vec = SCNVector3(x: _pi2, y: 0, z: 0);
            case .F: _vec = SCNVector3(x: _pi2, y: _pi2 * 2, z: 0);
            case .E: _vec = SCNVector3(x: _pi2, y: _pi2 * 1, z: 0);
            case .W: _vec = SCNVector3(x: _pi2, y: _pi2 * 3, z: 0);
            default: break;
            }
        case .S:
            switch(player.head) {
            case .C: _vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 2, z: 0 );
            case .F: _vec  = SCNVector3(x: _pi2 * 3, y: 0, z: 0 );
            case .E: _vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 3, z: 0 );
            case .W: _vec  = SCNVector3(x: _pi2 * 3, y: _pi2, z: 0 );
            default: break;
            }
        case .E:
            switch(player.head) {
            case .N:_vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 3, z: _pi2 );
            case .S:_vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 1, z: _pi2 );
            case .C:_vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 2, z: _pi2 );
            case .F:_vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 0, z: _pi2  );
            default: break;
            }
        case .W:
            switch(player.head) {
            case .N:_vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 1, z: _pi2 * 3);
            case .S:_vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 3, z: _pi2 * 3);
            case .C:_vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 2, z: _pi2 * 3);
            case .F:_vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 0, z: _pi2 * 3);
            default: break;
            }
        case .C:
            switch(player.head) {
            case .N:_vec = SCNVector3(x: 0, y: _pi2*2, z: 0 );
            case .S:_vec = SCNVector3(x: 0, y: _pi2*2, z: _pi2*2 );
            case .E:_vec = SCNVector3(x: 0, y: _pi2*2, z: _pi2 );
            case .W:_vec = SCNVector3(x: 0, y: _pi2*2, z: _pi2*3 );
            default: break;
            }
        case .F:
            switch(player.head) {
            case .N:_vec = SCNVector3(x: 0, y: 0, z: 0 );
            case .S:_vec = SCNVector3(x: 0, y: 0, z: _pi2 * 2 );
            case .E:_vec = SCNVector3(x: 0, y: 0, z: _pi2 * 3 );
            case .W:_vec = SCNVector3(x: 0, y: 0, z: _pi2 );
            default: break;
            }
        default: break;
            
        }
        
        if _vec  != nil {
            cameraNode!.eulerAngles = _vec!
        }
        
        //        moveToFront(Float(player.x*2+_xx), y:Float(player.y*2+_yy), z:Float(player.z*2+_zz))
        
        //cameraNode!.position = SCNVector3(x:Float(player.x*2+_xx), y:Float(player.y*2+_yy), z:Float(player.z*2+_zz))
        
        //        println("rotate x:\(cameraNode!.rotation.x) y:\(cameraNode!.rotation.y) z:\(cameraNode!.rotation.z)")
    }
    
    func createBox(x:Float, y:Float, z:Float, no:Int)->SCNNode? {
        
        let _view = self.view as SCNView
        if let _scene = _view.scene {
            let _box = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0)
            
            let _material = SCNMaterial()
            _material.diffuse.contents = UIImage(named: "100x100_\(no).png")
            
            let _material2 = SCNMaterial()
            _material2.diffuse.contents = UIColor.blueColor()
            _box.firstMaterial = _material
            
            let _boxNode = SCNNode(geometry: _box)
            _boxNode.position = SCNVector3(x: x,  y: y, z: z)
            _scene.rootNode.addChildNode(_boxNode)
            
            return _boxNode
        }
        
        return nil
    }
    
    func moveFront() {
        
        var _xyz = player.front.xyz()
        _xyz = [player.x+_xyz[0], player.y+_xyz[1], player.z+_xyz[2]]
        let _frontField = Map.getField(_xyz[0], y: _xyz[1], z:_xyz[2] , map:map, max:15)
        if _frontField.wall == true {
            return
        }
        
        player.x = _xyz[0]
        player.y = _xyz[1]
        player.z = _xyz[2]
        
        
        // 実際の座標に対し、少し引く
        var _xx:Float=0, _yy:Float=0, _zz:Float=0
        switch(player.front) {
        case .N: _yy = -1;
        case .S: _yy = 1;
        case .E: _xx = -1;
        case .W: _xx = 1;
        case .C: _zz = -1;
        case .F: _zz = 1;
        default: break;
        }
        
        let _action =
            SCNAction.moveTo(SCNVector3(x:Float(player.x*2)+_xx,y:Float(player.y*2)+_yy,z:Float(player.z*2)+_zz),
                duration: 0.2)
        
        cameraNode!.runAction(_action)
        
        return
    }
    
    func rotateFront(rotation:Rotation) {
        
        
        var _xAngle:CGFloat=0, _yAngle:CGFloat=0, _zAngle:CGFloat=0
        
        if rotation == .UP || rotation == .DOWN {
            let _right = player.front.right(player.head)
            let _n:CGFloat = (rotation == .UP) ? 1 : -1
            
            switch(_right) {
            case .N: _xAngle  = CGFloat(M_PI_2) * _n *  1
            case .S: _xAngle  = CGFloat(M_PI_2) * _n *  1
            case .E: _xAngle  = CGFloat(M_PI_2) * _n *  1
            case .W: _xAngle  = CGFloat(M_PI_2) * _n *  1
            case .C: _zAngle  = CGFloat(M_PI_2) * _n * -1
            case .F: _zAngle  = CGFloat(M_PI_2) * _n
            default:return;
            }
        } else if rotation == .RIGHT || rotation == .LEFT {
            let _n:CGFloat = (rotation == .RIGHT) ? 1: -1
            switch(player.head) {
            case .N: _yAngle  = CGFloat(M_PI_2) * _n * -1
            case .S: _yAngle  = CGFloat(M_PI_2) * _n *  1
            case .E: _yAngle  = CGFloat(M_PI_2) * _n * -1
            case .W: _yAngle  = CGFloat(M_PI_2) * _n * -1
            case .C: _zAngle  = CGFloat(M_PI_2) * _n * -1
            case .F: _zAngle  = CGFloat(M_PI_2) * _n *  1
            default:return;
            }
        } else {
            return
        }
        
        let _rotateAction = SCNAction.rotateByX( _xAngle, y: _yAngle, z: _zAngle, duration: 0.5)
        
        let _newFrontAndHead = player.front.rotate(player.head, rotation:rotation)
        player.front = _newFrontAndHead[0]
        player.head = _newFrontAndHead[1]
        
        
        // 実際の座標に対し、少し引く
        var _xx:Float = 0, _yy:Float = 0, _zz:Float = 0
        switch(player.front) {
        case .N: _yy = -1;
        case .S: _yy = 1;
        case .E: _xx = -1;
        case .W: _xx = 1;
        case .C: _zz = -1;
        case .F: _zz = 1;
        default: break;
        }
        
        let _moveAction = SCNAction.moveTo(
            SCNVector3(x:Float(player.x*2) + _xx, y:Float(player.y*2) + _yy, z:Float(player.z*2) + _zz), duration: 0.2)
        
        cameraNode!.runAction(SCNAction.group([_rotateAction, _moveAction]))
        
    }
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
