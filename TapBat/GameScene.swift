//
//  GameScene.swift
//  TapBat
//
//  Created by Furkan Gençoğulları on 1.04.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let backgroundSize = CGSize(width: 1920 * 0.8, height: 1080 * 0.8)
    
    func setLayer(node: SKSpriteNode, name: String, zPosition: CGFloat, i: Int) {
        node.size = backgroundSize
        node.anchorPoint = CGPointZero
        node.position = CGPointMake(CGFloat(i) * node.frame.width, -100)
        node.name = name
        node.zPosition = zPosition
        self.addChild(node)
    }
    
    func createBackground() {
        for i in 0..<2 {
            let grass = SKSpriteNode(imageNamed: "bg1")
            setLayer(node: grass, name: "grass", zPosition: 7, i: i)
            grass.position = CGPoint(x: grass.position.x, y: grass.position.y + 220)
            
            let floor = SKSpriteNode(imageNamed: "bg2")
            setLayer(node: floor, name: "floor", zPosition: 6, i: i)
            
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
    }
    

    
    override func didMove(to view: SKView) {
        
        createBackground()

    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        moveBackground(movementSpeed: 5, name: "grass")
        moveBackground(movementSpeed: 5, name: "floor")
        moveBackground(movementSpeed: 4, name: "nearTrees")
        moveBackground(movementSpeed: 3, name: "midTrees")
        moveBackground(movementSpeed: 2, name: "farTrees")
        moveBackground(movementSpeed: 1, name: "stars")
        moveBackground(movementSpeed: 1, name: "moon")
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
    
    
}
