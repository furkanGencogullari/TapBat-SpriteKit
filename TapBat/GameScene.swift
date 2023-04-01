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
    
    let backgroundSize = CGSize(width: 1920 * 0.8, height: 1080 * 0.8)
    
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
            setLayer(node: grass, name: "grass", zPosition: 8, i: i)
            grass.position = CGPoint(x: grass.position.x, y: grass.position.y + 220)
            
            let floor = SKSpriteNode(imageNamed: "bg2")
            setLayer(node: floor, name: "floor", zPosition: 7, i: i)
            
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
        bat.position = CGPoint(x: self.frame.width / 2 - bat.frame.width, y: self.frame.height / 2)
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
        
        bat.physicsBody?.affectedByGravity = true
        bat.physicsBody?.isDynamic = true
        bat.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        
        bat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 80))
        bat.physicsBody?.applyAngularImpulse(0.02)
        
        bat.run(batAnimation)
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
        moveBackground(movementSpeed: 5, name: "floor")
        moveBackground(movementSpeed: 4, name: "nearTrees")
        moveBackground(movementSpeed: 3, name: "midTrees")
        moveBackground(movementSpeed: 2, name: "farTrees")
        moveBackground(movementSpeed: 1, name: "stars")
        moveBackground(movementSpeed: 1, name: "moon")
        
    }
    
    

}
