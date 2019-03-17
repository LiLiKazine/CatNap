//
//  MessageNode.swift
//  CatNap
//
//  Created by LiLi Kazine on 2019/3/17.
//  Copyright © 2019 LiLi Kazine. All rights reserved.
//

import SpriteKit

class MessageNode: SKLabelNode {
    
    var count = 0
    

    convenience init(message: String) {
        self.init(fontNamed: "AvenirNext-Regular")
        
        text = message
        fontSize = 256.0
        fontColor = SKColor.gray
        zPosition = 100
        
        let front = SKLabelNode(fontNamed: "AvenirNext-Regular")
        front.text = message
        front.fontSize = 256.0
        front.fontColor = SKColor.white
        front.position = CGPoint(x: -2, y: -2)
        addChild(front)
        
        physicsBody = SKPhysicsBody(circleOfRadius: 10)
        physicsBody!.collisionBitMask = PhysicsCategory.Edge
        physicsBody!.categoryBitMask = PhysicsCategory.Label
        physicsBody!.restitution = 0.7
        
        physicsBody!.contactTestBitMask = PhysicsCategory.Edge
    }
    
    func didBounce() {
        count += 1
        if count == 4 {
            self.removeFromParent()
        }
    }
    
}
