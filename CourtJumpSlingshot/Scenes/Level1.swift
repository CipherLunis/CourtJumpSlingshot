//
//  Level1.swift
//  CourtJumpSlingshot
//
//  Created by Cipher Lunis on 1/13/24.
//

import Foundation
import SpriteKit

class Level1: SKScene, SKPhysicsContactDelegate, ObservableObject {
    
    var gameViewModel: GameViewModel?
    
    var jumper = SKSpriteNode()
    var blueJumper1 = SKSpriteNode()
    var blueJumper2 = SKSpriteNode()
    var woodenObjects: [SKSpriteNode] = []
    
    var startPos = CGPoint()
    
    var isMoving = false
    var didPerformSpecialActionOnTap = false
    
    var numJudgesLeft = 2
    var currentBirdNum = 1
    
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
    
    private let scoreTextLabelAttributedString = NSAttributedString(string: "Score: ", attributes: [
        NSAttributedString.Key.strokeWidth : -2.0,
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.font : UIFont(name: "ArialRoundedMTBold", size: 80.0)!
    ])
    
    override func didMove(to view: SKView) {
        isMoving = false
        didBeatLevel = false
        didPerformSpecialActionOnTap = false
        
        let ground = childNode(withName: "Ground") as! SKSpriteNode
        ground.physicsBody?.categoryBitMask = ColliderTypes.GroundCategory.rawValue
        ground.physicsBody?.collisionBitMask = ColliderTypes.GlobalCollisionBitMask.rawValue
        ground.physicsBody?.contactTestBitMask = ColliderTypes.WoodenObjectCategory.rawValue | ColliderTypes.JudgeCategory.rawValue | ColliderTypes.JumperCategory.rawValue
        
        jumper = childNode(withName: "Jumper") as! SKSpriteNode
        jumper.name = "RedJumper"
        jumper.physicsBody?.affectedByGravity = false
        jumper.physicsBody?.categoryBitMask = ColliderTypes.JumperCategory.rawValue
        jumper.physicsBody?.collisionBitMask = ColliderTypes.GlobalCollisionBitMask.rawValue
        jumper.physicsBody?.contactTestBitMask = ColliderTypes.WoodenObjectCategory.rawValue | ColliderTypes.JudgeCategory.rawValue | ColliderTypes.GroundCategory.rawValue
        jumper.color = .red
        jumper.colorBlendFactor = 0.8
        
        blueJumper1 = childNode(withName: "BlueJumper1") as! SKSpriteNode
        blueJumper1.size = jumper.size
        blueJumper1.alpha = 0.0
        blueJumper1.color = .blue
        blueJumper1.colorBlendFactor = 0.8
        blueJumper1.zPosition = 2
        blueJumper1.name = "BlueJumper"
        
        blueJumper2 = childNode(withName: "BlueJumper2") as! SKSpriteNode
        blueJumper2.size = jumper.size
        blueJumper2.alpha = 0.0
        blueJumper2.color = .blue
        blueJumper2.colorBlendFactor = 0.8
        blueJumper2.zPosition = 2
        blueJumper2.name = "BlueJumper"
        
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
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == jumper || nodeB == jumper {
            if nodeA.name == "WoodenObject" {
                let woodenObjectSpriteNode = nodeA as! SKSpriteNode
                let woodenObjectType = woodenObjectSpriteNode.userData?.value(forKey: "woodObjectType") as! String
                let woodenObjectHitPoints = woodenObjectSpriteNode.userData?.value(forKey: "hitPoints") as! Int
                
                let dictionary:NSMutableDictionary! = woodenObjectSpriteNode.userData?.mutableCopy() as? NSMutableDictionary
                dictionary["hitPoints"] = woodenObjectHitPoints-1
                woodenObjectSpriteNode.userData = dictionary
                
                if woodenObjectHitPoints == 2 {
                    woodenObjectSpriteNode.texture = SKTexture(imageNamed: "\(woodenObjectType)Broken")
                } else if woodenObjectHitPoints == 1 {
                    woodenObjectSpriteNode.removeFromParent()
                    var addedScore = 0
                    switch woodenObjectType {
                    case "Square":
                        addedScore = 100
                    case "Triangle":
                        addedScore = 200
                    // rectangle
                    default:
                        addedScore = 250
                    }
                    gameViewModel!.score += addedScore
                    
                    pointsLabel.attributedText = NSAttributedString(string: "\(gameViewModel!.score)", attributes: [
                        NSAttributedString.Key.strokeWidth : -2.0,
                        NSAttributedString.Key.strokeColor : UIColor.black,
                        NSAttributedString.Key.foregroundColor : UIColor.white,
                        NSAttributedString.Key.font : UIFont(name: "ArialRoundedMTBold", size: 80.0)!
                    ])
                    
                    // animate points above judge's head
                    let temporaryPointsLabel = SKLabelNode(attributedText: NSAttributedString(string: "\(addedScore)", attributes: [
                        NSAttributedString.Key.strokeWidth : -2.0,
                        NSAttributedString.Key.strokeColor : UIColor.black,
                        NSAttributedString.Key.foregroundColor : UIColor.white,
                        NSAttributedString.Key.font : UIFont(name: "ArialRoundedMTBold", size: 80.0)!
                    ]))
                    temporaryPointsLabel.position = woodenObjectSpriteNode.position
                    temporaryPointsLabel.zPosition = 4
                    addChild(temporaryPointsLabel)
                    
                    let pointsLabelMoveAction = SKAction.moveTo(y: temporaryPointsLabel.position.y + frame.height/8, duration: 1.0)
                    let pointsLabelFadeAction = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
                    let pointsLabelRemoveAction = SKAction.removeFromParent()
                    let moveFadeAndRemoveSequence = SKAction.sequence([SKAction.group([pointsLabelMoveAction, pointsLabelFadeAction]), pointsLabelRemoveAction])
                    temporaryPointsLabel.run(moveFadeAndRemoveSequence)
                }
                
            }
            if nodeB.name == "WoodenObject" {
                let woodenObjectSpriteNode = nodeB as! SKSpriteNode
                let woodenObjectType = woodenObjectSpriteNode.userData?.value(forKey: "woodObjectType") as! String
                let woodenObjectHitPoints = woodenObjectSpriteNode.userData?.value(forKey: "hitPoints") as! Int
                woodenObjectSpriteNode.texture = SKTexture(imageNamed: "\(woodenObjectType)Broken")
                
                let dictionary:NSMutableDictionary! = woodenObjectSpriteNode.userData?.mutableCopy() as? NSMutableDictionary
                dictionary["hitPoints"] = woodenObjectHitPoints-1
                woodenObjectSpriteNode.userData = dictionary
                
                if woodenObjectHitPoints == 2 {
                    woodenObjectSpriteNode.texture = SKTexture(imageNamed: "\(woodenObjectType)Broken")
                } else if woodenObjectHitPoints == 1 {
                    woodenObjectSpriteNode.removeFromParent()
                    var addedScore = 0
                    switch woodenObjectType {
                    case "Square":
                        addedScore = 100
                    case "Triangle":
                        addedScore = 200
                    // rectangle
                    default:
                        addedScore = 250
                    }
                    gameViewModel!.score += addedScore
                    
                    pointsLabel.attributedText = NSAttributedString(string: "\(gameViewModel!.score)", attributes: [
                        NSAttributedString.Key.strokeWidth : -2.0,
                        NSAttributedString.Key.strokeColor : UIColor.black,
                        NSAttributedString.Key.foregroundColor : UIColor.white,
                        NSAttributedString.Key.font : UIFont(name: "ArialRoundedMTBold", size: 80.0)!
                    ])
                    
                    // animate points above judge's head
                    let temporaryPointsLabel = SKLabelNode(attributedText: NSAttributedString(string: "\(addedScore)", attributes: [
                        NSAttributedString.Key.strokeWidth : -2.0,
                        NSAttributedString.Key.strokeColor : UIColor.black,
                        NSAttributedString.Key.foregroundColor : UIColor.white,
                        NSAttributedString.Key.font : UIFont(name: "ArialRoundedMTBold", size: 80.0)!
                    ]))
                    temporaryPointsLabel.position = woodenObjectSpriteNode.position
                    temporaryPointsLabel.zPosition = 4
                    addChild(temporaryPointsLabel)
                    
                    let pointsLabelMoveAction = SKAction.moveTo(y: temporaryPointsLabel.position.y + frame.height/8, duration: 1.0)
                    let pointsLabelFadeAction = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
                    let pointsLabelRemoveAction = SKAction.removeFromParent()
                    let moveFadeAndRemoveSequence = SKAction.sequence([SKAction.group([pointsLabelMoveAction, pointsLabelFadeAction]), pointsLabelRemoveAction])
                    temporaryPointsLabel.run(moveFadeAndRemoveSequence)
                }
            }
            if nodeA.name == "Judge" {
                let judgeSpriteNode = nodeA as! SKSpriteNode
                let judgeHitPoints = judgeSpriteNode.userData?.value(forKey: "hitPoints") as! Int
                let dictionary:NSMutableDictionary! = judgeSpriteNode.userData?.mutableCopy() as? NSMutableDictionary
                dictionary["hitPoints"] = judgeHitPoints-1
                judgeSpriteNode.userData = dictionary
                
                if judgeHitPoints == 1 {
                    judgeSpriteNode.removeFromParent()
                    numJudgesLeft -= 1
                    gameViewModel!.score += 300
                    
                    pointsLabel.attributedText = NSAttributedString(string: "\(gameViewModel!.score)", attributes: [
                        NSAttributedString.Key.strokeWidth : -2.0,
                        NSAttributedString.Key.strokeColor : UIColor.black,
                        NSAttributedString.Key.foregroundColor : UIColor.white,
                        NSAttributedString.Key.font : UIFont(name: "ArialRoundedMTBold", size: 80.0)!
                    ])
                    
                    // animate points above judge's head
                    let temporaryPointsLabel = SKLabelNode(attributedText: NSAttributedString(string: "300", attributes: [
                        NSAttributedString.Key.strokeWidth : -2.0,
                        NSAttributedString.Key.strokeColor : UIColor.black,
                        NSAttributedString.Key.foregroundColor : UIColor.white,
                        NSAttributedString.Key.font : UIFont(name: "ArialRoundedMTBold", size: 80.0)!
                    ]))
                    temporaryPointsLabel.position = judgeSpriteNode.position
                    temporaryPointsLabel.zPosition = 4
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
                    gameViewModel!.score += 300
                    
                    pointsLabel.attributedText = NSAttributedString(string: "\(gameViewModel!.score)", attributes: [
                        NSAttributedString.Key.strokeWidth : -2.0,
                        NSAttributedString.Key.strokeColor : UIColor.black,
                        NSAttributedString.Key.foregroundColor : UIColor.white,
                        NSAttributedString.Key.font : UIFont(name: "ArialRoundedMTBold", size: 80.0)!
                    ])
                    
                    // animate points above judge's head
                    let temporaryPointsLabel = SKLabelNode(attributedText: NSAttributedString(string: "300", attributes: [
                        NSAttributedString.Key.strokeWidth : -2.0,
                        NSAttributedString.Key.strokeColor : UIColor.black,
                        NSAttributedString.Key.foregroundColor : UIColor.white,
                        NSAttributedString.Key.font : UIFont(name: "ArialRoundedMTBold", size: 80.0)!
                    ]))
                    temporaryPointsLabel.position = judgeSpriteNode.position
                    temporaryPointsLabel.zPosition = 4
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
        gameViewModel!.didBeatLevel = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let tapLocation = touch.location(in: self)
        let touchedNodes = self.nodes(at: tapLocation)
        
        for node in touchedNodes {
            if node == jumper {
                jumper.position = tapLocation
            }
        }
        
        if jumper.name == "YellowJumper" && isMoving {
            if !didPerformSpecialActionOnTap {
                didPerformSpecialActionOnTap = true
                let impulse = CGVector(dx: 4*(jumper.physicsBody?.velocity.dx)!, dy: 4*(jumper.physicsBody?.velocity.dy)!)
                
                jumper.physicsBody?.applyImpulse(impulse)
            }
        }
        
        if jumper.name == "BlueJumper" && isMoving {
            if !didPerformSpecialActionOnTap {
                didPerformSpecialActionOnTap = true
                
                blueJumper1.alpha = 1.0
                blueJumper1.position = CGPoint(x: jumper.position.x, y: jumper.position.y + frame.height/6)
                blueJumper1.physicsBody = SKPhysicsBody(rectangleOf: blueJumper1.size)
                blueJumper1.physicsBody?.affectedByGravity = true
                blueJumper1.physicsBody?.categoryBitMask = ColliderTypes.JumperCategory.rawValue
                blueJumper1.physicsBody?.collisionBitMask = ColliderTypes.GlobalCollisionBitMask.rawValue
                blueJumper1.physicsBody?.contactTestBitMask = ColliderTypes.WoodenObjectCategory.rawValue | ColliderTypes.JudgeCategory.rawValue | ColliderTypes.GroundCategory.rawValue
                
                blueJumper2.alpha = 1.0
                blueJumper2.position = CGPoint(x: jumper.position.x, y: jumper.position.y - frame.height/6)
                blueJumper2.physicsBody = SKPhysicsBody(rectangleOf: blueJumper2.size)
                blueJumper2.physicsBody?.affectedByGravity = true
                blueJumper2.physicsBody?.categoryBitMask = ColliderTypes.JumperCategory.rawValue
                blueJumper2.physicsBody?.collisionBitMask = ColliderTypes.GlobalCollisionBitMask.rawValue
                blueJumper2.physicsBody?.contactTestBitMask = ColliderTypes.WoodenObjectCategory.rawValue | ColliderTypes.JudgeCategory.rawValue | ColliderTypes.GroundCategory.rawValue
                
                blueJumper1.physicsBody?.applyAngularImpulse(-0.01)
                blueJumper2.physicsBody?.applyAngularImpulse(-0.01)
                blueJumper1.physicsBody?.applyImpulse(jumper.physicsBody!.velocity)
                blueJumper2.physicsBody?.applyImpulse(jumper.physicsBody!.velocity)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let tapLocation = touch.location(in: self)
        let touchedNodes = self.nodes(at: tapLocation)
        
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
                let dx = -(tapLocation.x - startPos.x)
                let dy = -(tapLocation.y - startPos.y)
                let impulse = CGVector(dx: 10*dx, dy: 10*dy)
                
                isMoving = true
                
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
            if currentBirdNum%3 == 0 {
                blueJumper1.removeFromParent()
                blueJumper2.removeFromParent()
            }
            jumper.physicsBody?.affectedByGravity = false
            jumper.physicsBody?.velocity = .zero
            jumper.physicsBody?.angularVelocity = 0
            jumper.position = startPos
            jumper.zRotation = 0
            jumper.texture = SKTexture(imageNamed: "Jump1")
            currentBirdNum += 1
            didPerformSpecialActionOnTap = false
            
            switch currentBirdNum%3 {
            case 1:
                jumper.name = "RedJumper"
                jumper.color = .red
                jumper.colorBlendFactor = 0.8
            case 2:
                jumper.name = "YellowJumper"
                jumper.color = .yellow
                jumper.colorBlendFactor = 0.8
            default:
                jumper.name = "BlueJumper"
                jumper.color = .blue
                jumper.colorBlendFactor = 0.8
            }
            
            isMoving = false
        }
    }
}
