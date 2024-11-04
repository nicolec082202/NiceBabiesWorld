import SpriteKit

class MatchingGameMainMenuScene: SKScene {

    override func didMove(to view: SKView) {


        let titleLabel = SKLabelNode(text: "Matching Game Main Menu")
        titleLabel.fontSize = 40
        titleLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.5)
        self.addChild(titleLabel)

        // Example: Transition to level 1 when tapped
        let startLabel = SKLabelNode(text: "Start Game")
        startLabel.fontSize = 30
        startLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        startLabel.name = "startGame"
        self.addChild(startLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if node.name == "startGame" {
                // Navigate to the first level
                let level1Scene = MatchingGameLevel1Scene(size: self.size)
                level1Scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 1.0)
                self.view?.presentScene(level1Scene, transition: transition)
            }
        }
    }
}
