//
//  GameScene.swift
//  Mobile Application 2
//
//  Created by Daniel Kearsley-Brown on 30/04/2023.
//

import SpriteKit
import UIKit

class GameScene : SKScene, SKPhysicsContactDelegate {
    // App initiators
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var level = 1
    var viewController: GameViewController!
    var background: SKSpriteNode!
    
    // Game objects collision bit maps
    let playerCategory:UInt32 = 0x1 << 0
    let enemyCategory:UInt32 = 0x1 << 1
    let objectCategory:UInt32 = 0x1 << 2
    let healthCategory:UInt32 = 0x1 << 3
    
    // Set game sounds
    let enemyHit = SKAction.playSoundFileNamed("splooge.wav", waitForCompletion: false)
    let enemyMiss = SKAction.playSoundFileNamed("sneeze_man.wav", waitForCompletion: false)
    let objectHit = SKAction.playSoundFileNamed("cough_x.wav", waitForCompletion: false)
    let healthHit = SKAction.playSoundFileNamed("chime_up.wav", waitForCompletion: false)
    
    // Create player sprite
    let player = SKSpriteNode(imageNamed: "player.png")
    var playerIsTouched = false
    
    // Link score variable to the score label
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // Link health variable to the health label
    var healthLabel: SKLabelNode!
    var health: Int = 5 {
        didSet {
            healthLabel.text = "Health: \(health)"
        }
    }
    
    // Initate spawn timers
    var spawnTimerEnemy: Timer!
    var spawnTimerObject: Timer!
    var spawnTimerHealth: Timer!
    
    override func didMove(to view: SKView) {
        // Set gravity off
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        // Background
        background = SKSpriteNode(imageNamed: "Background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.scale(to: size)
        
        addChild(background)
        
        // Create Player and collision body
        player.position = CGPoint(x: size.width / 2, y: player.size.height / 2 + 25)
        player.size = CGSize(width: 50, height: 50)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.frame.size)
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = enemyCategory
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.isDynamic = true
        player.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(player)
        
        // Create Score Label
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 100, y: size.height * 0.85)
        scoreLabel.fontName = "Verdana-BoldItalic"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        addChild(scoreLabel)
        
        // Create Health Label
        healthLabel = SKLabelNode(text: "Health: 0")
        healthLabel.position = CGPoint(x: 100, y: size.height * 0.85 - 40)
        healthLabel.fontName = "Verdana-BoldItalic"
        healthLabel.fontSize = 36
        healthLabel.fontColor = UIColor.white
        health = 5
        
        addChild(healthLabel)
        
        // Enemy, object and health spawn timers depending on level
        level = appDelegate.gameModel.getLevel()
        switch level {
        case 1:
            // Enemy
            spawnTimerEnemy = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(spawnEnemy), userInfo: nil, repeats: true)
            // Object
            spawnTimerObject = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(spawnObject), userInfo: nil, repeats: true)
            // Health
            spawnTimerHealth = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(spawnHealth), userInfo: nil, repeats: true)
        case 2:
            // Enemy
            spawnTimerEnemy = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(spawnEnemy), userInfo: nil, repeats: true)
            // Object
            spawnTimerObject = Timer.scheduledTimer(timeInterval: 0.65, target: self, selector: #selector(spawnObject), userInfo: nil, repeats: true)
            // Health
            spawnTimerHealth = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(spawnHealth), userInfo: nil, repeats: true)
        case 3:
            // Enemy
            spawnTimerEnemy = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(spawnEnemy), userInfo: nil, repeats: true)
            // Object
            spawnTimerObject = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(spawnObject), userInfo: nil, repeats: true)
            // Health
            spawnTimerHealth = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(spawnHealth), userInfo: nil, repeats: true)
        default:
            // if failed print error
            print("Failed to set level")
        }
        
    }
    
    // Spawn a health item
    @objc func spawnHealth() {
        // Create health sprite node
        let health = SKSpriteNode(imageNamed: "health.png")
        
        // randomise the x position
        let randomPosition = CGFloat(Int.random(in: 0..<Int(size.width)))
        // set starting position outside of view at the random position
        health.position = CGPoint(x: randomPosition, y: (size.height + health.size.height))
        health.size = CGSize(width: 50, height: 50)
        
        // Create collision body for health
        health.physicsBody = SKPhysicsBody(rectangleOf: health.frame.size)
        health.physicsBody?.categoryBitMask = healthCategory
        health.physicsBody?.contactTestBitMask = playerCategory
        health.physicsBody?.collisionBitMask = 0
        health.physicsBody?.isDynamic = true
        
        health.removeFromParent()
        addChild(health)
        
        // Create animations at the same random position so it will go straight down off the screen
        // Speed of the object is dependant on the level
        var healthActions = [SKAction]()
        switch level {
        case 1:
            healthActions.append(SKAction.move(to: CGPoint(x: randomPosition, y: -health.size.height), duration: 10))
        case 2:
            healthActions.append(SKAction.move(to: CGPoint(x: randomPosition, y: -health.size.height), duration: 5))
        case 3:
            healthActions.append(SKAction.move(to: CGPoint(x: randomPosition, y: -health.size.height), duration: 1))
        default:
            print("Failed to create health")
            return
            
        }
        // delete itself when off the screen
        healthActions.append(SKAction.removeFromParent())
        // begin the animation
        health.run(SKAction.sequence(healthActions))
    }
    
    // Spawn red blood cell
    @objc func spawnObject() {
        // Create red blood cell sprite node
        let redBloodCell = SKSpriteNode(imageNamed: "redBloodCell.png")
        
        // randomise the x position
        let randomPosition = CGFloat(Int.random(in: 0..<Int(size.width)))
        // set starting position outside of view at the random position
        redBloodCell.position = CGPoint(x: randomPosition, y: (size.height + redBloodCell.size.height))
        redBloodCell.size = CGSize(width: 50, height: 50)
        
        // Create collision body for red blood cell
        redBloodCell.physicsBody = SKPhysicsBody(rectangleOf: redBloodCell.frame.size)
        redBloodCell.physicsBody?.categoryBitMask = objectCategory
        redBloodCell.physicsBody?.contactTestBitMask = playerCategory
        redBloodCell.physicsBody?.collisionBitMask = 0
        redBloodCell.physicsBody?.isDynamic = true
        
        redBloodCell.removeFromParent()
        addChild(redBloodCell)
        
        // Create animations at the same random position so it will go straight down off the screen
        // Speed of the object is dependant on the level
        var objectActions = [SKAction]()
        switch level {
        case 1:
            objectActions.append(SKAction.move(to: CGPoint(x: randomPosition, y: -redBloodCell.size.height), duration: 3.5))
        case 2:
            objectActions.append(SKAction.move(to: CGPoint(x: randomPosition, y: -redBloodCell.size.height), duration: 2.5))
        case 3:
            objectActions.append(SKAction.move(to: CGPoint(x: randomPosition, y: -redBloodCell.size.height), duration: 1.5))
        default:
            print("Failed to create object")
            return
            
        }
        // delete itself when off the screen
        objectActions.append(SKAction.removeFromParent())
        // begin the animation
        redBloodCell.run(SKAction.sequence(objectActions))
    }
    
    // Spawn enemy
    @objc func spawnEnemy() {
        // Create enemy sprite node
        let enemy = SKSpriteNode(imageNamed: "enemy.png")
        
        // randomise the x position
        let randomPosition = CGFloat(Int.random(in: 0..<Int(size.width)))
        // set starting position outside of view at the random position
        enemy.position = CGPoint(x: randomPosition, y: (size.height + enemy.size.height))
        enemy.size = CGSize(width: 50, height: 50)
        
        // Create collision body for enemy
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.frame.size)
        enemy.physicsBody?.categoryBitMask = enemyCategory
        enemy.physicsBody?.contactTestBitMask = playerCategory
        enemy.physicsBody?.collisionBitMask = 0
        enemy.physicsBody?.isDynamic = true
        
        enemy.removeFromParent()
        addChild(enemy)
        
        // Create animations at the same random position so it will go straight down off the screen
        // Speed of the object is dependant on the level
        var enemyActions = [SKAction]()
        switch level {
        case 1:
            enemyActions.append(SKAction.move(to: CGPoint(x: randomPosition, y: -enemy.size.height), duration: 5))
        case 2:
            enemyActions.append(SKAction.move(to: CGPoint(x: randomPosition, y: -enemy.size.height), duration: 3.5))
        case 3:
            enemyActions.append(SKAction.move(to: CGPoint(x: randomPosition, y: -enemy.size.height), duration: 2.5))
        default:
            print("Failed to create enemy")
            return
        }
        // delete itself when off the screen
        enemyActions.append(SKAction.removeFromParent())
        // begin the animation
        enemy.run(SKAction.sequence(enemyActions), completion: enemyMissed)
    }
    
    // Check if inital touch is on the player
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        if player.contains(touch.location(in: self)) {
            playerIsTouched = true
        } else {
            playerIsTouched = false
        }
    }
    
    // if the inital touch is on the player then the drag will move the player
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if playerIsTouched {
            for touch in touches {
                player.position = CGPoint(x: touch.location(in: self).x, y: player.position.y)
            }
        }
    }
    
    // If a collision occured
    func didBegin(_ contact: SKPhysicsContact) {
        print("collision!")
        var bodyA: SKPhysicsBody
        var bodyB: SKPhysicsBody
        
        // A redblood cell and a enemy wont make contact
        // so the lowest bit mask is always the player
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            bodyA = contact.bodyA
            bodyB = contact.bodyB
        } else {
            bodyA = contact.bodyB
            bodyB = contact.bodyA
        }
        
        // Check if enemy contact
        if (bodyA.categoryBitMask & playerCategory) != 0 && (bodyB.categoryBitMask & enemyCategory) != 0 {
            playerEnemyCollide(enemy: bodyB.node as! SKSpriteNode)
        }
        
        // Check is red blood cell contact
        if (bodyA.categoryBitMask & playerCategory) != 0 && (bodyB.categoryBitMask & objectCategory) != 0 {
            playerObjectCollide(redBloodCell: bodyB.node as! SKSpriteNode)
        }
        
        // Check if health contact
        if (bodyA.categoryBitMask & playerCategory) != 0 && (bodyB.categoryBitMask & healthCategory) != 0 {
            playerHealthCollide(health: bodyB.node as! SKSpriteNode)
        }
    }
    
    func playerHealthCollide(health: SKSpriteNode) {
        // on contact, add health if still alive
        run(healthHit)
        health.removeFromParent()
        if self.health > 0 && self.health < 5 {
            self.health += 1
        }
    }
    
    func playerObjectCollide(redBloodCell: SKSpriteNode) {
        // on contact, remove object and remove health
        run(objectHit)
        redBloodCell.removeFromParent()
        removeHealth()
    }
    
    func playerEnemyCollide(enemy: SKSpriteNode) {
        // on contact, remove enemy object and add score if still alive
        run(enemyHit)
        enemy.removeFromParent()
        if health > 0 {
            score += 1
        }
    }
    
    func enemyMissed() {
        // if the enemy despawns on its own, remove health
        run(enemyMiss)
        removeHealth()
    }
    
    func removeHealth() {
        // remove health by 1
        // if health is at 0 end the game
        health -= 1
        if health <= 0 {
            endGame()
        }
    }
    
    func endGame() {
        // call the view controller end game function passing the score
        self.viewController.gameEnded(gameScore: score)
        // destroy the game so it isnt running in the background
        self.removeFromParent()
        self.view?.presentScene(nil)
    }
}
