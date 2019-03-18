//
//  GameScene.swift
//  CatNap
//
//  Created by LiLi Kazine on 2019/3/14.
//  Copyright © 2019 LiLi Kazine. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol EventListenerNode {
    func didMoveToScene()
}

struct PhysicsCategory {
    static let None:    UInt32 = 0
    static let Cat:     UInt32 = 0b1 //1
    static let Block:   UInt32 = 0b10  //2
    static let Bed:     UInt32 = 0b100  //4
    static let Edge:    UInt32 = 0b1000  //8
    static let Label:   UInt32 = 0b10000  //16
    static let Spring:  UInt32 = 0b100000  //32
    static let Hook:    UInt32 = 0b1000000  //64
}

protocol InteractiveNode {
    func interact()
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bedNode: BedNode!
    var catNode: CatNode!
    var message: MessageNode!
    var hookBaseNode: HookBaseNode?
    var currentLevel: Int = 0
    
    var playable = true
    
    override func didMove(to view: SKView) {
        
        bedNode = childNode(withName: "bed") as? BedNode
        catNode = childNode(withName: "//cat_body") as? CatNode
        
        // walk around a bug
        self.isPaused = true
        self.isPaused = false
        
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        // 2.16
        let maxAspectRatioHeight =  size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight) / 2
        let playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height - playableMargin * 2)
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        
        enumerateChildNodes(withName: "//*") { node, _ in
            if let eventListenerNode = node as? EventListenerNode {
                eventListenerNode.didMoveToScene()
            }
        }
        
        hookBaseNode = childNode(withName: "hookBase") as? HookBaseNode
        
//        SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
    }
    
    override func didSimulatePhysics() {
        if playable && hookBaseNode?.isHooked != true {
            if abs(catNode.parent!.zRotation) > CGFloat(25).degreesToRadians() {
                lose()
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        if collision == PhysicsCategory.Label | PhysicsCategory.Edge {
            message.didBounce()
        }
        if collision == PhysicsCategory.Cat | PhysicsCategory.Hook && hookBaseNode?.isHooked == false {
            hookBaseNode!.hookCat(catPhysicsBody: catNode.parent!.physicsBody!)
        }
        if !playable {
            return
        }
        if collision == PhysicsCategory.Cat | PhysicsCategory.Bed {
            print("SUCCESS")
            win()
        } else if collision == PhysicsCategory.Cat | PhysicsCategory.Edge {
            print("Fail")
            lose()
        }
    }
    
    func inGameMessage(text: String) {
        message = MessageNode(message: text)
        message.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(message)
    }
    
    func newGame() {
        let scene = GameScene.level(levelNum: currentLevel)
        view!.presentScene(scene)
    }
    
    func lose() {
        if currentLevel > 1 {
            currentLevel -= 1
        }
        playable = false
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("lose.mp3")
        
        inGameMessage(text: "Try again...")
        run(SKAction.afterDelay(5, runBlock: newGame))
        catNode.wakeUp()
    }
    func win() {
        if currentLevel < 3 {
            currentLevel += 1
        }
        playable = false
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("win.mp3")
        
        inGameMessage(text: "Nice job!")
        run(SKAction.afterDelay(3, runBlock: newGame))
        catNode.curlAt(scenePoint: bedNode.position)
    }
    
    class func level(levelNum: Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Level\(levelNum)")!
        scene.currentLevel = levelNum
        scene.scaleMode = .aspectFill
        return scene
    }
 
}
