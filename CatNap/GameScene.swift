//
//  GameScene.swift
//  CatNap
//
//  Created by LiLi Kazine on 2019/3/14.
//  Copyright © 2019 LiLi Kazine. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        // walk around a bug
        self.isPaused = true
        self.isPaused = false
        
//        if let bgNode = self.childNode(withName: "background") as? SKSpriteNode,
//        let bedNode = self.childNode(withName: "bed") as? SKSpriteNode,
//        let woodVert1 = self.childNode(withName: "wood_vert1") as? SKSpriteNode,
//        let woodVert2 = self.childNode(withName: "wood_vert2") as? SKSpriteNode,
//        let woodHori1 = self.childNode(withName: "wood_hori1") as? SKSpriteNode,
//        let woodHori2 = self.childNode(withName: "wood_hori2") as? SKSpriteNode,
//        let catShared = self.childNode(withName: "cat_shared") as? SKReferenceNode {
//            bgNode.texture = SKTexture(imageNamed: "background")
//            bedNode.texture = SKTexture(imageNamed: "cat_bed")
//            woodVert1.texture = SKTexture(imageNamed: "wood_vert1")
//            woodVert2.texture = SKTexture(imageNamed: "wood_vert1")
//            woodHori1.texture = SKTexture(imageNamed: "wood_horiz1")
//            woodHori2.texture = SKTexture(imageNamed: "wood_horiz1")
//            if let catBody = catShared.childNode(withName: "//cat_body") as? SKSpriteNode,
//            let catHead = catBody.childNode(withName: "cat_head") as? SKSpriteNode,
//            let catMouth = catHead.childNode(withName: "mouth") as? SKSpriteNode {
//                catMouth.texture = SKTexture(imageNamed: "cat_mouth")
//            }
//        }
//
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
