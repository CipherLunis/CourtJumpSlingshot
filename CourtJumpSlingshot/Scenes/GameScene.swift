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
    var startPos = CGPoint()
    
    var isMoving = false
    
    var jumperAnimationTextures: [SKTexture] = []
    
    struct Constants {
        static var MovementResetThreshold = 0.005
        static var JumpAnimationTimePerFrame = 0.05
    }
    
    override func didMove(to view: SKView) {
        isMoving = false
        jumper = childNode(withName: "Jumper") as! SKSpriteNode
        print(jumper.position)
        print(jumper.zPosition)
        jumper.physicsBody?.affectedByGravity = false
        jumper.color = .red
        jumper.colorBlendFactor = 0.8
        
        startPos = jumper.position
        
        let jumperTextureAtlas = SKTextureAtlas(named: "JumpAnimation")
        for i in 1...jumperTextureAtlas.textureNames.count {
            let name = "Jump\(i)"
            jumperAnimationTextures.append(jumperTextureAtlas.textureNamed(name))
        }
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // HANDLE COLLISIONS
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let tapLocation = touch.location(in: self)
        let touchedNodes = self.nodes(at: tapLocation)
        
        print("touches began")
        print(touchedNodes)
        for node in touchedNodes {
            if let spriteNode = node as? SKSpriteNode {
                if node == jumper {
                    jumper.position = tapLocation
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let tapLocation = touch.location(in: self)
        let touchedNodes = self.nodes(at: tapLocation)
        print("touches moved")
        print(touchedNodes)
        for node in touchedNodes {
            if let spriteNode = node as? SKSpriteNode {
                if node == jumper {
                    if jumper.position.x < 0 {
                        jumper.position.x = 0
                    } else if jumper.position.x > frame.width/2 {
                        jumper.position.x = frame.width/2
                    } else {
                        jumper.position = tapLocation
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let tapLocation = touch.location(in: self)
        let touchedNodes = self.nodes(at: tapLocation)
        
        for node in touchedNodes {
            if let spriteNode = node as? SKSpriteNode {
                if node == jumper {
                    print("node last touched was jumper!")
                    let dx = -(tapLocation.x - startPos.x)
                    let dy = -(tapLocation.y - startPos.y)
                    let impulse = CGVector(dx: 10*dx, dy: 10*dy)
                    
                    isMoving = true
                    print("dx: \(dx)")
                    print("dy: \(dy)")
                    print("impulse: \(impulse)")
                    
                    jumper.physicsBody?.applyImpulse(impulse)
                    jumper.physicsBody?.applyAngularImpulse(-0.01)
                    jumper.physicsBody?.affectedByGravity = true
                    
                    let animateJumperAction = SKAction.animate(with: jumperAnimationTextures, timePerFrame: Constants.JumpAnimationTimePerFrame, resize: false, restore: false)
                    jumper.run(animateJumperAction)
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
//        print("jumper position x: \(jumper.position.x)")
//        print("frame width / 2: \(frame.width/2)")
//        if jumper.position.x > frame.width/2 {
//            jumper.position.x = frame.width/2
//        }
        //print("jumper.physicsBody.velocity.dx: \(jumper.physicsBody?.velocity.dx)")
        //print("jumper.physicsBody.velocity.dy: \(jumper.physicsBody?.velocity.dy)")
        //< 0.0001     > -0.0001
        if (((jumper.physicsBody?.velocity.dx)! <= Constants.MovementResetThreshold && (jumper.physicsBody?.velocity.dy)! <= Constants.MovementResetThreshold) &&
            ((jumper.physicsBody?.velocity.dx)! >= -Constants.MovementResetThreshold && (jumper.physicsBody?.velocity.dy)! <= Constants.MovementResetThreshold))
            && isMoving {
            jumper.physicsBody?.affectedByGravity = false
            jumper.physicsBody?.velocity = .zero
            jumper.physicsBody?.angularVelocity = 0
            jumper.position = startPos
            jumper.zRotation = 0
            jumper.texture = SKTexture(imageNamed: "Jump1")
            
            isMoving = false
        }
    }
}
