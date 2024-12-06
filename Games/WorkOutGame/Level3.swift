//
//  Level2.swift
//  NiceBabies
//
//  Created by Allan Prieb on 12/5/24.
//

import Foundation
import SpriteKit

class Level3: WorkOutGameScene {
    var isMenuPopupShown = false
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            print("Touched node: \(node.name ?? "None")") // Debugging print

            if node.name == "replay" {
                replayLevel()
            } else if node.name == "exit" {
                sceneDelegate?.didCompleteGame()
                goToMainMenuFromMenu()
                return
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
        let mainMenuDisplay = SKSpriteNode(imageNamed: "level2/CompleteMenu")
        mainMenuDisplay.name = "LevelCompleted"
        mainMenuDisplay.position = CGPoint(x: 0, y: 0)
        mainMenuDisplay.zPosition = 109
        mainMenuDisplay.setScale(2.0)
        cameraNode?.addChild(mainMenuDisplay)

        // Exit button
        let exitButton = SKSpriteNode(imageNamed: "exitIcon")
        exitButton.name = "exit"
        exitButton.position = CGPoint(x: 386, y: -376)
        exitButton.zPosition = 110
        exitButton.setScale(1.50)
        cameraNode?.addChild(exitButton)
    }
    
    func goToMainMenuFromMenu() {
        let customSize = CGSize(width: 2868, height: 1320) // Replace with your desired size
        let mainMenuScene = WorkOutGameMainMenuScene(size: customSize, equippedBaby: "")
        
        mainMenuScene.sceneDelegate = sceneDelegate
        
        mainMenuScene.scaleMode = .aspectFill

        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(mainMenuScene, transition: transition)
    }
}
