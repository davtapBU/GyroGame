//
//  GameScene.swift
//  GyroGame
//
//  Created by David Tapia on 10/21/21.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    var sprite = SKSpriteNode()
    var motionManager = CMMotionManager()
    var destX:CGFloat  = 0.0
    var destY:CGFloat  = 0.0
    
    override func didMove(to view: SKView) {
        // 1
        sprite = SKSpriteNode(imageNamed: "bulogo")
        sprite.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        sprite.setScale(0.20)
        self.addChild(sprite)

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
        sprite.run(actionX)
        sprite.run(actionY)
    }
}
