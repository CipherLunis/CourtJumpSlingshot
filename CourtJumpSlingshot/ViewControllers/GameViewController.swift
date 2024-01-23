//
//  GameViewController.swift
//  CourtJumpSlingshot
//
//  Created by Cipher Lunis on 1/13/24.
//

import UIKit
import SwiftUI
import SpriteKit

class GameViewController: UIViewController {

    var gameViewModel: GameViewModel?
    
    override func loadView() {
        self.view = SKView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {
            switch gameViewModel!.levelNumber {
            case 1:
                if let scene = SKScene(fileNamed: "Level\(gameViewModel!.levelNumber)") as? Level1 {
                    scene.scaleMode = .aspectFill
                    scene.gameViewModel = gameViewModel
                    view.presentScene(scene)
                }
            case 2:
                if let scene = SKScene(fileNamed: "Level\(gameViewModel!.levelNumber)") as? Level2 {
                    scene.scaleMode = .aspectFill
                    scene.gameViewModel = gameViewModel
                    view.presentScene(scene)
                }
            default:
                if let scene = SKScene(fileNamed: "Level2") as? Level2 {
                    scene.scaleMode = .aspectFill
                    scene.gameViewModel = gameViewModel
                    view.presentScene(scene)
                }
            }
            
        }
    }
}
