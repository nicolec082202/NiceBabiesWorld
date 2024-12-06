//
//  Level1.swift
//  NiceBabies
//
//  Created by Allan Prieb on 12/5/24.
//

import Foundation
import SpriteKit

class Level1: WorkOutGameScene {
    var isMenuPopupShown = false // Flag to track popup state
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        let instructionsLabel = SKLabelNode(text: "Collect all 3 stars to win the level!")
        instructionsLabel.position = CGPoint(x: 0, y: 150)
        instructionsLabel.fontColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
        instructionsLabel.fontSize = 75
        instructionsLabel.fontName = "AvenirNext-Bold"
        instructionsLabel.horizontalAlignmentMode = .center
        instructionsLabel.zPosition = 10

        // Add the label to the camera node
        self.cameraNode?.addChild(instructionsLabel)

        // Create actions: wait, fade out, and remove
        let wait = SKAction.wait(forDuration: 5)
        let fadeOut = SKAction.fadeOut(withDuration: 2) // Fades out over 2 seconds
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([wait, fadeOut, remove])

        // Run the sequence on the label
        instructionsLabel.run(sequence)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            print("Touched node: \(node.name ?? "None")") // Debugging print

            if node.name == "next" {
                goToNextLevel()
            } 
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        super.update(currentTime)
        if score >= 3 && !isMenuPopupShown {
            isMenuPopupShown = true // Set the flag
            showMenuPopup() // Show the popup
        }
    }
    
    func showMenuPopup() {
        
        // Move the player off-screen
        let dieAction = SKAction.move(to: CGPoint(x: -500, y: -3000), duration: 0.1)
        player?.run(dieAction)

        // Remove all actions on the player
        player?.removeAllActions()

        // Remove player from the scene
        player?.removeFromParent()

        // Remove overlays
        joystick?.removeFromParent()


        
        // Create a semi-transparent background
        let menuBackground = SKSpriteNode(color: UIColor.black  .withAlphaComponent(0.7), size: self.size)
        menuBackground.position = CGPoint(x: 0, y: 0)
        menuBackground.zPosition = 100
        menuBackground.name = "completedMenuBackground"
        cameraNode?.addChild(menuBackground)

        // Restart button
        let replayButton = SKSpriteNode(imageNamed: "replayIcon")
        replayButton.name = "replay"
        replayButton.position = CGPoint(x: -380.25, y: -386.25)
        replayButton.zPosition = 110
        replayButton.setScale(1.50)
        cameraNode?.addChild(replayButton)

        // Main Menu display
        let mainMenuDisplay = SKSpriteNode(imageNamed: "level1/CompleteMenu")
        mainMenuDisplay.name = "LevelCompleted"
        mainMenuDisplay.position = CGPoint(x: 0, y: 0)
        mainMenuDisplay.zPosition = 109
        mainMenuDisplay.setScale(2.0)
        cameraNode?.addChild(mainMenuDisplay)

        // Next button
        let nextButton = SKSpriteNode(imageNamed: "nextIcon")
        nextButton.name = "next"
        nextButton.position = CGPoint(x: 386, y: -376)
        nextButton.zPosition = 110
        nextButton.setScale(1.50)
        cameraNode?.addChild(nextButton)
    }

    /// Transition to the next level
    func goToNextLevel() {
        print("Next Level Button Pressed")
        
        
        print("Attempting to transition to Level2")
        if let gameScene = WorkOutGameScene(fileNamed: "Level3") {
            print("Level2 scene loaded successfully")
            gameScene.scaleMode = .aspectFit
            gameScene.sceneDelegate = self.sceneDelegate
            let transition = SKTransition.push(with: .left, duration: 1.0)
            self.view?.presentScene(gameScene, transition: transition)
        } else {
            print("Failed to load Level2 scene")
        }
        
    }
    
}
