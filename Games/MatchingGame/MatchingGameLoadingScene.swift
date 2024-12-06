import SpriteKit  // Import SpriteKit for game scenes and visual elements
import GameplayKit  // Import GameplayKit for potential game mechanics and AI behavior

import SpriteKit

class MatchingGameLoadingScene: SKScene {

    var loadingFlower = SKSpriteNode()
    var textureArray = [SKTexture]()

    override func didMove(to view: SKView) {
        // Set up the loading animation
        setupLoadingAnimation()
        
        let labelNode = SKLabelNode(text: "Game Loading...")
        labelNode.fontName = "Arial-BoldMT" // Set the font name
        labelNode.fontSize = 20 // Set the font size
        labelNode.fontColor = UIColor(red: 249/255, green: 136/255, blue: 6/255, alpha: 1.0) // Set the color of the text
        labelNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 80)

        self.addChild(labelNode)

        // Simulate a loading delay (e.g., 2 seconds)
        let wait = SKAction.wait(forDuration: 2.0)
        let transition = SKAction.run { [weak self] in
            self?.goToMainMenu()
        }
        self.run(SKAction.sequence([wait, transition]))
    }

    // Set up the loading flower animation
    func setupLoadingAnimation() {
        for i in 1...5 {
            let texture = SKTexture(imageNamed: "loading_\(i)")
            textureArray.append(texture)
        }

        loadingFlower = SKSpriteNode(texture: textureArray.first)
        loadingFlower.size = CGSize(width: 80, height: 80)
        loadingFlower.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(loadingFlower)

        let animation = SKAction.animate(with: textureArray, timePerFrame: 0.1)
        loadingFlower.run(SKAction.repeatForever(animation))
    }

    // Transition to the main menu scene
    func goToMainMenu() {
        let mainMenuScene = MatchingGameMainMenuScene(size: self.size) 
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(mainMenuScene, transition: transition)
    }
}


