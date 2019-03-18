//
//  BedNode.swift
//  CatNap
//
//  Created by LiLi Kazine on 2019/3/15.
//  Copyright © 2019 LiLi Kazine. All rights reserved.
//

import SpriteKit

class BedNode: SKSpriteNode, EventListenerNode {

    func didMoveToScene() {
        print("bed added to scene")
        
        let bedBodySize = CGSize(width: 40.0, height: 30.0)
        physicsBody = SKPhysicsBody(rectangleOf: bedBodySize)
        physicsBody!.isDynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.Bed
        physicsBody!.collisionBitMask = PhysicsCategory.None
    }
    
    
    
}


