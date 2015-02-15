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
    
    func getCameraNode()->SCNNode {
        return cameraNode!
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _max = 15
        let _map = Map.create(_max)
        
        // create a new scene
        // let scene = SCNScene(named: "art.scnassets/ship.dae")!
//      let scene = SCNScene()
        // retrieve the SCNView

        let _scene = SCNScene()
        
        let scnView = self.view as SCNView
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
        cameraNode!.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float(M_PI) / 2)
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
                
        for _z in 0..<_max  {
            for _y in 0..<_max {
                for _x in 0..<_max {
                    
                    let _field = _map[_x + _y * _max + _z * _max * _max]

                    if _field.wall == false {
                        continue
                    }
                    let _box = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0)
                    
                    let _material = SCNMaterial()
                    _material.diffuse.contents = UIImage(named: "100x100.png")
                    //        _material.diffuse.borderColor = UIColor.blackColor()
                    
                    let _material2 = SCNMaterial()
                    _material2.diffuse.contents = UIColor.blueColor()
                    
                    _box.firstMaterial = _material
                    //_box.materials=[_material,_material2]
                    
                    let _boxNode = SCNNode(geometry: _box)
                    _boxNode.position = SCNVector3(x: Float(_x)*2,  y: Float(_y)*2, z: Float(_z)*2)
                    
                    //_boxNode.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(1, y: 1, z: 0, duration: 1)))
                    
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
        _gameScene.createMiniMap(_map, max: _max)
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
        
        var _vec4:SCNVector4? = nil
        
        switch(player.front) {
        case .N:
            switch(player.head) {
            case .C: _vec4 = SCNVector4(x: 1, y: 0, z: 0, w: Float(M_PI)/2);                
            case .F: _vec4 = SCNVector4(x: 1, y: 0, z: 2, w: Float(M_PI)/2);
            case .E: _vec4 = SCNVector4(x: 1, y: 0, z: 1, w: Float(M_PI)/2);
            case .W: _vec4 = SCNVector4(x: 1, y: 0, z: 3, w: Float(M_PI)/2);
            default: break;
            }
        case .S:
            switch(player.head) {
            case .C: _vec4 = SCNVector4(x:-1,  y: 2, z: 0, w: Float(M_PI) / 2);
                
            case .F: _vec4 = SCNVector4(x: 3, y: 0, z: 3, w: Float(M_PI)/2);
            case .E: _vec4 = SCNVector4(x: 3, y: 0, z: 0, w: Float(M_PI)/2);
            case .W: _vec4 = SCNVector4(x: 3, y: 0, z: 2, w: Float(M_PI)/2);
            default: break;
            }
        case .E:
            switch(player.head) {
            case .N: _vec4 = SCNVector4(x: 0, y: 1, z: 0, w: Float(M_PI)/2);
            case .S: _vec4 = SCNVector4(x: 2, y: 1, z: 0, w: Float(M_PI)/2);

            case .C:_vec4 = SCNVector4(x: 1, y: 1, z: 0, w: Float(M_PI)/2);
            
            case .F:_vec4 = SCNVector4(x: 3, y: 1, z: 0, w: Float(M_PI)/2);
            default: break;
            }
        case .W:
            switch(player.head) {
            case .N: _vec4 = SCNVector4(x: 0, y: 3, z: 0, w: Float(M_PI)/2);
            case .S: _vec4 = SCNVector4(x: 2, y: 3, z: 0, w: Float(M_PI)/2);
            
            case .C:_vec4 = SCNVector4(x: 1, y: 3, z: 0, w: Float(M_PI)/2);
            
            case .F:_vec4 = SCNVector4(x: 1, y: 3, z: 0, w: Float(M_PI)/2);
            default: break;
            }
        case .C:
            switch(player.head) {
            case .N: _vec4 = SCNVector4(x: 0, y: 3, z: 0, w: Float(M_PI)/2);
                
            case .S: _vec4 = SCNVector4(x: 2, y: 0, z: 0, w: Float(M_PI)/2);
                
            case .E:_vec4 = SCNVector4(x: 3, y: 3, z: 0, w: Float(M_PI)/2);
            case .W:_vec4 = SCNVector4(x: 1, y: 3, z: 0, w: Float(M_PI)/2);
            default: break;
            }
        case .F:
            switch(player.head) {
            case .N: _vec4 = SCNVector4(x: 0, y: 0, z: 0, w: Float(M_PI)/2);
            case .S: _vec4 = SCNVector4(x: 2, y: 0, z: 0, w: Float(M_PI)/2);
            case .E:_vec4 = SCNVector4(x: 3, y: 0, z: 0, w: Float(M_PI)/2);
            case .W:_vec4 = SCNVector4(x: 1, y: 0, z: 0, w: Float(M_PI)/2);
            default: break;
            }
        default: break;
            
        }
        
        cameraNode!.position = SCNVector3(x:Float(player.x*2+_xx), y:Float(player.y*2+_yy), z:Float(player.z*2+_zz))
        if _vec4 != nil {
            cameraNode!.rotation = _vec4!
        }
        
        println("rotate x:\(cameraNode!.rotation.x) y:\(cameraNode!.rotation.y) z:\(cameraNode!.rotation.z)")
    }

    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        if let hitResults = scnView.hitTest(p, options: nil) {
            // check that we clicked on at least one object
            if hitResults.count > 0 {
                // retrieved the first clicked object
                let result: AnyObject! = hitResults[0]
                
                // get its material
                let material = result.node!.geometry!.firstMaterial!
                
                // highlight it
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                // on completion - unhighlight
                SCNTransaction.setCompletionBlock {
                    SCNTransaction.begin()
                    SCNTransaction.setAnimationDuration(0.5)
                    
                    material.emission.contents = UIColor.blackColor()
                    
                    SCNTransaction.commit()
                }
                
                material.emission.contents = UIColor.redColor()
                
                SCNTransaction.commit()
            }
        }
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
