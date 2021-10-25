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
    var destY:CGFloat  = 0.0
    
    //Layers
    var foregroundNode : SKNode!
    
    //Scale factor
    var scaleFactor: CGFloat!
    
    //Player
    var player: SKNode!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = .white
        
        scaleFactor = self.size.width / 320.0
        
        //Foreground
        foregroundNode = SKNode()
        addChild(foregroundNode)
        
        //Add the player
        player = createPlayer()
        foregroundNode.addChild(player)
    }
    
    func createPlayer() -> SKNode {
        let playerNode = SKNode()
        playerNode.position = CGPoint(x: self.size.width / 2, y: 80.0)
        
        let sprite = SKSpriteNode(imageNamed: "bulogo")
        sprite.setScale(0.10)
        playerNode.addChild(sprite)
        
        return playerNode
    }
    
    override func didMove(to view: SKView) {
        

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
                let currentY = self.sprite.position.y
                self.destX = currentX + CGFloat(data.acceleration.x * 500)
                self.destY = currentY + CGFloat(data.acceleration.y * 500)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let actionX = SKAction.moveTo(x: destX, duration: 1)
        let actionY = SKAction.moveTo(y: destY, duration: 1)
       // sprite.run(actionX)
            //sprite.run(actionY)
    }
    
}

//Extension to the SpriteKit Physics body class to make ideal objects that have no friction
// or drag, and don't interact with the environment but can collide with other objects.
extension SKPhysicsBody {
    func ideal() -> SKPhysicsBody {
        self.friction = 0
        self.linearDamping = 0
        self.angularDamping = 0
        self.restitution = 0
        return self
    }
    
    func manualMovement() -> SKPhysicsBody {
        self.isDynamic = false
        self.allowsRotation = false
        self.affectedByGravity = false
        return self
    }
}
