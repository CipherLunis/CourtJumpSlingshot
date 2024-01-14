//
//  GameViewController.swift
//  CourtJumpSlingshot
//
//  Created by Cipher Lunis on 1/13/24.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func loadView() {
        self.view = SKView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                //scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                //scene.size = view.bounds.size
                
                view.presentScene(scene)
                view.showsNodeCount = true
            }
        }
    }
}
