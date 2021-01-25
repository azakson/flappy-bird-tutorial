//
//  GameScene.swift
//  Hack and Share
//
//  Created by Avery Zakson on 10/2/20.
//  Copyright © 2020 Avery Zakson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ground = SKSpriteNode()
    var background = SKSpriteNode()
    var player = SKSpriteNode()
    var startGame = false
    var scoreLabel = SKLabelNode()
    var score = 0
    
    
    
    
    override func didMove(to view: SKView) {
        createScene()
        spawnWalls()
        createScore()
        physicsWorld.contactDelegate = self
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gamePlay()
        startGame = true
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node?.name == "scoreZone" || contact.bodyB.node?.name == "scoreZone" {
            score += 1
            scoreLabel.text = "\(score)"
        } else if contact.bodyA.node?.name == "top" || contact.bodyB.node?.name == "top" {
            
            resetGame()
            
        } else if  contact.bodyA.node?.name == "bottom" || contact.bodyB.node?.name == "bottom" {
            
            resetGame()
            
        } else if  contact.bodyA.node?.name == "ground" || contact.bodyB.node?.name == "ground" {
            
            resetGame()
            
        }
    }
    
    func createWalls() {
        let pipeTexture = SKTexture(imageNamed: "PipeUp")
        
        let topPipe = SKSpriteNode(texture: pipeTexture, size: CGSize(width: 75, height: 600))
        topPipe.physicsBody = SKPhysicsBody(texture: pipeTexture, size: topPipe.size)
        topPipe.name = "top"
        topPipe.zPosition = 3
        topPipe.physicsBody?.isDynamic = false
        topPipe.zRotation = .pi
        topPipe.physicsBody?.categoryBitMask = 2
        topPipe.physicsBody?.contactTestBitMask = 1
        
        let bottomPipe = SKSpriteNode(texture: pipeTexture, size: CGSize(width: 75, height: 600))
        bottomPipe.physicsBody = SKPhysicsBody(texture: pipeTexture, size: bottomPipe.size)
        bottomPipe.name = "top"
        bottomPipe.zPosition = 3
        bottomPipe.physicsBody?.isDynamic = false
        bottomPipe.physicsBody?.categoryBitMask = 2
        bottomPipe.physicsBody?.contactTestBitMask = 1
        
        let scoreZone = SKSpriteNode(color: .clear, size: CGSize(width: 64, height: 1500))
        scoreZone.physicsBody = SKPhysicsBody(rectangleOf: scoreZone.size)
        scoreZone.name = "scoreZone"
        scoreZone.zPosition = 3
        scoreZone.physicsBody?.isDynamic = false
        scoreZone.physicsBody?.categoryBitMask = 8
        scoreZone.physicsBody?.contactTestBitMask  = 1
        
        addChild(topPipe)
        addChild(bottomPipe)
        addChild(scoreZone)
        
        let xPosition = frame.width + topPipe.frame.width
        
        let yPosition = CGFloat.random(in: -500...(-105))
        
        let pipeDistance: CGFloat = 100
        
        topPipe.position = CGPoint(x: xPosition, y: yPosition + topPipe.size.height + pipeDistance)
        bottomPipe.position = CGPoint(x: xPosition, y: yPosition - pipeDistance)
        scoreZone.position = CGPoint(x: xPosition + (scoreZone.size.width * 1.5), y: frame.midY)
        
        let endPosition = frame.width + (topPipe.frame.width * 6)
        
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6.2)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        topPipe.run(moveSequence)
        bottomPipe.run(moveSequence)
        scoreZone.run(moveSequence)
    }
    
    
    func spawnWalls() {
        
        let create = SKAction.run { [unowned self] in
            self.createWalls()
        }
        
        let wait = SKAction.wait(forDuration: 2.5)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)
    }
    
    
    func createScene(){
        
        player = SKSpriteNode(imageNamed: "bird")
        player.position = CGPoint(x: frame.midX - 50, y: 0)
        player.size = CGSize(width: 80, height: 80)
        player.name = "player"
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.collisionBitMask = 7
        
        self.addChild(player)
        player.zPosition = 5
        
        ground = SKSpriteNode(imageNamed: "floor")
        ground.position = CGPoint(x: 0, y: frame.height / -2.25)
        ground.size = CGSize(width: 580, height: 130)
        ground.name = "ground"
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = 4
        ground.physicsBody?.contactTestBitMask = 1
        
        self.addChild(ground)
        ground.zPosition = 4
        
        
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y: 45)
        background.size = CGSize(width: 560, height: 1000)
        self.addChild(background)
        background.zPosition = 0
    }
    
    func gamePlay() {
        if startGame == true {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
            player.physicsBody?.affectedByGravity = true
        }
    }
    
    func resetGame() {
        self.removeAllChildren()
        createScene()
        createScore()
        score = 0
        scoreLabel.text = "\(score)"
    }
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Marker Felt")
        scoreLabel.fontSize = 50
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 100)
        scoreLabel.text = "\(score)"
        scoreLabel.fontColor = UIColor.black
        scoreLabel.zPosition = 6
        
        addChild(scoreLabel)
    }
}


