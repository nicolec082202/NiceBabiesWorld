import SpriteKit  // Import SpriteKit for game scenes and visual elements
import GameplayKit  // Import GameplayKit for potential game mechanics and AI behavior

// Define the WorkOutGameScene class, inheriting from SKScene
class WorkOutGameLoadingScene: SKScene {
    
    var loadingFlower = SKSpriteNode()
    
    var TextureAtlas = SKTextureAtlas()
    var TextureArray = [SKTexture]()
    
    // This method is called when the scene is presented by an SKView
    override func didMove(to view: SKView) {
        
        TextureAtlas = SKTextureAtlas(named: "Loading")
        
        // Check if textures are available to prevent index errors
            guard TextureAtlas.textureNames.count > 0 else {
                print("Error: No textures found in the atlas.")
                return
            }
        
        for i in 1...TextureAtlas.textureNames.count{
            
            var Name = "loading_\(i)"
            TextureArray.append(SKTexture(imageNamed: Name))
            
            
        }
        
        loadingFlower = SKSpriteNode(imageNamed: TextureAtlas.textureNames[0])
        
        loadingFlower.size = CGSize(width: 80, height: 80)
        loadingFlower.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        self.addChild(loadingFlower)
        
        loadingFlower.run(SKAction.repeatForever(SKAction.animate(with: TextureArray, timePerFrame: 0.1)))
        
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
    

