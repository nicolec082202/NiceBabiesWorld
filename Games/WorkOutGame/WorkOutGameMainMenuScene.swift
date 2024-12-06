import SpriteKit
import SwiftUI

class WorkOutGameMainMenuScene: SKScene {
    var equippedBaby: String = ""

    override func didMove(to view: SKView) {


        //Add solid background color
        let colorBackground = SKSpriteNode(color: UIColor(red: 202/255, green: 196/255, blue: 248/255, alpha: 1.0), size: self.size)// hex #cac4f8
        colorBackground.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        colorBackground.zPosition = -2 // Ensure it appears behind the background image
        self.addChild(colorBackground)

        // Add scene background
        let backgroundTexture = SKTexture(imageNamed: "WorkoutGameMainMenuSceneBackground")
        let backgroundNode = SKSpriteNode(texture: backgroundTexture)
        backgroundNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        backgroundNode.size = CGSize(width: self.size.width, height: self.size.height)
        backgroundNode.zPosition = -1
        self.addChild(backgroundNode)
        
        //Add Title label
        let titleLabel = SKLabelNode(text: "Work Out Game")
        titleLabel.fontSize = self.size.width / 10
        titleLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.5 + 120 )
        titleLabel.fontName = "AvenirNext-Bold" // Optional: Customize the font
        titleLabel.fontColor = .purple
        self.addChild(titleLabel)

        
        
        // Add startButton
        addStartButton()
        
        // Add exitButton
        addExitButton()
        
        
        // Fetch equipped baby from the database
        fetchUserData(for: "equippedBaby") { value, error in
            if let error = error {
                print("Error fetching equippedBaby: \(error.localizedDescription)")
            } else if let fetchedEquippedBaby = value as? String {
                self.equippedBaby = fetchedEquippedBaby
                DispatchQueue.main.async {
                    self.displayEquippedBaby()
                }
            }
        }
    }
    
    // function for startButton
    private func addStartButton(){
        let startButtonTexure = SKTexture(imageNamed: "Start_Button")
        let startButton = SKSpriteNode(texture: startButtonTexure)
        startButton.xScale = 0.4
        startButton.yScale = 0.4
        startButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 + 170)
        startButton.name = "startGame"
        startButton.zPosition = 1
        self.addChild(startButton)
    }
    
    private func addExitButton(){
        let exitButtonTexture = SKTexture(imageNamed: "Exit_Button")
        let exitButton = SKSpriteNode(texture: exitButtonTexture)
        exitButton.xScale = 0.4
        exitButton.yScale = 0.4
        exitButton.position = CGPoint(x: exitButton.size.width / 8, y: self.size.height - exitButton.size.height / 1.2)
        exitButton.name = "exitGame"
        exitButton.zPosition = 1
        self.addChild(exitButton)
    }
    
    // Function to display the equipped baby sprite
    private func displayEquippedBaby() {
        guard !equippedBaby.isEmpty else {
            print("Equipped baby is empty, skipping sprite display.")
            return
        }
        
        // Create the texture (it will not be nil)
        let texture = SKTexture(imageNamed: (equippedBaby + "_Sprite_Neutral"))
        
        // Create a sprite node for the baby
        let babySpriteNode = SKSpriteNode(texture: texture)
        babySpriteNode.position = CGPoint(x: self.size.width / 2 + 30, y: self.size.height / 3)
        babySpriteNode.size = CGSize(width: 200, height: 200) // Adjust size as needed
        babySpriteNode.zPosition = 1 // Ensure it appears above other nodes
        self.addChild(babySpriteNode)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if node.name == "startGame" {
                // Navigate to the first level
                let level1Scene = WorkOutGameLevel1Scene(size: self.size)
                level1Scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 1.0)
                self.view?.presentScene(level1Scene, transition: transition)
            } else if node.name == "exitGame" {
                
                if let view = self.view {
                    let gameCatalogView = GameCatalogView()
                    let hostingController = UIHostingController(rootView: gameCatalogView)
                    view.window?.rootViewController = hostingController
                }
            }
        }
    }
}
