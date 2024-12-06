import SpriteKit
import SwiftUI

class MatchingGameMainMenuScene: SKScene {
    var equippedBaby: String

    // Custom initializer
    init(size: CGSize, equippedBaby: String) {
        self.equippedBaby = equippedBaby
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        // Add title label
        let titleLabel = SKLabelNode(text: "Matching Game Main Menu")
        titleLabel.fontSize = 40
        titleLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.5)
        titleLabel.fontName = "AvenirNext-Bold" // Optional: Customize the font
        titleLabel.fontColor = .white // Optional: Set color
        self.addChild(titleLabel)

        // Display the equipped baby sprite
        displayEquippedBaby()

        // Add start game label
        let startLabel = SKLabelNode(text: "Start Game")
        startLabel.fontSize = 30
        startLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        startLabel.name = "startGame"
        startLabel.fontName = "AvenirNext-Bold" // Optional: Customize the font
        startLabel.fontColor = .white // Optional: Set color
        self.addChild(startLabel)
    }

    // Function to display the equipped baby sprite
    private func displayEquippedBaby() {
        // Create the texture (it will not be nil)
        let texture = SKTexture(imageNamed: (equippedBaby + "_Sprite_Neutral"))
        
        // Create a sprite node for the baby
        let babySpriteNode = SKSpriteNode(texture: texture)
        babySpriteNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.2)
        babySpriteNode.size = CGSize(width: 150, height: 150) // Adjust size as needed
        babySpriteNode.zPosition = 1 // Ensure it appears above other nodes
        self.addChild(babySpriteNode)
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if node.name == "startGame" {
                let level1Scene = MatchingGameLevel1Scene(size: self.size)
                level1Scene.equippedBaby = equippedBaby // Pass equipped baby string to next scene
                level1Scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 1.0)
                self.view?.presentScene(level1Scene, transition: transition)
            }
        }
    }
}
