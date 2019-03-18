//
//  DiscoBallNode.swift
//  CatNap
//
//  Created by LiLi Kazine on 2019/3/18.
//  Copyright © 2019 LiLi Kazine. All rights reserved.
//

import SpriteKit
import AVFoundation

class DiscoBallNode: SKSpriteNode, EventListenerNode, InteractiveNode {
    
    static private(set) var isDiscoTime = false

    private var player: AVPlayer!
    private var video: SKVideoNode!
    
    private var isDiscoTime: Bool = false {
        didSet {
            video.isHidden = !isDiscoTime
            if isDiscoTime {
                video.play()
                run(spinAction)
            } else {
                video.pause()
                removeAllActions()
            }
            SKTAudio.sharedInstance().playBackgroundMusic(isDiscoTime ? "disco-sound.m4a" : "backgroundMusic.mp3")
            if isDiscoTime {
                video.run(SKAction.wait(forDuration: 5.0)) {
                    self.isDiscoTime = false
                }
            }
            DiscoBallNode.isDiscoTime = isDiscoTime
        }
    }
    
    private let spinAction = SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "discoball1"), SKTexture(imageNamed: "discoball2"), SKTexture(imageNamed: "discoball3")], timePerFrame: 0.2))
    
    func didMoveToScene() {
        isUserInteractionEnabled = true
        let fileUrl = Bundle.main.url(forResource: "discolights-loop", withExtension: "mov")!
        player = AVPlayer(url: fileUrl)
        video = SKVideoNode(avPlayer: player)
        
        video.size = scene!.size
        video.position = CGPoint(x: scene!.frame.midX, y: scene!.frame.midY)
        video.zPosition = -1
        scene!.addChild(video)
        
        video.alpha = 0.75
        video.isHidden = true
        video.pause()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReachEndOfVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func interact() {
        if !isDiscoTime {
            isDiscoTime = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
    
    @objc func didReachEndOfVideo() {
        print("rewind!")
        player.currentItem!.seek(to: .zero) { [weak self] _ in
            self?.player.play()
        }
    }
    
}
