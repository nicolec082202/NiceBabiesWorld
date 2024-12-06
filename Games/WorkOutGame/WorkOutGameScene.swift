import SpriteKit  // Import SpriteKit for game scenes and visual elements
import GameplayKit  // Import GameplayKit for potential game mechanics and AI behavior

// Define the WorkOutGameScene class, inheriting from SKScene
class WorkOutGameScene: SKScene {
    
    weak var sceneDelegate: SpriteKitSceneDelegate?
    
    //Nodes
    var player : SKNode?
    var joystick : SKNode?
    var joystickKnob : SKNode?
    var cameraNode : SKCameraNode?
    var backgroundNode : SKNode?
    var exitGame: SKNode?
    var scoreIcon: SKNode?
    
    // Boolean
    var joystickAction = false
    var rewardIsNotTouched = true
    var isHit = false
    
    // Measure
    var knobRadius : CGFloat = 176.6
    
    // Score
    let scoreLabel = SKLabelNode()
    var score = 0
    
    // Hearts
    var heartsArray = [SKSpriteNode]()
    let heartContainer = SKSpriteNode()
    
    // Sprite Engine
    var previousTimeInterval : TimeInterval = 0
    var playerIsFacingRight = true
    let playerSpeed = 5.0
    
    // Player state
    var playerStateMachine : GKStateMachine!
    
    // didmove
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
//        Sound.shared.playBackgroundMusic(fileName: "music.wav")

        
        player = childNode(withName: "player")
        joystick = childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "knob")
        cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
        backgroundNode = childNode(withName: "backgroundNode")
        exitGame = childNode(withName: "exitGame")
        scoreIcon = childNode(withName: "scoreIcon")
        
        if let playerNode = player {
            playerStateMachine = GKStateMachine(states: [
                JumpingState(playerNode: playerNode),
                WalkingState(playerNode: playerNode),
                IdleState(playerNode: playerNode),
                LandingState(playerNode: playerNode),
                StunnedState(playerNode: playerNode)
            ])
            playerStateMachine.enter(IdleState.self)
        } else {
            print("Error: player node is nil. State machine not initialized.")
        }
        
        // Hearts
        heartContainer.position = CGPoint(x: -1170, y: 473)
        heartContainer.zPosition = 10
        cameraNode?.addChild(heartContainer)
        fillHearts(count: 3)
        
        // Timer
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) {(timer) in
            self.spawnMeteor()
        }
        
        scoreLabel.position = CGPoint(x: 1000, y: 440)
        scoreLabel.fontColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        scoreLabel.fontSize = 95
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.text = String(score)
        scoreLabel.zPosition = 10
        cameraNode?.addChild(scoreLabel)
        
    }
    
}

// MARK: Touches

extension WorkOutGameScene {
    // Touch Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if node.name == "replay" {
                replayLevel()
                return
            }
            
            // Check if the "exitGame" button was tapped
            if node.name == "exitGame" {
                goToMainMenu()
                return
            }

            // Joystick handling
            if let joystickKnob = joystickKnob, joystick?.contains(location) == true {
                let joystickLocation = touch.location(in: joystick!)
                joystickAction = joystickKnob.frame.contains(joystickLocation)
            }

            // Jump logic
            let isTouchOnJoystick = joystick?.contains(location) ?? false
            if !isTouchOnJoystick && node.name != "exitGame" {
                playerStateMachine.enter(JumpingState.self)

                // let soundAction = SKAction.playSoundFileNamed("jumpSound.wav", waitForCompletion: false)
                // self.run(soundAction)
            }
            
        }

        
    }
    
    // Touch Moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let joystick = joystick else { return }
        guard let joystickKnob = joystickKnob else { return }
        
        if !joystickAction { return }
        
        // Distance
        for touch in touches {
            let position = touch.location(in: joystick)
            
            let length = sqrt(pow(position.y, 2) + pow(position.x, 2))
            let angle = atan2(position.y, position.x)
            
            if knobRadius > length {
                joystickKnob.position = position
            } else {
                joystickKnob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
            }
        }
    }
    
    // Touch Ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let xJoystickCoordinate = touch.location(in: joystick!).x
            let xLimit: CGFloat = 706.4
            
            if xJoystickCoordinate > -xLimit && xJoystickCoordinate < xLimit {
                resetKnobPosition()
            }
        }
    }
}


// MARK: Action
extension WorkOutGameScene {
    
    func resetKnobPosition() {
        let initialPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob?.run(moveBack)
        joystickAction = false
    }
    
    func rewardTouch() {
        score += 1
        scoreLabel.text = String(score)
    }
    
    func fillHearts(count: Int) {
        for index in 1...count {
            let heart = SKSpriteNode(imageNamed: "full_heart")
            heart.setScale(0.06)
            let xposition = heart.size.width *  CGFloat(index - 1) * 0.7
            heart.position = CGPoint(x: xposition, y: 0)
            heartsArray.append(heart)
            heartContainer.addChild(heart)
        }
    }
    
    func loseHeart() {
        if isHit {
            let lastElementIndex = heartsArray.count - 1
            if heartsArray.indices.contains(lastElementIndex - 1) {
                let lastHeart = heartsArray[lastElementIndex]
                lastHeart.removeFromParent()
                heartsArray.remove(at: lastElementIndex)
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                    self.isHit = false
                }
            }
            else {
                dying()
            }
            invincible()
        }
    }
    
    func invincible() {
        player?.physicsBody?.categoryBitMask = 0
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.player?.physicsBody?.categoryBitMask = 2
        }
    }
    
    func dying () {
        // Move the player off-screen
        let dieAction = SKAction.move(to: CGPoint(x: -500, y: -3000), duration: 0.1)
        player?.run(dieAction)

        // Remove all actions on the player
        player?.removeAllActions()

        // Remove player from the scene
        player?.removeFromParent()

        // Remove overlays
        joystick?.removeFromParent()
        exitGame?.removeFromParent()

        // Show the death menu after removing the nodes
        showDeathMenu()
    }
    
}


// Mark: Game Loop
extension WorkOutGameScene {
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - previousTimeInterval
        previousTimeInterval = currentTime
        
        rewardIsNotTouched = true
        
        // Camera
        cameraNode?.position.x = player!.position.x
        joystick?.position.y = (cameraNode?.position.y)! - 315
        joystick?.position.x = (cameraNode?.position.x)! - 860
        backgroundNode?.position.x = (cameraNode?.position.x)!
        backgroundNode?.position.y = (cameraNode?.position.y)!
        exitGame?.position.x =  (cameraNode?.position.x)! + 1228.8
        exitGame?.position.y = (cameraNode?.position.y)! + 465
        scoreIcon?.position.x = (cameraNode?.position.x)! + 885
        scoreIcon?.position.y = (cameraNode?.position.y)! + 474

        
        // Player movement
        guard let joystickKnob = joystickKnob else { return }
        let xPosition = Double(joystickKnob.position.x)
        let positivePosition = xPosition < 0 ? -xPosition : xPosition
        
        if floor(positivePosition) != 0 {
            playerStateMachine.enter(WalkingState.self)
        } else {
            playerStateMachine.enter(IdleState.self)
        }
        let displacement = CGVector(dx: deltaTime * xPosition * playerSpeed, dy: 0)
        let move = SKAction.move(by: displacement, duration: 0)
        let faceAction : SKAction!
        let movingRight = xPosition > 0
        let movingLeft = xPosition < 0
        if movingLeft && playerIsFacingRight {
            playerIsFacingRight = false
            let faceMovement = SKAction.scaleX(to: -4.0, duration: 0.0)
            faceAction = SKAction.sequence([move, faceMovement])
        }
        else if movingRight && !playerIsFacingRight {
            playerIsFacingRight = true
            let faceMovement = SKAction.scaleX(to: 4.0, duration: 0.0)
            faceAction = SKAction.sequence([move, faceMovement])
        } else {
            faceAction = move
        }
        player?.run(faceAction)
    }
}

// MARK: Collision
extension WorkOutGameScene : SKPhysicsContactDelegate {
    
    struct Collision {
        enum Masks: Int {
            case killing, player, reward, ground
            var bitmask: UInt32 { return 1 << self.rawValue }
        }
        
        let masks: (first: UInt32, second: UInt32)
        
        func matches (_ first: Masks, _ second: Masks) -> Bool {
            return (first.bitmask == masks.first && second.bitmask == masks.second) ||
            first.bitmask == masks.second && second.bitmask == masks.first
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let collision = Collision(masks: (first: contact.bodyA.categoryBitMask, second: contact.bodyB.categoryBitMask))
        
        if collision.matches(.player, .killing) {
            loseHeart()
            isHit = true
//            let soundAction = SKAction.playSoundFileNamed("hitSound.wav", waitForCompletion: false)
//            self.run(soundAction)
            
            playerStateMachine.enter(StunnedState.self)
        }
        
        if collision.matches(.player, .ground) {
            playerStateMachine.enter(LandingState.self)
        }
        
        if collision.matches(.player, .reward) {
            
            if contact.bodyA.node?.name == "jewel" {
                
                contact.bodyA.node?.physicsBody?.categoryBitMask = 0
                contact.bodyA.node?.removeFromParent()
                
            } else if contact.bodyB.node?.name == "jewel" {
                
                contact.bodyB.node?.physicsBody?.categoryBitMask = 0
                contact.bodyB.node?.removeFromParent()

            }
            
            if rewardIsNotTouched {
                rewardTouch()
                rewardIsNotTouched = false
            }
//            let soundAction = SKAction.playSoundFileNamed("rewardSound.wav", waitForCompletion: false)
//            self.run(soundAction)
        }
        
        if collision.matches(.ground, .killing){
            if contact.bodyA.node?.name == "Asteroid", let meteor = contact.bodyA.node {
                createMolten(at: meteor.position)
                meteor.removeFromParent()
            }
            
            if contact.bodyB.node?.name == "Asteroid", let meteor = contact.bodyB.node {
                createMolten(at: meteor.position)
                meteor.removeFromParent()
            }
//            let soundAction = SKAction.playSoundFileNamed("meteorFallingSound.wav", waitForCompletion: false)
//            self.run(soundAction)
            
        }
    }
}


// MARK: Meteor
extension WorkOutGameScene {
    
    func spawnMeteor() {
        
        let node = SKSpriteNode(imageNamed: "asteroid")
        node.name = "Asteroid"
        let randomXPosition = Int(arc4random_uniform(UInt32(size.width)))
        
        node.position = CGPoint(x: randomXPosition, y: 920)
        node.anchorPoint = CGPoint(x: 0.5, y: 1)
        node.zPosition = 5
        node.setScale(0.3)
        
        let physicsBody = SKPhysicsBody(circleOfRadius: 106)
        node.physicsBody = physicsBody
        
        physicsBody.categoryBitMask = Collision.Masks.killing.bitmask
        physicsBody.collisionBitMask = Collision.Masks.player.bitmask | Collision.Masks.ground.bitmask
        physicsBody.contactTestBitMask = Collision.Masks.player.bitmask | Collision.Masks.ground.bitmask
        physicsBody.fieldBitMask = Collision.Masks.player.bitmask | Collision.Masks.ground.bitmask
        
        physicsBody.affectedByGravity = true
        physicsBody.allowsRotation = false
        physicsBody.restitution = 0.2
        physicsBody.friction = 10
        
        addChild(node)
    }
    
    func createMolten(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "splash/yellow")
        node.setScale(0.4)
        node.position.x = position.x
        node.position.y = position.y - 200
        node.zPosition = 4
        
        addChild(node)
        
        let action = SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.1),
            SKAction.wait(forDuration: 3),
            SKAction.fadeOut(withDuration: 0.2),
            SKAction.removeFromParent()
        ])
        
        node.run(action)
    }
}

// MARK: Exit game

extension WorkOutGameScene {
    func goToMainMenu() {
        let customSize = CGSize(width: 2868, height: 1320) // Replace with your desired size
        let mainMenuScene = WorkOutGameMainMenuScene(size: customSize, equippedBaby: "")
        
        mainMenuScene.sceneDelegate = sceneDelegate
        
        mainMenuScene.scaleMode = .aspectFit

        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(mainMenuScene, transition: transition)
    }
    
    func showDeathMenu() {
        // Create a semi-transparent background
        let menuBackground = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.7), size: self.size)
        menuBackground.position = CGPoint(x: 0 , y: 0)
        menuBackground.zPosition = 100
        menuBackground.name = "deathMenuBackground"
        cameraNode?.addChild(menuBackground)

        // Restart button
        let replay = SKSpriteNode(imageNamed: "replayIcon")
        replay.name = "replay"
        
        replay.position = CGPoint(x: 394.25, y: -287)
        replay.anchorPoint = CGPoint(x: 0.5, y: 1)
        replay.zPosition = 110
        replay.setScale(1.50)
        cameraNode?.addChild(replay)

        // Create a "Main Menu" button
        let mainMenu = SKSpriteNode(imageNamed: "levelFailed")
        mainMenu.name = "LevelFailed"
        mainMenu.position = CGPoint(x: 7, y:7)
        mainMenu.zPosition = 109
        mainMenu.setScale(2.0)
        cameraNode?.addChild(mainMenu)
    }
    func replayLevel() {
        // Stop all actions and remove all nodes
        // Remove all actions and nodes for a clean reset
        self.removeAllActions()
        self.removeAllChildren()

        // Load the scene from the SKS file
        if let currentSceneName = self.name,
           let newScene = SKScene(fileNamed: currentSceneName) as? WorkOutGameScene {
            newScene.scaleMode = self.scaleMode // Maintain scale mode
            self.view?.presentScene(newScene, transition: SKTransition.crossFade(withDuration: 1.0))
        } else {
            print("Error: Could not reload scene from SKS file.")
        }
    }
}
