//
//  GameViewController.swift
//  Spin
//
//  Created by Murray Buchanan on 28/06/2020.
//  Copyright © 2020 Murray Buchanan. All rights reserved.
//

import SpriteKit
import GameplayKit

// MARK: Design ideas:
/*
- Cat in the cave
- Doge in the dungeon - DogeCoins
- Stonks
  Musk/Monkey to the moon
- Karen in the hood
- Karen vs the Kracken
*/

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.frame.size)
            scene.scaleMode = .aspectFill // Set the scale mode to scale to fit the window
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
