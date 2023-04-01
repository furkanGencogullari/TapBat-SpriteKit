//
//  GameScene.swift
//  TapBat
//
//  Created by Furkan Gençoğulları on 1.04.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var bat = SKSpriteNode()
    var batAnimation = SKAction()
    
    var sinceLastTouch: Double = 0
    var gameStarted = Bool()
    
    let backgroundSize = CGSize(width: 1920 * 1.4, height: 1080 * 1.4)
    
    
    var wallPair = SKNode()
    var moveAndRemoveWalls = SKAction()
    
    func setLayer(node: SKSpriteNode, name: String, zPosition: CGFloat, i: Int) {
        node.size = backgroundSize
        node.anchorPoint = CGPointZero
        node.position = CGPointMake(CGFloat(i) * node.frame.width, -100)
        node.name = name
        node.zPosition = zPosition
        self.addChild(node)
    }
    
    func moveBackground(movementSpeed: CGFloat, name: String) {
        enumerateChildNodes(withName: name) { node, error in
            let backgroundNode = node as! SKSpriteNode
            backgroundNode.position = CGPoint(x: backgroundNode.position.x - movementSpeed , y: backgroundNode.position.y)
            if backgroundNode.position.x <= -backgroundNode.size.width {
                backgroundNode.position = CGPointMake(backgroundNode.position.x + backgroundNode.size.width * 2, backgroundNode.position.y)
            }
        }
    }
    
    func createBackground() {
        for i in 0..<2 {
            let grass = SKSpriteNode(imageNamed: "bg1")
            setLayer(node: grass, name: "grass", zPosition: 9, i: i)
            grass.position = CGPoint(x: grass.position.x, y: grass.position.y + 370)
            
            let ground = SKSpriteNode(imageNamed: "bg2")
            setLayer(node: ground, name: "ground", zPosition: 8, i: i)
            
            let nearTrees = SKSpriteNode(imageNamed: "bg3")
            setLayer(node: nearTrees, name: "nearTrees", zPosition: 5, i: i)
            
            let midTrees = SKSpriteNode(imageNamed: "bg4")
            setLayer(node: midTrees, name: "midTrees", zPosition: 4, i: i)
            
            let farTrees = SKSpriteNode(imageNamed: "bg5")
            setLayer(node: farTrees, name: "farTrees", zPosition: 3, i: i)
            
            let stars = SKSpriteNode(imageNamed: "bg6")
            setLayer(node: stars, name: "stars", zPosition: 2, i: i)
            
            let moon = SKSpriteNode(imageNamed: "bg7")
            setLayer(node: moon, name: "moon", zPosition: 1, i: i)
        }
        
        let floorPhysicsNode = SKSpriteNode()
        floorPhysicsNode.size = CGSize(width: self.frame.width, height: 3)
        floorPhysicsNode.position = CGPoint(x: self.frame.width / 2, y: 120)
        self.addChild(floorPhysicsNode)
        
        floorPhysicsNode.physicsBody = SKPhysicsBody(rectangleOf: floorPhysicsNode.size)
        floorPhysicsNode.physicsBody?.affectedByGravity = false
        floorPhysicsNode.physicsBody?.isDynamic = false
        
    }
    
    func createBat() {
        bat = SKSpriteNode(imageNamed: "bat2")
        bat.size = CGSize(width: 70, height: 70)
        bat.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        bat.zPosition = 6
        self.addChild(bat)
        
        bat.physicsBody = SKPhysicsBody(circleOfRadius: bat.frame.height / 2.5)
        bat.physicsBody?.mass = 0.17
        bat.physicsBody?.affectedByGravity = false
        bat.physicsBody?.isDynamic = false
        
        //Bat Animation
        var batTextures: [SKTexture] = []
        batTextures.append(SKTexture(imageNamed: "bat1"))
        batTextures.append(SKTexture(imageNamed: "bat2"))
        batTextures.append(SKTexture(imageNamed: "bat3"))
        
        batAnimation = SKAction.animate(with: batTextures, timePerFrame: 0.1)
    }
    
    func createWalls() {
        let topWall = SKSpriteNode(imageNamed: "wall")
        let bottomWall = SKSpriteNode(imageNamed: "wall")
        
        topWall.position = CGPoint(x: self.frame.width - 50 , y: self.frame.height / 2 + 500)
        bottomWall.position = CGPoint(x: self.frame.width - 50 , y: self.frame.height / 2 - 500)
        
        topWall.size = CGSize(width: 60, height: 800)
        bottomWall.size = CGSize(width: 60, height: 800)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)

        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)

        bottomWall.physicsBody?.isDynamic = false
        bottomWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat(Double.pi)
        
        wallPair = SKNode()
        
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        
        let randomPosition = CGFloat.random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y + randomPosition
        wallPair.zPosition = 7
        
        wallPair.run(moveAndRemoveWalls)
        
        self.addChild(wallPair)
    }
    
    func moveWalls() {
        let spawnWalls = SKAction.run({
            () in
            self.createWalls()
        })
        
        let delay = SKAction.wait(forDuration: 1.1)
        
        let spawnDelay = SKAction.sequence([spawnWalls, delay])
        let spawnDelayForever = SKAction.repeatForever(spawnDelay)
        self.run(spawnDelayForever)
        
        let distance = CGFloat(self.frame.width + wallPair.frame.width)
        let moveWalls = SKAction.moveBy(x: -distance - 50, y: 0, duration: 0.004 * distance)
        let removeWalls = SKAction.removeFromParent()
        moveAndRemoveWalls = SKAction.sequence([moveWalls, removeWalls])
    }
    
    
    

    
    override func didMove(to view: SKView) {
        createBackground()
        createBat()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sinceLastTouch = 0
        
        if gameStarted == false {
            gameStarted = true
            
            moveWalls()
            
            bat.physicsBody?.affectedByGravity = true
            bat.physicsBody?.isDynamic = true
            

            let moveBat = SKAction.moveBy(x: -50, y: 0, duration: 0.5)
            
            bat.run(batAnimation)
            bat.run(moveBat)
            bat.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 80))
            bat.physicsBody?.applyAngularImpulse(0.02)
            
        } else {
            
            bat.run(batAnimation)
            bat.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 80))
            bat.physicsBody?.applyAngularImpulse(0.02)
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        //Bat Rotation
        sinceLastTouch += 0.1
        
        if sinceLastTouch > 1.0 {
            bat.physicsBody?.applyAngularImpulse(-0.01)
        }
        bat.zRotation.clamp(v1: CGFloat(20).degreesToRadians(), CGFloat(-90).degreesToRadians())
        bat.physicsBody?.angularVelocity.clamp(v1: -1, 3)
        
        //Bat Texture According to Rotation
        if bat.zRotation < -0.2 {
            bat.texture = SKTexture(imageNamed: "bat3")
        } else {
            bat.texture = SKTexture(imageNamed: "bat2")
        }
        
        
        moveBackground(movementSpeed: 5, name: "grass")
        moveBackground(movementSpeed: 5, name: "ground")
        moveBackground(movementSpeed: 4, name: "nearTrees")
        moveBackground(movementSpeed: 3, name: "midTrees")
        moveBackground(movementSpeed: 2, name: "farTrees")
        moveBackground(movementSpeed: 1.3, name: "stars")
        moveBackground(movementSpeed: 1, name: "moon")
        
    }
    
    

}
