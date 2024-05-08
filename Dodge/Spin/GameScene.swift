//
//  GameScene.swift
//  Luga
//
//  Created by Murray Buchanan on 28/06/2020.
//  Copyright © 2020 Murray Buchanan. All rights reserved.
//

// MARK: WKInterfaceSKScene
// For WatchOS use WKInterfaceSKScene instead of SKView if using SpriteKit

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Constants
    private let HIGHSCORE_KEY = "highScoreSaved"
    private let TOTALSCORE_KEY = "totalScoreSaved"
    
    // Lobby HUD
    private let gameNameLabel = SKLabelNode(fontNamed: "Astro Space")
    private let scoreLabel = SKLabelNode()
    private let totalScoreLabel = SKLabelNode()
    private let highScoreLabel = SKLabelNode()
    private let shopIcon = SKShapeNode()
    
    // Objects
    private let player = SKShapeNode(circleOfRadius: 40)
    private let playerSize: CGFloat = 40
    private let margin: CGFloat = 40
    
    // Game attributes
    private var score: Int
    private var totalScore = Int()
    private var gameArea: CGRect
    private var border: SKPhysicsBody = SKPhysicsBody()
    private var moveleft: Bool = false
    private var moveright: Bool = false
    private var isGameOver: Bool
    
    // Physics categories
    struct PhysicsCategories {
        static let player: UInt32 = UInt32.init(1)
        static let enemy: UInt32 = UInt32.init(2)
        static let point: UInt32 = UInt32.init(3)
    }
    
    // Playable area
    override init(size: CGSize) {
        self.score = 0
        self.isGameOver = true
        gameArea = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        super.init(size: size)
        border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0.2
        border.restitution = 0.4
        self.physicsBody = border
        self.physicsWorld.contactDelegate = self
        player.position = CGPoint(x: gameArea.midX, y: gameArea.midY - (playerSize * 1.5))
        createScoreLabel()
        createLobbyLabel()
        spawnPlayer()
        spawnEnemy()
        
        backgroundColor = SKColor.systemBackground
    }
    
    // Runs the required actions for game
    func startGame() {
        self.score = 0
        self.isGameOver = false
        scoreLabel.text = "score: \(0)"
        makeLobbyHidden(to: true)
        player.physicsBody!.affectedByGravity = true
        scoreLabel.position = CGPoint(x: gameArea.maxX - margin, y: gameArea.maxY - margin)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
    }
    
    // Score label
    func createScoreLabel() {
        scoreLabel.text = "score: \(0)"
        scoreLabel.fontSize = 23
        scoreLabel.fontName = "Helvetica Neue"
        scoreLabel.fontColor = SKColor.label
        scoreLabel.zPosition = 1
        scoreLabel.isHidden = true
        self.addChild(scoreLabel)
    }
    
    // Adds score to score label
    func addScore() {
        self.score += 1
        scoreLabel.text = "score: \(self.score)"
    }
    
    // Homescreen labels
    func createLobbyLabel() {
        // Title label
        gameNameLabel.text = "LUGA"
        gameNameLabel.fontSize = 75
        gameNameLabel.fontColor = SKColor.label
        gameNameLabel.position = CGPoint(x: gameArea.maxX / 2, y: gameArea.maxY / 1.75)
        gameNameLabel.zPosition = 1
        gameNameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.addChild(gameNameLabel)
        
        // Fetch highscore & totalscore
        updateLobbyLabels()
        
        // HighScore label
        highScoreLabel.fontSize = 23
        highScoreLabel.fontName = "Helvetica Neue"
        highScoreLabel.position = CGPoint(x: gameArea.midX, y: gameNameLabel.position.y - margin)
        highScoreLabel.fontColor = SKColor.secondaryLabel
        highScoreLabel.zPosition = 1
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.addChild(highScoreLabel)
        
        // TotalScore label
        totalScoreLabel.fontSize = 23
        totalScoreLabel.fontName = "Helvetica Neue"
        totalScoreLabel.fontColor = SKColor.secondaryLabel
        totalScoreLabel.position = CGPoint(x: gameArea.minX + margin, y: gameArea.maxY - margin)
        totalScoreLabel.zPosition = 1
        totalScoreLabel.isHidden = true
        totalScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.addChild(totalScoreLabel)
        }
    
    func updateLobbyLabels() {
        // Fetching highscore & totalscore
        let userDefaults = UserDefaults()
        let highScore = userDefaults.integer(forKey: HIGHSCORE_KEY)
        let totalScore = userDefaults.integer(forKey: TOTALSCORE_KEY)
        
        // Updating highscore & totalscore labels
        highScoreLabel.text = "high score: \(highScore)"
        totalScoreLabel.text = "coins: \(totalScore)"
    }
    
    func makeLobbyHidden(to: Bool) {
        gameNameLabel.isHidden = to
        highScoreLabel.isHidden = to
        totalScoreLabel.isHidden = true
        if !isGameOver || score >= 0 {
            scoreLabel.isHidden = false
        }
    }
    
    // MARK: Player initialisation
    func spawnPlayer() {
        player.name = "Player"
        player.fillColor = SKColor.systemCyan
        player.lineWidth = 0
        player.zPosition = 4
        player.physicsBody = SKPhysicsBody(circleOfRadius: playerSize)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.isDynamic = true
        player.physicsBody!.allowsRotation = true
        player.physicsBody!.categoryBitMask = PhysicsCategories.player
        player.physicsBody!.collisionBitMask = PhysicsCategories.player
        player.physicsBody!.contactTestBitMask = PhysicsCategories.point | PhysicsCategories.enemy
        
        let resetposition = CGPoint(x: gameArea.midX, y: gameArea.midY - (playerSize * 1.5))
        if isGameOver {
            let movePlayer = SKAction.move(to: resetposition, duration: 1.0)
            player.run(movePlayer)
        }
        self.addChild(player)
        
        let trail = SKEmitterNode(fileNamed: "trail.sks")
        trail?.particleSize = player.frame.size
        trail?.particleSpeed = 150
        trail?.particleBirthRate = 200
        trail?.particleLifetime = 1
        trail?.particleZPosition = 0
        trail?.particleLifetime = 0.1
        trail?.particleAlpha = 1
        trail!.targetNode = self
        player.addChild(trail!)
    }
    
    
    // Random generator
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 4294967296)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func spawnEnemy() {
        func createEnemy() {
            //Enemy shape
            let triangle = UIBezierPath()
            triangle.move(to: CGPoint(x: 0.0, y: 0.0))
            triangle.addLine(to: CGPoint(x: -20.0, y: 32.5))
            triangle.addLine(to: CGPoint(x: 20, y: 32.5))
            triangle.addLine(to: CGPoint(x: 0.0, y: 0.0))
            
            // MARK: Enemy initialisation
            let enemy = SKShapeNode(path: triangle.cgPath)
            enemy.name = "Enemy"
            enemy.path = triangle.cgPath
            enemy.lineWidth = 0
            if Int.random(in: 0...1) == 0 {
                enemy.fillColor = SKColor.systemRed
            } else {
                enemy.fillColor = SKColor.systemOrange
            }
            enemy.physicsBody = SKPhysicsBody(polygonFrom: triangle.cgPath)
            enemy.physicsBody!.affectedByGravity = false
            enemy.physicsBody!.categoryBitMask = PhysicsCategories.enemy
            enemy.physicsBody!.collisionBitMask = PhysicsCategories.enemy
            enemy.physicsBody!.contactTestBitMask = PhysicsCategories.player
            
            // Enemy x-position
            let minposition = gameArea.minX + enemy.frame.width
            let maxposition = gameArea.maxX - enemy.frame.width
            var randomXposition: CGFloat
            if isGameOver {
                if Int.random(in: 0...1) == 0 {
                    randomXposition = random(min: minposition, max: (gameArea.maxX / 2) - player.frame.width - enemy.frame.width)
                } else {
                    randomXposition = random(min: (gameArea.maxX / 2) + player.frame.width + enemy.frame.width, max: maxposition)
                }
            } else {
                randomXposition = random(min: minposition, max: maxposition)
            }
            
            // Enemy y-position
            let startPosition = CGPoint(x: randomXposition, y: gameArea.maxY + enemy.frame.height)
            enemy.position = startPosition
            let endPosition = CGPoint(x: randomXposition, y: gameArea.minY - enemy.frame.height * 2)
            let moveEnemy = SKAction.move(to: endPosition, duration: 1)
            let waitToDelete = SKAction.wait(forDuration: 0)
            let deleteEnemy = SKAction.removeFromParent()
            let enemySequence = SKAction.sequence([moveEnemy, waitToDelete, deleteEnemy])
            enemy.run(enemySequence)
            self.addChild(enemy)
        }
        
        // Enemy sequence
        let spawnObject = SKAction.run(createEnemy)
        let waitToSpawn = SKAction.wait(forDuration: 1)
        let spawnSequence = SKAction.sequence([waitToSpawn,spawnObject])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
        if self.action(forKey: "spawningEnemies") != nil {
            self.removeAction(forKey: "spawningPoint")
        }
    }
    
    /// Creates a death animation when the enemy collides with the player .
    private func spawnDeathAnimation(x: CGFloat) {
        //Enemy shape
        let triangle = UIBezierPath()
        triangle.move(to: CGPoint(x: 0.0, y: 0.0))
        triangle.addLine(to: CGPoint(x: -20.0, y: 32.5))
        triangle.addLine(to: CGPoint(x: 20, y: 32.5))
        triangle.addLine(to: CGPoint(x: 0.0, y: 0.0))
        
        let deathAnimation = SKShapeNode(path: triangle.cgPath)
        
        deathAnimation.fillColor = SKColor.systemYellow
        deathAnimation.lineWidth = 0
        deathAnimation.position = CGPoint(x: x, y: gameArea.minX)
        deathAnimation.zPosition = 1
        self.addChild(deathAnimation)

        let scaleIn = SKAction.scale(to: 0, duration: 0.1)
        let delete = SKAction.removeFromParent()

        let deathAnimationSequence = SKAction.sequence([scaleIn, delete])
        deathAnimation.run(deathAnimationSequence)
    }
    
    // MARK: Point initialisation
    func spawnPoint(x: CGFloat) {
        let point = SKShapeNode(circleOfRadius: 13)
        point.name = "Point"
        point.fillColor = SKColor.systemYellow
        point.lineWidth = 0
        point.zPosition = 3
        point.physicsBody = SKPhysicsBody(circleOfRadius: 13)
        point.physicsBody!.isDynamic = true
        point.physicsBody!.affectedByGravity = false
        point.physicsBody!.categoryBitMask = PhysicsCategories.point
        point.physicsBody!.collisionBitMask = PhysicsCategories.player
        point.physicsBody!.contactTestBitMask = PhysicsCategories.player
        
        // Point x-position
        let startPoint = CGPoint(x: x, y: gameArea.minY + playerSize)
        point.position = startPoint
        self.addChild(point)
    }
    
    // Inputting clicks and player movement
    func touchDown(_ position: CGPoint) {
        let halfScreenWidth = self.frame.size.width / 2
        if position.x <= halfScreenWidth {
            moveleft = true
        } else {
            moveright = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in: self)
            if !isGameOver && position.x > 0 {
                touchDown(position)
            } else {
            startGame()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameOver {
            moveleft = false
            moveright = false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !isGameOver {
            let FORCE_VALUE = 250
            if moveleft {
                player.physicsBody?.applyForce(CGVector(dx: -FORCE_VALUE, dy: 0), at: player.position)
            } else if moveright {
                player.physicsBody?.applyForce(CGVector(dx: FORCE_VALUE, dy: 0), at: player.position)
            }
        }
    }
    
    // MARK: Collisions between objects
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if !isGameOver {
            
            // Collision between point and player
            if (body1.categoryBitMask == PhysicsCategories.point && body2.categoryBitMask == PhysicsCategories.player)
                || (body2.categoryBitMask == PhysicsCategories.player && body1.categoryBitMask == PhysicsCategories.point){
                addScore()
                body1.node!.removeFromParent()
            } else if (body1.categoryBitMask == PhysicsCategories.player && body2.categoryBitMask == PhysicsCategories.point)
                        || (body2.categoryBitMask == PhysicsCategories.point && body1.categoryBitMask == PhysicsCategories.player){
                addScore()
                body2.node!.removeFromParent()
            }
            
            //Collision between two points
            else if (body1.categoryBitMask == PhysicsCategories.point && body2.categoryBitMask == PhysicsCategories.point)
                                || (body2.categoryBitMask == PhysicsCategories.point && body1.categoryBitMask == PhysicsCategories.point){
                body1.node?.removeFromParent()
            }
            
            // Collision between player and enemy
            else if (body1.categoryBitMask == PhysicsCategories.player && body2.categoryBitMask == PhysicsCategories.enemy)
                        || (body2.categoryBitMask == PhysicsCategories.player && body1.categoryBitMask == PhysicsCategories.enemy){
                runGameOver()
            }
        }
        // Collision between enemy and border
        if body1.categoryBitMask == PhysicsCategories.enemy && body2.categoryBitMask == border.categoryBitMask && contact.contactPoint.y < playerSize * 2 {
            body1.node!.removeFromParent()
            spawnDeathAnimation(x: contact.contactPoint.x)
            if !isGameOver {
                spawnPoint(x: contact.contactPoint.x)
            }
        }
    }
    
    // Stopping game
    func runGameOver() {
        moveleft = false
        moveright = false
        isGameOver = true
        makeLobbyHidden(to: false)
        
        // Updating highscore
        let userDefaults = UserDefaults()
        let highScore = userDefaults.integer(forKey: HIGHSCORE_KEY)
        if score > highScore {
            userDefaults.setValue(score, forKey: HIGHSCORE_KEY)
        }
        let totalScore = userDefaults.integer(forKey: TOTALSCORE_KEY)
        if score > 0 {
            userDefaults.setValue(totalScore + score, forKey: TOTALSCORE_KEY)
        }
        updateLobbyLabels()
        
        // Removing objects
        self.enumerateChildNodes(withName: "Player") {
            player, stop in
            player.removeFromParent()
        }
        self.enumerateChildNodes(withName: "Point") {
            point, stop in
            point.removeFromParent()
        }
        spawnPlayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
