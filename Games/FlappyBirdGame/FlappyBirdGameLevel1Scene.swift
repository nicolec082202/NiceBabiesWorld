import SpriteKit
import GameplayKit

enum GameState {
    case showingLogo
    case playing
    case dead
}

class FlappyBirdGameLevel1Scene: SKScene, SKPhysicsContactDelegate {
        
    var equippedBaby: String = ""
    var player: SKSpriteNode!
    var logo: SKSpriteNode!
    var gameOver: SKSpriteNode!
    var replayButton: SKSpriteNode!
    var exitButton: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var gameState = GameState.showingLogo
    var startTime: TimeInterval = 0
    var levelCompleted: SKSpriteNode!
    
    // Property observer to update the score whenever it changes.
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
            
            if score == 10 && gameState == .playing {
                gameState = .dead
                speed = 0 // Stop game objects
                showLevelCompleted()
            }
        }
    }
    
    // Property observer to update bonus whenever a star is collected.
    
    override func didMove(to view: SKView) {
        createLogos()
        createPlayer()
        createSky()
        //createBackground()
        addSolidBackground()
        createGround()
        createScore()
        createExitButton()
        
        
        // Creates the gravity for the player
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        physicsWorld.contactDelegate = self
        
        fetchUserData(for: "equippedBaby") { value, error in
            if let error = error {
                print("Error fetching equippedBaby: \(error.localizedDescription)")
            } else if let fetchedEquippedBaby = value as? String {
                self.equippedBaby = fetchedEquippedBaby
                DispatchQueue.main.async {
                    self.createPlayer()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)

            // Check if the exit button is tapped
            if let exitButton = exitButton, exitButton.contains(location) {
                let mainMenuScene = FlappyBirdGameMainMenuScene(size: self.size)
                mainMenuScene.scaleMode = .aspectFill
                let transition = SKTransition.crossFade(withDuration: 1.0)
                self.view?.presentScene(mainMenuScene, transition: transition)
                return // Exit early to prevent processing further touches
            }
            
            // Handle replay button for both game-over and level-completed scenarios
            if let replayButton = replayButton, replayButton.contains(location) {
                resetGameUI()
                restartLevel()
                return
            }
            
            switch gameState {
            case .showingLogo:
                gameState = .playing
                
                let fadeOut = SKAction.fadeOut(withDuration: 0.5)
                let remove = SKAction.removeFromParent()
                let wait = SKAction.wait(forDuration: 0.5)
                let activatePlayer = SKAction.run { [unowned self] in
                    self.player.physicsBody?.isDynamic = true
                    self.startRocks()
                }
                
                let sequence = SKAction.sequence([fadeOut, wait, activatePlayer, remove])
                logo.run(sequence)
            case .playing:
                player.physicsBody?.velocity = CGVector(dx: 0, dy: -20)
                
                // Every time the player taps the screen, push the player upwards.
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
            case .dead:
                if let replayButton = replayButton, replayButton.contains(location) {
                    restartLevel()
                    return
                }
                
                // Reset the scene if player taps the screen after losing
                let scene = FlappyBirdGameLevel1Scene(size: self.size)
                let transition = SKTransition.moveIn(with: .right, duration: 1)
                self.view?.presentScene(scene, transition: transition)
            }
        }
    }
    
    func restartLevel() {
        let scene = FlappyBirdGameLevel1Scene(size: self.size)
        scene.scaleMode = .aspectFill
        let transition = SKTransition.crossFade(withDuration: 1.0)
        self.view?.presentScene(scene, transition: transition)
    }

    
    override func update(_ currentTime: TimeInterval) {
        // Make sure that player is not nil, otherwise exit the method
        guard player != nil else { return }
        
        // Take 1/1000 of the players upward velocity and turn that into rotation spanning 1/10 of a second.
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
        
        player.run(rotate)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Check to see if either the bird collided with the rectangle score box or the score box collided with the plane.
        if contact.bodyA.node?.name == "scoreDetect" || contact.bodyB.node?.name == "scoreDetect" {
            // Remove the score rectangle from the game so that they can't score double points
            if contact.bodyA.node == player {
                contact.bodyB.node?.removeFromParent()
            } else {
                contact.bodyA.node?.removeFromParent()
            }
        
            let sound = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
            run(sound)
        
            score += 1
        
            return
        }
        
        if contact.bodyA.node?.name == "starDetect" || contact.bodyB.node?.name == "starDetect" {
            if contact.bodyA.node == player {
                contact.bodyB.node?.removeFromParent()
            } else {
                contact.bodyA.node?.removeFromParent()
            }
            
            let sound = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
            run(sound)
            
            return
        }
        
        if contact.bodyA.node == nil || contact.bodyB.node == nil {
            return
        }
        
        // Otherwise, check to see if the player touches the rocks or ground and if so, end the game.
        if contact.bodyA.node == player || contact.bodyB.node == player {
            if let explosion = SKEmitterNode(fileNamed: "PlayerExplosion") {
                explosion.position = player.position
                addChild(explosion)
            }
            
            let sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
            run(sound)
            
            // End the game by showing the game over logo and changing the game state to dead
            gameOver.alpha = 1
            gameState = .dead
            
            player.removeFromParent()
            speed = 0
        }
    }
    
    
    func createPlayer() {
        guard !equippedBaby.isEmpty else {
            print("Equipped baby is empty, skipping player creation.")
            return
        }
        
        // Create the texture for the equipped baby
        let playerTexture = SKTexture(imageNamed: "\(equippedBaby)_Sprite_Neutral")
        
        // Initialize the player node
        player = SKSpriteNode(texture: playerTexture)
        player.zPosition = 10
        player.size = CGSize(width: 200, height: 200) // Adjust size as needed
        
        // Position the player most of the way to the top of the screen and most of the way to the left
        player.position = CGPoint(x: frame.width / 5, y: frame.height * 0.75)
        
        // Add player to the scene
        addChild(player)
        
        // Adds physics to the player and tells us when it has collided with something
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        player.physicsBody!.isDynamic = false
        player.physicsBody!.collisionBitMask = 0
    }
    
    
    /*func createSky() {
        // Create the top part of the sky that will take up 67% of the screen and use the anchorPoint property to make it measure up from the center top of the screen
        let topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.67))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        // Create the bottom part of the sky that will take up 33% of the screen and use anchorPoint to do the same thing as mentioned above.
        let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.33))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        topSky.position = CGPoint(x: frame.midX, y: frame.height)
        bottomSky.position = CGPoint(x: frame.midX, y: bottomSky.frame.height / 2)
        
        addChild(topSky)
        addChild(bottomSky)
        
        bottomSky.zPosition = -40
        topSky.zPosition = -40
    }*/
    
    // 1. Add solid background color
    func addSolidBackground() {
        let solidBackground = SKSpriteNode(color: UIColor(red: 202/255, green: 196/255, blue: 248/255, alpha: 1.0), size: self.size)
        solidBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        solidBackground.zPosition = -50
        addChild(solidBackground)
    }
    
    // 2. Create a sky element (top part of the screen)
    func createSky() {
        let skyTexture = SKTexture(imageNamed: "FlappyBirdSky") // Use a sky texture
        let sky = SKSpriteNode(texture: skyTexture)
        sky.size = CGSize(width: frame.width, height: frame.height * 0.1) // Adjust height as needed
        sky.anchorPoint = CGPoint(x: 0.5, y: 0) // Anchored to the top
        sky.position = CGPoint(x: frame.midX, y: frame.height*0.9 + 5)
        sky.zPosition = -40
        addChild(sky)
    }
    
    
    /*func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "FlappyBirdBackground")
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -30
            background.anchorPoint = CGPoint.zero
            
            // Calculate the x position of each mountain. Since the loop goes from 0 to 1, the first time the loop executes, X will be zero. The second time it executes, X will be the width of the texture minus 1. This prevents any gaps.
            background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 - i), y: 0)
            
            addChild(background)
            
            // Both mountains will move left a distance equal to its width, jump back another distance the size of its width, and repeat the sequence forever. Combined, these steps create an infinite scrolling landscape.
            let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
    }*/
    
    /// createGround() creates the scrolling ground background on the screen
    /// - Returns: nil
    /// - Parameters: none
    
    func createGround() {
        let groundTexture = SKTexture(imageNamed: "FlappyBirdGround")
        
        for i in 0 ... 1 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10
            ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 2 - 2)
            
            // Sets up the pixel-perfect collision for the ground sprites and then makes them non-dynamic.
            ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
            ground.physicsBody!.isDynamic = false
            
            addChild(ground)
            
            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
            let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            ground.run(moveForever)
        }
    }
    
  
    /*func createRocks() {
        // Create the top and bottom spikes, while the top spike is an inverted version of the bottom.
        let rockTexture = SKTexture(imageNamed: "Building1")
        
        let topRock = SKSpriteNode(texture: rockTexture)
        topRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        topRock.physicsBody!.isDynamic = false
        topRock.zRotation = CGFloat.pi
        topRock.xScale = -1.0
        
        let bottomRock = SKSpriteNode(texture: rockTexture)
        bottomRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        bottomRock.physicsBody!.isDynamic = false
        
        topRock.zPosition = -20
        bottomRock.zPosition = -20
        
        // Create a rectangular box such that if the player touches the box, they score a point.
        let rockCollision = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 32, height: frame.height))
        rockCollision.physicsBody = SKPhysicsBody(rectangleOf: rockCollision.size)
        rockCollision.physicsBody!.isDynamic = false
        rockCollision.name = "scoreDetect"
        
        let starTexture = SKTexture(imageNamed: "Star")
        
        // Create star for bonus scoring.
        let star = SKSpriteNode(texture: starTexture)
        star.physicsBody = SKPhysicsBody(texture: starTexture, size: starTexture.size())
        star.physicsBody!.isDynamic = false
        star.zPosition = -10
        star.size = CGSize(width: 30, height: 30)
        star.name = "starDetect"
        
        addChild(topRock)
        addChild(bottomRock)
        addChild(rockCollision)
        addChild(star)
        
        let xPosition = frame.width + topRock.frame.width
        
        let max = Int(frame.height / 3)
        
        let rockDistance: CGFloat = 60
        
        // Generate a random number to determine where the safe spot between the rocks will be.
        let rand = GKRandomDistribution(lowestValue: -100, highestValue: max)
        let yPosition = CGFloat(rand.nextInt())
        
        let randStar = GKRandomDistribution(lowestValue: Int(frame.minY + 80), highestValue: Int(frame.maxY - 80))
        let yPositionStar = CGFloat(randStar.nextInt())
        
        // Position the rocks at the right edge of the screen and animate them to the left edge.
        topRock.position = CGPoint(x: xPosition, y: yPosition + topRock.size.height + rockDistance)
        bottomRock.position = CGPoint(x: xPosition, y: yPosition - rockDistance)
        rockCollision.position = CGPoint(x: xPosition + (rockCollision.size.width * 2), y: frame.midY)
        star.position = CGPoint(x: xPosition + frame.midX, y: yPositionStar)
        
        let endPosition = frame.width + (topRock.frame.width * 2)
        
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6.2)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        
        topRock.run(moveSequence)
        bottomRock.run(moveSequence)
        rockCollision.run(moveSequence)
        star.run(moveSequence)
    }*/
    
    func resetGameUI() {
        replayButton.isHidden = true
        exitButton.isHidden = true
        if let levelCompleted = levelCompleted {
            levelCompleted.removeFromParent()
        }
        if let gameOver = gameOver {
            gameOver.removeFromParent()
        }
    }
    
    func createRocks() {
        // Define building textures
        let buildingTextures = [
            SKTexture(imageNamed: "Building1"),
            SKTexture(imageNamed: "Building2")
        ]
        
        // Randomly select textures for the top and bottom rocks
        let topTexture = buildingTextures.randomElement() ?? SKTexture(imageNamed: "Building1")
        let bottomTexture = buildingTextures.randomElement() ?? SKTexture(imageNamed: "Building1")
        
        // Top building (flipped upside down)
        let topRock = SKSpriteNode(texture: topTexture)
        topRock.setScale(0.5) // Scale down by 40%
        topRock.physicsBody = SKPhysicsBody(texture: topTexture, size: topRock.size)
        topRock.physicsBody!.isDynamic = false
        topRock.zRotation = CGFloat.pi // Rotate for the top building
        topRock.zPosition = -45 // Above the ground

        // Bottom building
        let bottomRock = SKSpriteNode(texture: bottomTexture)
        bottomRock.setScale(0.5) // Scale down by 40%
        bottomRock.physicsBody = SKPhysicsBody(texture: bottomTexture, size: bottomRock.size)
        bottomRock.physicsBody!.isDynamic = false
        bottomRock.zPosition = -15 // Above the ground

        // Scoring collision box
        let rockCollision = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 32, height: frame.height))
        rockCollision.physicsBody = SKPhysicsBody(rectangleOf: rockCollision.size)
        rockCollision.physicsBody!.isDynamic = false
        rockCollision.name = "scoreDetect"

        // Star for bonus scoring
        let starTexture = SKTexture(imageNamed: "Star")
        let star = SKSpriteNode(texture: starTexture)
        star.physicsBody = SKPhysicsBody(texture: starTexture, size: starTexture.size())
        star.physicsBody!.isDynamic = false
        star.zPosition = 10
        star.size = CGSize(width: 30, height: 30)
        star.name = "starDetect"

        // Add objects to the scene
        addChild(topRock)
        addChild(bottomRock)
        addChild(rockCollision)
        addChild(star)

        // Calculate positions
        let xPosition = frame.width + topRock.frame.width // Start outside the right edge
        let rockGap: CGFloat = CGFloat.random(in: 120...180) // Vertical gap between top and bottom buildings

        // Random offsets for horizontal misalignment
        let topOffsetX: CGFloat = CGFloat.random(in: -30...30)
        let bottomOffsetX: CGFloat = CGFloat.random(in: -30...30)

        // Adjust positions based on building heights
        if topTexture.description.contains("Building1") {
            topRock.position = CGPoint(x: xPosition, y: frame.maxY - topRock.size.height / 4 + 5)
        } else {
            topRock.position = CGPoint(x: xPosition, y: frame.maxY - topRock.size.height / 3 + 5)
        }

        if bottomTexture.description.contains("Building1") {
            bottomRock.position = CGPoint(x: xPosition, y: frame.minY + bottomRock.size.height / 4)
        } else {
            bottomRock.position = CGPoint(x: xPosition, y: frame.minY + bottomRock.size.height / 3 + 5)
        }
        
        // Adjust the gap between the top and bottom rocks
        topRock.position.y -= rockGap / 2
        bottomRock.position.y += rockGap / 2

        // Position the scoring collision box and star
        rockCollision.position = CGPoint(x: xPosition + (rockCollision.size.width * 2), y: frame.midY)
        star.position = CGPoint(x: xPosition + 100, y: (topRock.position.y + bottomRock.position.y) / 2)

        // Move objects from right to left and remove them when off-screen
        let endPosition = frame.width + (topRock.frame.width * 2)
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6.2)
        let removeAction = SKAction.removeFromParent()
        let moveSequence = SKAction.sequence([moveAction, removeAction])

        topRock.run(moveSequence)
        bottomRock.run(moveSequence)
        rockCollision.run(moveSequence)
        star.run(moveSequence)
    }


    func startRocks() {
        let create = SKAction.run { [unowned self] in
                self.createRocks()
        }
        
        let wait = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        
        run(repeatForever)
    }
    

    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        scoreLabel.fontSize = 24
        
        scoreLabel.position = CGPoint(x: frame.maxX - 20, y: frame.maxY - 70)
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontColor = UIColor.black
        
        addChild(scoreLabel)
    }
    
    
    func createLogos() {
        logo = SKSpriteNode(imageNamed: "StartGame")
        logo.size = CGSize(width: 300, height: 300)
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(logo)
        
        gameOver = SKSpriteNode(imageNamed: "LevelFailed")
        gameOver.size = CGSize(width: 300, height: 300)
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOver.alpha = 0
        addChild(gameOver)
        
        replayButton = SKSpriteNode(imageNamed: "Replay_Icon")
        replayButton.position = CGPoint(x: frame.midX, y: frame.midY - 200) // Below the game-over icon
        replayButton.zPosition = 20
        replayButton.alpha = 0
        addChild(replayButton)
    }
    
    func createExitButton() {
        let exitButtonTexture = SKTexture(imageNamed: "Exit_Button")
        exitButton = SKSpriteNode(texture: exitButtonTexture)
        exitButton.size = CGSize(width: 50, height: 50) // Adjust size as needed
        exitButton.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 60) // Top-left corner
        exitButton.zPosition = 100 // Ensure it's on top of everything
        addChild(exitButton)
    }
    
    func showLevelCompleted() {
        // Create the Level Completed icon
        levelCompleted = SKSpriteNode(imageNamed: "LevelCompleted")
        levelCompleted.size = CGSize(width: 300, height: 300) // Adjust size as needed
        levelCompleted.position = CGPoint(x: frame.midX, y: frame.midY)
        levelCompleted.zPosition = 30
        addChild(levelCompleted)

        // Reuse the existing replay button
        replayButton.position = CGPoint(x: frame.midX - 100, y: frame.midY - 100) // Adjust placement relative to the levelCompleted icon
        replayButton.zPosition = 35
        replayButton.isHidden = false // Ensure it's visible

        // Reuse the existing exit button
        exitButton.position = CGPoint(x: frame.midX + 100, y: frame.midY - 100) // Adjust placement relative to the levelCompleted icon
        exitButton.zPosition = 35
        exitButton.isHidden = false // Ensure it's visible
    }

}

