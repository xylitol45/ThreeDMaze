//
//  GameViewController.swift
//  ThreeDMaze
//
//  Created by yoshimura on 2015/02/03.
//  Copyright (c) 2015年 yoshimura. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func loadView() {
        let applicationFram = UIScreen.mainScreen().applicationFrame
        let skView = SKView(frame: applicationFram)
        self.view=skView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView:SKView = self.view as SKView
        skView.showsDrawCount = true
        skView.showsNodeCount = true
        skView.showsFPS=true
        // このサイズはiPhone6

        let scene = GameScene(size:CGSizeMake(667,375))
        scene.scaleMode = .AspectFit
        skView.presentScene(scene)
        
        
                    
    }

    override func shouldAutorotate() -> Bool {
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

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
