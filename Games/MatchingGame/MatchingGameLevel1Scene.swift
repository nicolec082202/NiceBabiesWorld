import SpriteKit

class MatchingGameLevel1Scene: SKScene {
    var equippedBaby: String = "" // Property to hold the equipped baby sprite string

    override func didMove(to view: SKView) {
        backgroundColor = .purple

        let label = SKLabelNode(text: "Matching Game - Level 1")
        label.fontSize = 40
        label.fontColor = .black
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(label)

        // Example of using the equipped baby string to display a sprite
        let babySprite = SKSpriteNode(imageNamed: equippedBaby)
        babySprite.position = CGPoint(x: size.width / 2, y: size.height / 1.5)
        babySprite.setScale(0.5) // Adjust scale as needed
        addChild(babySprite)
    }
}
