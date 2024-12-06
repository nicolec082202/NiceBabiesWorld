import SpriteKit
import SwiftUI

class WorkOutGameMainMenuScene: SKScene {

    var equippedBaby: String

    // Custom initializer
    init(size: CGSize, equippedBaby: String) {
        self.equippedBaby = equippedBaby
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var level1Completed = false
    
    weak var sceneDelegate: SpriteKitSceneDelegate?
    
    override func didMove(to view: SKView) {


        let titleLabel = SKLabelNode(text: "Workout")
        titleLabel.fontSize = 175
        titleLabel.fontColor = #colorLiteral(red: 0.2392156863, green: 0.1058823529, blue: 0.7960784314, alpha: 1)
        titleLabel.fontName = "PolySans-BulkyMono"
        titleLabel.position = CGPoint(x: self.size.width / 2 , y: 852)
        self.addChild(titleLabel)

        let startGameButton = SKSpriteNode(imageNamed: "mainmenu/startIcon")
        startGameButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        startGameButton.name = "startGame"
        startGameButton.zPosition = 10
        startGameButton.setScale(1.151)
        self.addChild(startGameButton)
        
        let exitGameButton = SKSpriteNode(imageNamed: "exitIcon")
        exitGameButton.position = CGPoint(x: 1228.8 + (self.size.width / 2), y: 465 + (self.size.height / 2))
        exitGameButton.name = "exitGame"
        exitGameButton.zPosition = 11
        exitGameButton.setScale(1.25)
        self.addChild(exitGameButton)
        
        let backgroundImage = SKSpriteNode(imageNamed: "mainmenu/startbackground")
        backgroundImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        backgroundImage.name = "startBackground"
        backgroundImage.zPosition = 1
        backgroundImage.xScale = 1.494
        backgroundImage.yScale = 1.211
        self.addChild(backgroundImage)
        
        let backgroundColor = UIColor(
            red: 218.0 / 255.0, // Convert red to 0.0 - 1.0 scale
            green: 194.0 / 255.0, // Convert green to 0.0 - 1.0 scale
            blue: 254.0 / 255.0, // Convert blue to 0.0 - 1.0 scale
            alpha: 1.0 // Fully opaque
        )

        // Create a colored sprite node with the background color
        let colorBackground = SKSpriteNode(color: backgroundColor, size: self.size)
        colorBackground.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2) // Center the background
        colorBackground.zPosition = -10 // Place behind other nodes
        self.addChild(colorBackground)
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if node.name == "startGame" {
                
                // Navigate to the first level
                if let gameScene = WorkOutGameScene(fileNamed: "Level1") {
                    gameScene.scaleMode = .aspectFill
                    gameScene.sceneDelegate = self.sceneDelegate // Transfer the delegate
                    let transition = SKTransition.push(with: .left, duration: 1.0)
                    self.view?.presentScene(gameScene, transition: transition)
                }
                
                
                
            } else if node.name == "exitGame" {
                print("Exit Game button pressed")
                sceneDelegate?.didRequestDismissal() // Notify SwiftUI
            }
        }
    }
    
    private func displayEquippedBaby() {
        // Create the texture (it will not be nil)
        let texture = SKTexture(imageNamed: (equippedBaby + "_Sprite_Neutral"))
        
        // Create a sprite node for the baby
        let babySpriteNode = SKSpriteNode(texture: texture)
        babySpriteNode.position = CGPoint(x: self.size.width / 2 + 30, y: self.size.height / 1.2 * 0.4)
        babySpriteNode.size = CGSize(width: 150, height: 150) // Adjust size as needed
        babySpriteNode.zPosition = 1 // Ensure it appears above other nodes
        self.addChild(babySpriteNode)
    }

}
