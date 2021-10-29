//
//  GameScene.swift
//  GyroGame
//
//  Created by David Tapia on 10/21/21.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    var sprite = SKSpriteNode()
    var motionManager = CMMotionManager()
    var destX:CGFloat  = 0.0
    
    //Layers
    var foregroundNode : SKNode!
    
    //Scale factor
    var scaleFactor: CGFloat!
    
    //Player/Objects
    var player: SKNode!
    var pallet: SKNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        //Add gravity
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        physicsWorld.contactDelegate = self
        
        scaleFactor = self.size.width / 320.0
        
        //Foreground
        foregroundNode = SKNode()
        addChild(foregroundNode)
        
        //Add the player
        player = createPlayer()
        foregroundNode.addChild(player)
        
        //Add the pallet
        pallet = createPallet()
        foregroundNode.addChild(pallet)

        if motionManager.isAccelerometerAvailable {
            // 2
            motionManager.accelerometerUpdateInterval = 0.01
            motionManager.startAccelerometerUpdates(to: .main) {
                (data, error) in
                guard let data = data, error == nil else {
                    return
                }

                // 3
                let currentX = self.sprite.position.x
                self.destX = currentX + CGFloat(data.acceleration.x * 500)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //Cause haptic feedback upon impact of 2 objects
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    func createPlayer() -> SKNode {
        let playerNode = SKNode()
        playerNode.position = CGPoint(x: self.size.width / 2, y: self.size.height/2)
        
        let sprite = SKSpriteNode(imageNamed: "bulogo")
        sprite.setScale(0.15)
        playerNode.addChild(sprite)
        
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        playerNode.physicsBody?.contactTestBitMask = 1
        playerNode.physicsBody?.isDynamic = true
        playerNode.physicsBody?.allowsRotation = true
        playerNode.physicsBody?.restitution = 1.0
        playerNode.physicsBody?.friction = 0.0
        playerNode.physicsBody?.angularDamping = 0.0
        playerNode.physicsBody?.linearDamping = 0.0
        
        return playerNode
    }
    
    func createPallet() -> SKNode {
        let palletNode = SKNode()
        palletNode.position = CGPoint(x: self.size.width / 2, y: 80.0)
        
        let sprite = SKSpriteNode(imageNamed: "Platform")
        sprite.setScale(2.00)
        palletNode.addChild(sprite)
        
        palletNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width, height: sprite.size.height))
        palletNode.physicsBody?.isDynamic = false
        palletNode.physicsBody?.allowsRotation = false
        palletNode.physicsBody?.restitution = 1.0
        palletNode.physicsBody?.friction = 0.0
        palletNode.physicsBody?.angularDamping = 0.0
        palletNode.physicsBody?.linearDamping = 0.0
        
        palletNode.physicsBody?.contactTestBitMask = 1
        
        return palletNode
    }
    
    override func update(_ currentTime: TimeInterval) {
        //Move the player and pallet in the direction of the gyroscope
        let actionX = SKAction.moveTo(x: destX, duration: 1)
        player.run(actionX)
        pallet.run(actionX)
    }
    
}
