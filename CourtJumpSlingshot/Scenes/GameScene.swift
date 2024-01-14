//
//  GameScene.swift
//  CourtJumpSlingshot
//
//  Created by Cipher Lunis on 1/13/24.
//

import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var jumper = SKSpriteNode()
    var bg = SKSpriteNode()
    var startPos = CGPoint()
    
    /*override init(size: CGSize) {
        super.init(size: size)
        self.size = size
        
        jumper = childNode(withName: "Jumper") as! SKSpriteNode
        print(jumper.position)
        print(jumper.zPosition)
        jumper.physicsBody?.affectedByGravity = false
        jumper.color = .red
        jumper.colorBlendFactor = 0.5
        //jumper.size = CGSize(width: frame.width/5, height: frame.width/5)
        startPos = jumper.position
        
        bg = childNode(withName: "BG") as! SKSpriteNode
        bg.size = CGSize(width: frame.width, height: frame.height)
        bg.physicsBody?.affectedByGravity = false
        
        
        physicsWorld.contactDelegate = self
//        let playerTextureAtlas = SKTextureAtlas(named: K.AnimationTextureAtlas)
//
//        for
//        playerFrames.append(playerTextureAtlas.textureNamed(K.Images.Chomp1))
//        playerFrames.append(playerTextureAtlas.textureNamed(K.Images.Chomp2))
    } */
    
//    required init?(coder aDecoder: NSCoder) {
//       super.init(coder: aDecoder)
//    }
    
    override func didMove(to view: SKView) {
        print("DID MOVE TO VIEW 2")
        jumper = childNode(withName: "Jumper") as! SKSpriteNode
        print(jumper.position)
        print(jumper.zPosition)
        jumper.physicsBody?.affectedByGravity = false
        jumper.color = .red
        jumper.colorBlendFactor = 0.8
        //jumper.size = CGSize(width: frame.width/5, height: frame.width/5)
        
        bg = childNode(withName: "BG") as! SKSpriteNode
        bg.size = CGSize(width: frame.width, height: frame.height)
        
        startPos = jumper.position
        
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // HANDLE COLLISIONS
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let tapLocation = touch.location(in: view)
        let touchedNodes = self.nodes(at: tapLocation)
        
        print("touches began")
        print(touchedNodes)
        for node in touchedNodes {
            if let spriteNode = node as? SKSpriteNode {
                print("node touched: \(spriteNode.name)")
                if node == jumper {
                    jumper.position = tapLocation
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let tapLocation = touch.location(in: view)
        let touchedNodes = self.nodes(at: tapLocation)
        print("touches moved")
        print(touchedNodes)
        for node in touchedNodes {
            if let spriteNode = node as? SKSpriteNode {
                print("node touched: \(spriteNode.name)")
                if node == jumper {
                    jumper.position = tapLocation
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
