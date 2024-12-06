import SpriteKit  // Import SpriteKit for game scenes and visual elements
import GameplayKit  // Import GameplayKit for potential game mechanics and AI behavior

import SpriteKit

class MatchingGameLoadingScene: SKScene {
    var equippedBaby: String

        // Custom initializer
        init(size: CGSize, equippedBaby: String) {
            self.equippedBaby = equippedBaby
            super.init(size: size)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    var loadingFlower = SKSpriteNode()
    var textureArray = [SKTexture]()

    override func didMove(to view: SKView) {
        // Set up the loading animation
        setupLoadingAnimation()

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
        let mainMenuScene = MatchingGameMainMenuScene(size: self.size, equippedBaby: equippedBaby) // Pass equippedBaby
        mainMenuScene.scaleMode = .aspectFill

        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(mainMenuScene, transition: transition)
    }
}


