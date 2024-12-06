import SpriteKit  // Import SpriteKit for game scenes and visual elements
import GameplayKit  // Import GameplayKit for potential game mechanics and AI behavior

// Define the WorkOutGameScene class, inheriting from SKScene
class WorkOutGameLoadingScene: SKScene {
    
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
        let mainMenuScene = WorkOutGameMainMenuScene(size: self.size)
        mainMenuScene.scaleMode = .aspectFill

        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(mainMenuScene, transition: transition)
    }

        
        // Handle a touch that begins at a specific point
        func touchDown(atPoint pos: CGPoint) {

        }
        
        // Handle a touch that moves to a new point
        func touchMoved(toPoint pos: CGPoint) {

        }
        
        // Handle a touch that ends at a specific point
        func touchUp(atPoint pos: CGPoint) {

        }
        
        // Called when a touch begins
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        }
        
        // Called when a touch moves
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        }
        
        // Called when a touch ends
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        }
        
        // Called when a touch is canceled (e.g., interrupted by an event like a phone call)
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

        }
        
        // Called before each frame is rendered
        override func update(_ currentTime: TimeInterval) {
            // Use this function to update the game’s state or animations
        }
    }
    

