//
//  GameScene.swift
//  TapBat
//
//  Created by Furkan Gençoğulları on 1.04.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let d = UserDefaults.standard
    
    var bat = SKSpriteNode()
    var batFlapAnimation = SKAction()
    
    var sinceLastTouch: Double = 0
    var gameStarted = Bool()
    var died = Bool()
    var score = 0
    var highscore = 0
    
    let scoreLabel = SKLabelNode()
    let highScoreLabel = SKLabelNode()
    var restartButton = SKSpriteNode()
    
    let backgroundSize = CGSize(width: 1920 * 1.4, height: 1080 * 1.4)
    
    var wallPair = SKNode()
    var moveAndRemoveWalls = SKAction()
    
    
    func restartGame() {
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        score = 0
        gameStarted = false
        scoreLabel.isHidden = true
        highScoreLabel.isHidden = false
        sinceLastTouch = 0
        startGame()
    }
    
    
    func getHighscore() {
        highscore = d.integer(forKey: "Score")
        highScoreLabel.text = "Highscore: \(highscore)"
    }
    
    
    func createScoreLabel() {
        scoreLabel.fontSize = 60
        scoreLabel.fontName = "Press Start 2P Regular"
        scoreLabel.fontColor = UIColor(red: 111/255, green: 49/255, blue: 152/255, alpha: 1)
        scoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 1.3)
        scoreLabel.zPosition = 8
        scoreLabel.isHidden = true
        self.addChild(scoreLabel)
    }
    
    
    func createRestartButton() {
        
        restartButton = SKSpriteNode(imageNamed: "restartButton")
        restartButton.size = CGSize(width: 627 / 1.5, height: 160 / 1.5)
        restartButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2.6)
        restartButton.zPosition = 8
        
        moveNodeUpAndDown(restartButton, by: 10, duration: 0.5)
        self.addChild(restartButton)
    }
    
    
    func createTitleLogo() {
        let tapBatLogo = SKSpriteNode(imageNamed: "tapBatLogo")
        tapBatLogo.size = CGSize(width: 690 / 1.5, height: 371 / 1.5)
        tapBatLogo.position = CGPoint(x: self.frame.width / 2 , y: self.frame.height / 1.5)
        tapBatLogo.zPosition = 8
        tapBatLogo.name = "logo"
        self.addChild(tapBatLogo)
        
        moveNodeUpAndDown(tapBatLogo, by: 15, duration: 1)
    }
    
    
    func createHighscoreLabel() {
        highScoreLabel.fontSize = 30
        highScoreLabel.fontName = "Press Start 2P Regular"
        highScoreLabel.fontColor = UIColor(red: 111/255, green: 49/255, blue: 152/255, alpha: 1)
        highScoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 9)
        highScoreLabel.zPosition = 10
        
        self.addChild(highScoreLabel)
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
    
    
    func setLayer(node: SKSpriteNode, name: String, zPosition: CGFloat, i: Int) {
        node.size = backgroundSize
        node.anchorPoint = CGPointZero
        node.position = CGPointMake(CGFloat(i) * node.frame.width, -100)
        node.name = name
        node.zPosition = zPosition
        self.addChild(node)
    }
    
    
    func moveBackground(movementSpeed: CGFloat, name: String, repeats: Bool) {
        enumerateChildNodes(withName: name) { node, error in
            let backgroundNode = node as! SKSpriteNode
            backgroundNode.position = CGPoint(x: backgroundNode.position.x - movementSpeed , y: backgroundNode.position.y)
            if repeats == true {
                if backgroundNode.position.x <= -backgroundNode.size.width {
                    backgroundNode.position = CGPointMake(backgroundNode.position.x + backgroundNode.size.width * 2, backgroundNode.position.y)
                }
            }
        }
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
        
        bat.physicsBody?.categoryBitMask = PhysicsCategoryConstants.bat
        bat.physicsBody?.collisionBitMask = PhysicsCategoryConstants.wall
        bat.physicsBody?.contactTestBitMask = PhysicsCategoryConstants.wall
        
        //Bat Animation
        var batTextures: [SKTexture] = []
        batTextures.append(SKTexture(imageNamed: "bat1"))
        batTextures.append(SKTexture(imageNamed: "bat2"))
        batTextures.append(SKTexture(imageNamed: "bat3"))
        
        batFlapAnimation = SKAction.animate(with: batTextures, timePerFrame: 0.1)
    }
    
    
    func createWalls() {
        let topWall = SKSpriteNode(imageNamed: "wall")
        let bottomWall = SKSpriteNode(imageNamed: "wall")
        let scoreNode = SKSpriteNode()
        
        topWall.position = CGPoint(x: self.frame.width - 50, y: self.frame.height / 2 + 500)
        bottomWall.position = CGPoint(x: self.frame.width - 50, y: self.frame.height / 2 - 500)
        scoreNode.position = CGPoint(x: self.frame.width - 50, y: self.frame.height / 2)
        
        topWall.size = CGSize(width: 60, height: 800)
        bottomWall.size = CGSize(width: 60, height: 800)
        scoreNode.size = CGSize(width: 20, height: 200)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
        bottomWall.physicsBody?.isDynamic = false
        bottomWall.physicsBody?.affectedByGravity = false
        
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        
        scoreNode.physicsBody?.categoryBitMask = PhysicsCategoryConstants.score
        scoreNode.physicsBody?.collisionBitMask = .zero
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCategoryConstants.bat
        
        topWall.physicsBody?.categoryBitMask = PhysicsCategoryConstants.wall
        topWall.physicsBody?.collisionBitMask = PhysicsCategoryConstants.bat
        topWall.physicsBody?.contactTestBitMask = PhysicsCategoryConstants.bat
        
        bottomWall.physicsBody?.categoryBitMask = PhysicsCategoryConstants.wall
        bottomWall.physicsBody?.collisionBitMask = PhysicsCategoryConstants.bat
        bottomWall.physicsBody?.contactTestBitMask = PhysicsCategoryConstants.bat
        
        topWall.zRotation = CGFloat(Double.pi)
        
        wallPair = SKNode()
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        wallPair.addChild(scoreNode)
        
        let randomPosition = CGFloat.random(min: -190, max: 190)
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
    
    
    func moveNodeUpAndDown(_ node: SKSpriteNode ,by i: Double, duration: Double) {
        let moveUp = SKAction.moveBy(x: 0, y: i, duration: duration)
        let moveDown = SKAction.moveBy(x: 0, y: -i, duration: duration)
        let sequence = SKAction.sequence([moveUp, moveDown])
        let foreverSeq = SKAction.repeatForever(sequence)
        node.run(foreverSeq)
    }
    
    
    func startGame() {
        createBackground()
        createBat()
        createScoreLabel()
        createTitleLogo()
        getHighscore()
        createHighscoreLabel()
        
        self.physicsWorld.contactDelegate = self
    }
    
    
    override func didMove(to view: SKView) {
        startGame()
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCategoryConstants.bat
            && secondBody.categoryBitMask == PhysicsCategoryConstants.wall
            || firstBody.categoryBitMask == PhysicsCategoryConstants.wall
            && secondBody.categoryBitMask == PhysicsCategoryConstants.bat {
            
            if died == false {
                died = true
                createRestartButton()
                if score > highscore {
                    d.set(score, forKey: "Score")
                }
            }
        }
        
        if firstBody.categoryBitMask == PhysicsCategoryConstants.bat
            && secondBody.categoryBitMask == PhysicsCategoryConstants.score
            || firstBody.categoryBitMask == PhysicsCategoryConstants.score
            && secondBody.categoryBitMask == PhysicsCategoryConstants.bat {
            
            score += 1
            scoreLabel.isHidden = false
            scoreLabel.text = "\(score)"
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sinceLastTouch = 0
        
        if gameStarted == false {
            gameStarted = true
            died = false
            
            moveWalls()
            
            bat.physicsBody?.affectedByGravity = true
            bat.physicsBody?.isDynamic = true
            
            let moveBat = SKAction.moveBy(x: -100, y: 0, duration: 0.5)
            
            bat.run(batFlapAnimation)
            bat.run(moveBat)
            bat.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 80))
            bat.physicsBody?.applyAngularImpulse(0.02)
            
        } else {
            if died == false {
                
                bat.run(batFlapAnimation)
                bat.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 80))
                bat.physicsBody?.applyAngularImpulse(0.02)
            }
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            if died == true {
                if restartButton.contains(location) == true {
                    restartGame()
                }
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        sinceLastTouch += 0.1
        
        //Bat Rotation
        if sinceLastTouch > 1.0 {
            bat.physicsBody?.applyAngularImpulse(-0.01)
        }
        
        bat.zRotation.clamp(v1: CGFloat(20).degreesToRadians(), CGFloat(-90).degreesToRadians())
        bat.physicsBody?.angularVelocity.clamp(v1: -1, 3)
        
        //Bat's Texture for Rotation
        if bat.zRotation < -0.2 {
            bat.texture = SKTexture(imageNamed: "bat3")
        } else {
            bat.texture = SKTexture(imageNamed: "bat2")
        }
        
        moveBackground(movementSpeed: 5, name: "grass", repeats: true)
        moveBackground(movementSpeed: 5, name: "ground", repeats: true)
        moveBackground(movementSpeed: 4, name: "nearTrees", repeats: true)
        moveBackground(movementSpeed: 3, name: "midTrees", repeats: true)
        moveBackground(movementSpeed: 2, name: "farTrees", repeats: true)
        moveBackground(movementSpeed: 1.3, name: "stars", repeats: true)
        moveBackground(movementSpeed: 1, name: "moon", repeats: true)
        
        if gameStarted == true {
            moveBackground(movementSpeed: 5, name: "logo", repeats: false)
            highScoreLabel.isHidden = true
        }
    }
    
}
