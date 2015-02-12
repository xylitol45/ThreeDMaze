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

class Game2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        // let scene = SCNScene(named: "art.scnassets/ship.dae")!
        let scene = SCNScene()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        println(cameraNode.camera!.xFov)
        
        // Degrees, not radians
        cameraNode.camera!.xFov = 120
        
        
        cameraNode.rotation = SCNVector4(x: 0, y: 0, z: 0, w: Float(M_PI)*0.5)
        
        println(cameraNode.rotation)
        
        //cameraNode.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 10)))
        
        // place the camera
        // cameraNode.position = SCNVector3(x: 0, y: 0, z: 1)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 50)
        
        scene.rootNode.addChildNode(cameraNode)
        
        
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 15*2+10, z: 50)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        // let ship = scene.rootNode.childNodeWithName("ship", recursively: true)!
        
        // animate the 3d object
        // ship.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
        
        for _z in 0..<15  {
            for _x in 0..<15 {
                for _y in 0..<15 {
                    
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
                    
                    scene.rootNode.addChildNode(_boxNode)
                }
            }
        }
        
        //        let _box2 = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0)
        //        let _material3 = SCNMaterial()
        //        _material3.diffuse.contents = UIColor.blueColor()
        //        _box2.firstMaterial = _material3
        //        let _box2Node = SCNNode(geometry: _box2)
        //        _box2Node.position = SCNVector3(x:0, y:0, z:-2)
        //        scene.rootNode.addChildNode(_box2Node)
        //
        let _box3 = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0)
        let _material4 = SCNMaterial()
        _material4.diffuse.contents = UIColor.blueColor()
        _box3.firstMaterial = _material4
        let _box3Node = SCNNode(geometry: _box3)
        _box3Node.position = SCNVector3(x:0, y:2, z:0)
        
        _box3Node.runAction(SCNAction.repeatActionForever(
            SCNAction.rotateToAxisAngle(SCNVector4(x:0,y:1,z:0,w:Float(M_PI)*2), duration: 10)))
        
        
        scene.rootNode.addChildNode(_box3Node)
        
        // retrieve the SCNView
        let scnView = self.view as SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        let gestureRecognizers = NSMutableArray()
        gestureRecognizers.addObject(tapGesture)
        if let existingGestureRecognizers = scnView.gestureRecognizers {
            gestureRecognizers.addObjectsFromArray(existingGestureRecognizers)
        }
        scnView.gestureRecognizers = gestureRecognizers
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
