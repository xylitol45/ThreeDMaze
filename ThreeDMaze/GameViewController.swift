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

class GameViewController: UIViewController  {
    
    var cameraNode:SCNNode? = nil
    // var player:Player = Player(front:.N, head:.C, x:3, y:5, z:1)
    var player:Player = Player(front:.N, head:.C, x:1, y:1, z:1)
    
    var rotateX:Float = 0
    var rotateY:Float = 0
    var rotateZ:Float = 0
    
    var boxNode:SCNNode? = nil
    var lightNode:SCNNode? = nil
    
    var map:[Field] = [Field]()
    let max:Int = 11
    
//    func getCameraNode()->SCNNode {
//        return cameraNode!
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _max = max
        map = Map.create(_max)
        
        // create a new scene
        // let scene = SCNScene(named: "art.scnassets/ship.dae")!
        //      let scene = SCNScene()
        // retrieve the SCNView
        
        let _scene = SCNScene()
        
        let scnView = self.view as SCNView
        
        println(scnView.frame)
        
        scnView.allowsCameraControl = false
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
        cameraNode!.eulerAngles = SCNVector3(x: Float(M_PI_2), y: 0, z: 0)
        
        //cameraNode!.position = SCNVector3(x: 10, y:10, z: 10)
        //cameraNode!.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)
        
        _scene.rootNode.addChildNode(cameraNode!)
        
        // create and add a light to the scene
        lightNode = SCNNode()
        lightNode!.light = SCNLight()
        lightNode!.light!.type = SCNLightTypeOmni
//        lightNode!.light!.attenuationEndDistance = 100
        //lightNode.light!.type = SCNLightTypeDirectional
        lightNode!.position = SCNVector3(x: 0, y: 0, z: 50)
//        lightNode!.position = cameraNode!.position
        
        
        _scene.rootNode.addChildNode(lightNode!)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        //vambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.grayColor()
        _scene.rootNode.addChildNode(ambientLightNode)
                
        for _z in 0..<_max  {
            for _y in 0..<_max {
                for _x in 0..<_max {
                    
                    let _field = map[_x + _y * _max + _z * _max * _max]
                    if _field.coin == true {
                        createCoin(Float(_x), y: Float(_y), z: Float(_z), no: 0)
                        continue
                    }
                    
                    if _field.wall == true {
                        createBox(Float(_x), y: Float(_y), z: Float(_z), no: 0)
                    }
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
        
        
        
        
        let _gameScene = ControllerScene(size:CGSizeMake(667,375))
        _gameScene.gameViewController = self
        _gameScene.scaleMode = .AspectFit
        _gameScene.createMiniMap(map, max: _max, z:player.z)
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
    
    // MARK: create
    var baseBoxNode:SCNNode? = nil
    
    func createBox(x:Float, y:Float, z:Float, no:Int)->SCNNode? {
        
        if baseBoxNode == nil {
            let _box = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0)
            
            let _material = SCNMaterial()
            _material.diffuse.contents = UIImage(named: "100x100_\(no).png")
//          _material.diffuse.contents = UIColor.whiteColor()
            _box.firstMaterial = _material
            
            baseBoxNode = SCNNode(geometry: _box)
            
        }
        
        
        //        _boxNode.position = SCNVector3(x: x,  y: y, z: z)
        //        _scene.rootNode.addChildNode(_boxNode)
        
        let _view = self.view as SCNView
        if let _scene = _view.scene {
            // let _box = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0)
            
            
            //            let _material2 = SCNMaterial()
            //            _material2.diffuse.contents = UIColor.blueColor()
            
            //let _cloneNode = baseBoxNode!.clone() as SCNNode
            let _cloneNode = baseBoxNode!.flattenedClone()
            
            _cloneNode.position = SCNVector3(x: x * 2,  y: y * 2, z: z * 2)
            _scene.rootNode.addChildNode(_cloneNode)
            
            return _cloneNode
        }
        
        return nil
    }
    

    var baseCoinNode:SCNNode? = nil
    
    func createCoin(x:Float, y:Float, z:Float, no:Int)->SCNNode? {
        
        if baseCoinNode == nil {
//            let _actions:[SCNAction] = [
//                SCNAction.waitForDuration(NSTimeInterval( arc4random_uniform(5) )),
//                SCNAction.repeatActionForever(
//                    SCNAction.rotateByAngle(CGFloat(M_PI * 2), aroundAxis: SCNVector3(x:0,y:0,z:1), duration: 10.0)
//                )]
            
            let _coin = SCNCylinder(radius: 0.4, height: 0.1)
//            let _coin = SCNPyramid(width: 0.2, height: 0.5, length: 0.2)
            //        let _coin = SCNSphere(radius: 0.4)
            let _material = SCNMaterial()
            _material.diffuse.contents = UIColor.yellowColor()
            //        _material.emission.contents = UIColor.yellowColor()
            _coin.firstMaterial = _material
            
            baseCoinNode = SCNNode(geometry: _coin)

//            baseCoinNode!.runAction(SCNAction.sequence(_actions))

        }
        
        let _view = self.view as SCNView
        if let _scene = _view.scene {
            //            let _coin = SCNCylinder(radius: 0.5, height: 0.1)
            //
            //            let _material = SCNMaterial()
            //            _material.diffuse.contents = UIColor.yellowColor()
            //            _coin.firstMaterial = _material
            //
            //            let _coinNode = SCNNode(geometry: _coin)
            
            let _cloneNode = baseCoinNode!.flattenedClone()
            _cloneNode.position = SCNVector3(x: x * 2,  y: y * 2, z: z * 2)
//            _cloneNode.eulerAngles = SCNVector3(x:Float(M_PI_2 / 3),y:Float(M_PI_2 / 3),z:Float(M_PI_2 / 3))
            _cloneNode.name = "coin\(Int(x) + Int(y) * max + Int(z) * max * max)"
            
            // println(_cloneNode.name)
            
            let _actions:[SCNAction] = [
                SCNAction.waitForDuration(NSTimeInterval( arc4random_uniform(5) )),
                SCNAction.repeatActionForever(
                    SCNAction.rotateByAngle(CGFloat(M_PI * 2), aroundAxis: SCNVector3(x:0,y:0,z:1), duration: 5.0)
                )]
            
            // _cloneNode.runAction(SCNAction.sequence(_actions))
            
            _scene.rootNode.addChildNode(_cloneNode)
            
            return _cloneNode
        }
        
        return nil
    }

    
    // MARK: move
    var moving = false
    
    func moveFront() {
        
        if moving == true {
//            return
        }
        
        var _xyz = player.front.xyz()
        _xyz = [player.x+_xyz[0], player.y+_xyz[1], player.z+_xyz[2]]
        let _frontField = Map.getField(_xyz[0], y: _xyz[1], z:_xyz[2] , map:map, max:max)
        if _frontField.wall == true {
            return
        }
        
//        moving = true
        
        player.x = _xyz[0]
        player.y = _xyz[1]
        player.z = _xyz[2]

        if _frontField.coin == true{
            
            let _view = self.view as SCNView?
            let _name = "coin\(Int(player.x) + Int(player.y) * max + Int(player.z) * max * max)"
            if let _coinNode = _view!.scene!.rootNode.childNodeWithName(_name, recursively:true) {
                _coinNode.removeFromParentNode()
            }
       
            _frontField.coin = false
            
            if let _gameScene = _view!.overlaySKScene as ControllerScene?{
                _gameScene.refreshCoinLabel()
            }

        }
        
        
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
        
         let _position = SCNVector3(x:Float(player.x*2)+_xx,y:Float(player.y*2)+_yy,z:Float(player.z*2)+_zz)
         let _action =
         SCNAction.moveTo(_position,duration: 0.2)
        
         cameraNode!.runAction(
            SCNAction.sequence([_action,
                SCNAction.runBlock { (node) -> Void in
//                    self.moving = false
                }]
            )
        )

//        lightNode!.position = _position
//        cameraNode!.position = SCNVector3(x:Float(player.x*2)+_xx,y:Float(player.y*2)+_yy,z:Float(player.z*2)+_zz)
        
        return
    }
    
    func rotateFront(rotation:Rotation) {
        
        var _xAngle:CGFloat=0, _yAngle:CGFloat=0, _zAngle:CGFloat=0
        var _vec:SCNVector3? = nil
        var _n:CGFloat = 1
        
        if rotation == .UP || rotation == .DOWN {
            let _right = player.front.right(player.head)
            _n  = (rotation == .UP) ? -1 : 1
            
            switch(_right) {
            case .N: _vec = SCNVector3(x: 0, y: 1, z: 0)
            case .S: _vec = SCNVector3(x: 0, y: 1, z: 0);
            _n *= -1;
            case .E: _vec = SCNVector3(x: 1, y: 0, z: 0)
            case .W: _vec = SCNVector3(x: 1, y: 0, z: 0);
            _n *= -1;
            case .C: _vec = SCNVector3(x: 0, y: 0, z: 1)
            case .F: _vec = SCNVector3(x: 0, y: 0, z: 1);
            _n *= -1;
            default:return;
            }
        } else if rotation == .RIGHT || rotation == .LEFT {
            _n  = (rotation == .RIGHT) ? 1 : -1
            switch(player.head) {
            case .N: _vec = SCNVector3(x: 0, y: 1, z: 0)
            case .S: _vec = SCNVector3(x: 0, y: 1, z: 0);
            _n *= -1;
            case .E: _vec = SCNVector3(x: 1, y: 0, z: 0)
            case .W: _vec = SCNVector3(x: 1, y: 0, z: 0);
            _n *= -1;
            case .C: _vec = SCNVector3(x: 0, y: 0, z: 1)
            case .F: _vec = SCNVector3(x: 0, y: 0, z: 1);
            _n *= -1;
            default:return;
            }
        } else {
            return
        }
        
        #if false
        var _vec:SCNVector3? = nil
        var _angle:CGFloat = 0
        
        if rotation == .UP {
            _vec = SCNVector3(x: 1, y: 0, z: 0)
            _angle = CGFloat(M_PI_2)
        } else if rotation == .DOWN {
            _vec = SCNVector3(x: 1, y: 0, z: 0)
            _angle = CGFloat(M_PI_2) * -1
        } else if rotation == .RIGHT {
            _vec = SCNVector3(x: 0, y: 0, z: 1)
            _angle = CGFloat(M_PI_2)
        } else if rotation == .LEFT {
            _vec = SCNVector3(x: 0, y: 0, z: 1)
            _angle = CGFloat(M_PI_2) * -1
        } else {
            return
        }
        #endif
        // let _rotateAction = SCNAction.rotateByX( _xAngle, y: _yAngle, z: _zAngle, duration: 0.5)
        
        if moving == true {
//            return
        }
        
//        moving = true
        
        let _rotateAction = SCNAction.rotateByAngle(CGFloat(M_PI_2) * _n , aroundAxis: _vec!, duration: 0.5)
        
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
        
        let _position = SCNVector3(x:Float(player.x*2) + _xx, y:Float(player.y*2) + _yy, z:Float(player.z*2) + _zz)
        
//        lightNode!.position = _position
        
        let _moveAction = SCNAction.moveTo(_position, duration: 0.1)
        
//        let _groupAction = SCNAction.group([_rotateAction, _moveAction])
//        let _resetAction = SCNAction.runBlock { (node) -> Void in
//           self.resetAngle()
//        }
        
        cameraNode!.runAction(
            SCNAction.sequence([
                SCNAction.group([_rotateAction, _moveAction]),
                SCNAction.runBlock { (node) -> Void in
                    let _angles = node.eulerAngles
                    let _xAngle = _angles.x / Float(M_PI_2)
                    let _yAngle = _angles.y / Float(M_PI_2)
                    let _zAngle = _angles.z / Float(M_PI_2)
                    
                    
                    println("x :\(_xAngle) y :\(_yAngle) z :\(_zAngle)")
                    
//                    self.moving = false
                    
                    // self.resetAngle()
                }
                ])
        );
    }
//    
//    func resetAngle() {
//        
//        let _pi2 = Float(M_PI_2)
//        var _vec:SCNVector3? = nil
//        
//        switch(player.front) {
//        case .N:
//            switch(player.head) {
//            case .C: _vec = SCNVector3(x: _pi2, y: 0, z: 0);
//            case .F: _vec = SCNVector3(x: _pi2, y: _pi2 * 2, z: 0);
//            case .E: _vec = SCNVector3(x: _pi2, y: _pi2 * 1, z: 0);
//            case .W: _vec = SCNVector3(x: _pi2, y: _pi2 * 3, z: 0);
//            default: break;
//            }
//        case .S:
//            switch(player.head) {
//            case .C: _vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 2, z: 0 );
//            case .F: _vec  = SCNVector3(x: _pi2 * 3, y: 0, z: 0 );
//            case .E: _vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 3, z: 0 );
//            case .W: _vec  = SCNVector3(x: _pi2 * 3, y: _pi2, z: 0 );
//            default: break;
//            }
//        case .E:
//            switch(player.head) {
//            case .N:_vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 3, z: _pi2 );
//            case .S:_vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 1, z: _pi2 );
//            case .C:_vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 2, z: _pi2 );
//            case .F:_vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 0, z: _pi2  );
//            default: break;
//            }
//        case .W:
//            switch(player.head) {
//            case .N:_vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 1, z: _pi2 * 3);
//            case .S:_vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 3, z: _pi2 * 3);
//            case .C:_vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 2, z: _pi2 * 3);
//            case .F:_vec  = SCNVector3(x: _pi2 * 3, y: _pi2 * 0, z: _pi2 * 3);
//            default: break;
//            }
//        case .C:
//            switch(player.head) {
//            case .N:_vec = SCNVector3(x: 0, y: _pi2*2, z: 0 );
//            case .S:_vec = SCNVector3(x: 0, y: _pi2*2, z: _pi2*2 );
//                
//            case .E:_vec = SCNVector3(x: 0, y: _pi2*4, z: _pi2 );
//                
//            case .W:_vec = SCNVector3(x: 0, y: _pi2*4, z: _pi2 * 3);
//            default: break;
//            }
//        case .F:
//            switch(player.head) {
//            case .N:_vec = SCNVector3(x: 0, y: 0, z: 0 );
//            case .S:_vec = SCNVector3(x: 0, y: 0, z: _pi2 * 2 );
//            case .E:_vec = SCNVector3(x: 0, y: 0, z: _pi2 * 3 );
//            case .W:_vec = SCNVector3(x: 0, y: 0, z: _pi2 );
//            default: break;
//            }
//        default: break;
//            
//        }
//        
//        println("resetAnglo front \(player.front.toString()) head \(player.head.toString())")
//        
//        cameraNode!.eulerAngles = _vec!
//    }
//    
    
}
