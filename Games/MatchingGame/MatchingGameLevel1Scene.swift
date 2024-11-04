import SpriteKit

class MatchingGameLevel1Scene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .purple
        
        let label = SKLabelNode(text: "Matching Game - Level 1")
        label.fontSize = 40
        label.fontColor = .black
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(label)
    }
}
