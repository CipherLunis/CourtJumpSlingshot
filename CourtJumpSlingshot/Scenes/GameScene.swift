//
//  GameScene.swift
//  CourtJumpSlingshot
//
//  Created by Cipher Lunis on 1/13/24.
//

import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    
    var jumper = SKSpriteNode()
    var woodenObjects: [SKSpriteNode] = []
    
    var startPos = CGPoint()
    
    var isMoving = false
    var numJudgesLeft = 2
    var score = 0
    
    var jumperAnimationTextures: [SKTexture] = []
    
    var scoreTextLabel = SKLabelNode()
    var pointsLabel = SKLabelNode()
    
    @Published var didBeatLevel = false
    
    private struct Constants {
        static var MovementResetThreshold = 0.005
        static var JumpAnimationTimePerFrame = 0.05
    }
    
    private enum ColliderTypes: UInt32 {
        case JumperCategory = 0b100
        case WoodenObjectCategory = 0b1000
        case JudgeCategory = 0b10000
        case GroundCategory = 0b100000
        case GlobalCollisionBitMask = 4294967295
    }
    
    private let temporaryPointsLabelAttributedString = NSAttributedString(string: "300", attributes: [
        NSAttributedString.Key.strokeWidth : -2.0,
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.font : UIFont(name: "ArialRoundedMTBold", size: 80.0)!
    ])
    
    private let scoreTextLabelAttributedString = NSAttributedString(string: "Score: ", attributes: [
        NSAttributedString.Key.strokeWidth : -2.0,
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.font : UIFont(name: "ArialRoundedMTBold", size: 80.0)!
    ])
    
    override func didMove(to view: SKView) {
        isMoving = false
        didBeatLevel = false
        
        let ground = childNode(withName: "Ground") as! SKSpriteNode
        ground.physicsBody?.categoryBitMask = ColliderTypes.GroundCategory.rawValue
        ground.physicsBody?.collisionBitMask = ColliderTypes.GlobalCollisionBitMask.rawValue
        ground.physicsBody?.contactTestBitMask = ColliderTypes.WoodenObjectCategory.rawValue | ColliderTypes.JudgeCategory.rawValue | ColliderTypes.JumperCategory.rawValue
        
        jumper = childNode(withName: "Jumper") as! SKSpriteNode
        jumper.physicsBody?.affectedByGravity = false
        jumper.physicsBody?.categoryBitMask = ColliderTypes.JumperCategory.rawValue
        jumper.physicsBody?.collisionBitMask = ColliderTypes.GlobalCollisionBitMask.rawValue
        jumper.physicsBody?.contactTestBitMask = ColliderTypes.WoodenObjectCategory.rawValue | ColliderTypes.JudgeCategory.rawValue | ColliderTypes.GroundCategory.rawValue
        jumper.color = .red
        jumper.colorBlendFactor = 0.8
        
        startPos = jumper.position
        
        scoreTextLabel = SKLabelNode(attributedText: scoreTextLabelAttributedString)
        scoreTextLabel.position = CGPoint(x: -frame.width/2.7, y: frame.height/3.7)
        addChild(scoreTextLabel)
        
        let pointsLabelAttributedString = NSAttributedString(string: "0", attributes: [
            NSAttributedString.Key.strokeWidth : -2.0,
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "ArialRoundedMTBold", size: 80.0)!
        ])
        pointsLabel = SKLabelNode(attributedText: pointsLabelAttributedString)
        pointsLabel.position = CGPoint(x: -frame.width/3.8, y: frame.height/3.75)
        pointsLabel.horizontalAlignmentMode = .left
        addChild(pointsLabel)
        
        for i in 1...2 {
            let judge = childNode(withName: "Judge\(i)") as! SKSpriteNode
            judge.name = "Judge"
            judge.color = .green
            judge.colorBlendFactor = 0.8
        }
        
        let jumperTextureAtlas = SKTextureAtlas(named: "JumpAnimation")
        for i in 1...jumperTextureAtlas.textureNames.count {
            let name = "Jump\(i)"
            jumperAnimationTextures.append(jumperTextureAtlas.textureNamed(name))
        }
        
        for i in 1...8 {
            let woodenObject = childNode(withName: "WoodenObject\(i)") as! SKSpriteNode
            woodenObject.name = "WoodenObject"
            woodenObject.physicsBody?.categoryBitMask = ColliderTypes.WoodenObjectCategory.rawValue
            woodenObject.physicsBody?.collisionBitMask = ColliderTypes.GlobalCollisionBitMask.rawValue
            woodenObject.physicsBody?.contactTestBitMask = ColliderTypes.JumperCategory.rawValue | ColliderTypes.GroundCategory.rawValue
            woodenObjects.append(woodenObject)
            // get wooden object initial positions for gameover
        }
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // HANDLE COLLISIONS
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        print("collision detected!")
        if nodeA == jumper || nodeB == jumper {
            if nodeA.name == "WoodenObject" {
                let woodenObjectSpriteNode = nodeA as! SKSpriteNode
                let woodenObjectType = woodenObjectSpriteNode.userData?.value(forKey: "woodObjectType") as! String
                let woodenObjectHitPoints = woodenObjectSpriteNode.userData?.value(forKey: "hitPoints") as! Int
                //woodenObjectSpriteNode.userData?.setObject(woodenObjectHitPoints-1, forKey: "hitPoints" as NSString)
                
                let dictionary:NSMutableDictionary! = woodenObjectSpriteNode.userData?.mutableCopy() as? NSMutableDictionary
                dictionary["hitPoints"] = woodenObjectHitPoints-1
                woodenObjectSpriteNode.userData = dictionary
                
                if woodenObjectHitPoints == 2 {
                    woodenObjectSpriteNode.texture = SKTexture(imageNamed: "\(woodenObjectType)Broken")
                } else if woodenObjectHitPoints == 1 {
                    woodenObjectSpriteNode.removeFromParent()
                }
                
            }
            if nodeB.name == "WoodenObject" {
                let woodenObjectSpriteNode = nodeB as! SKSpriteNode
                let woodenObjectType = woodenObjectSpriteNode.userData?.value(forKey: "woodObjectType") as! String
                let woodenObjectHitPoints = woodenObjectSpriteNode.userData?.value(forKey: "hitPoints") as! Int
                woodenObjectSpriteNode.texture = SKTexture(imageNamed: "\(woodenObjectType)Broken")
                //woodenObjectSpriteNode.userData?.setObject(woodenObjectHitPoints-1, forKey: "hitPoints" as NSString)
                
                let dictionary:NSMutableDictionary! = woodenObjectSpriteNode.userData?.mutableCopy() as? NSMutableDictionary
                dictionary["hitPoints"] = woodenObjectHitPoints-1
                woodenObjectSpriteNode.userData = dictionary
                
                if woodenObjectHitPoints == 2 {
                    woodenObjectSpriteNode.texture = SKTexture(imageNamed: "\(woodenObjectType)Broken")
                } else if woodenObjectHitPoints == 1 {
                    woodenObjectSpriteNode.removeFromParent()
                }
            }
            if nodeA.name == "Judge" {
                let judgeSpriteNode = nodeB as! SKSpriteNode
                let judgeHitPoints = judgeSpriteNode.userData?.value(forKey: "hitPoints") as! Int
                let dictionary:NSMutableDictionary! = judgeSpriteNode.userData?.mutableCopy() as? NSMutableDictionary
                dictionary["hitPoints"] = judgeHitPoints-1
                judgeSpriteNode.userData = dictionary
                
                if judgeHitPoints == 1 {
                    judgeSpriteNode.removeFromParent()
                    numJudgesLeft -= 1
                    score += 300
                    
                    pointsLabel.attributedText = NSAttributedString(string: "\(score)", attributes: [
                        NSAttributedString.Key.strokeWidth : -2.0,
                        NSAttributedString.Key.strokeColor : UIColor.black,
                        NSAttributedString.Key.foregroundColor : UIColor.white,
                        NSAttributedString.Key.font : UIFont(name: "ArialRoundedMTBold", size: 80.0)!
                    ])
                    
                    // animate points above judge's head
                    let temporaryPointsLabel = SKLabelNode(attributedText: temporaryPointsLabelAttributedString)
                    temporaryPointsLabel.position = judgeSpriteNode.position
                    addChild(temporaryPointsLabel)
                    
                    let pointsLabelMoveAction = SKAction.moveTo(y: temporaryPointsLabel.position.y + frame.height/8, duration: 1.0)
                    let pointsLabelFadeAction = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
                    let pointsLabelRemoveAction = SKAction.removeFromParent()
                    let moveFadeAndRemoveSequence = SKAction.sequence([SKAction.group([pointsLabelMoveAction, pointsLabelFadeAction]), pointsLabelRemoveAction])
                    temporaryPointsLabel.run(moveFadeAndRemoveSequence)
                    
                    if numJudgesLeft == 0 {
                        beatLevel()
                    }
                }
            }
            if nodeB.name == "Judge" {
                let judgeSpriteNode = nodeB as! SKSpriteNode
                let judgeHitPoints = judgeSpriteNode.userData?.value(forKey: "hitPoints") as! Int
                let dictionary:NSMutableDictionary! = judgeSpriteNode.userData?.mutableCopy() as? NSMutableDictionary
                dictionary["hitPoints"] = judgeHitPoints-1
                judgeSpriteNode.userData = dictionary
                
                if judgeHitPoints == 1 {
                    judgeSpriteNode.removeFromParent()
                    numJudgesLeft -= 1
                    score += 300
                    
                    pointsLabel.attributedText = NSAttributedString(string: "\(score)", attributes: [
                        NSAttributedString.Key.strokeWidth : -2.0,
                        NSAttributedString.Key.strokeColor : UIColor.black,
                        NSAttributedString.Key.foregroundColor : UIColor.white,
                        NSAttributedString.Key.font : UIFont(name: "ArialRoundedMTBold", size: 80.0)!
                    ])
                    
                    // animate points above judge's head
                    let temporaryPointsLabel = SKLabelNode(attributedText: temporaryPointsLabelAttributedString)
                    temporaryPointsLabel.position = judgeSpriteNode.position
                    addChild(temporaryPointsLabel)
                    
                    let pointsLabelMoveAction = SKAction.moveTo(y: temporaryPointsLabel.position.y + frame.height/8, duration: 1.0)
                    let pointsLabelFadeAction = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
                    let pointsLabelRemoveAction = SKAction.removeFromParent()
                    let moveFadeAndRemoveSequence = SKAction.sequence([SKAction.group([pointsLabelMoveAction, pointsLabelFadeAction]), pointsLabelRemoveAction])
                    temporaryPointsLabel.run(moveFadeAndRemoveSequence)
                    
                    if numJudgesLeft == 0 {
                        beatLevel()
                    }
                }
            }
        }
    }
    
    private func beatLevel() {
        // DO SOMETHING
        didBeatLevel = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let tapLocation = touch.location(in: self)
        let touchedNodes = self.nodes(at: tapLocation)
        
        print("touches began")
        print(touchedNodes)
        for node in touchedNodes {
            if node == jumper {
                jumper.position = tapLocation
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let tapLocation = touch.location(in: self)
        let touchedNodes = self.nodes(at: tapLocation)
        
        for node in touchedNodes {
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
    
    override func update(_ currentTime: TimeInterval) {
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
