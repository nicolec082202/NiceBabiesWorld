import SpriteKit  // Import SpriteKit for game scenes and visual elements
import GameplayKit  // Import GameplayKit for potential game mechanics and AI behavior

// Define the WorkOutGameScene class, inheriting from SKScene
class WorkOutGameScene: SKScene {
    
    // Declare optional variables to store a label and a shape node
    private var label: SKLabelNode?  // Label node for displaying text in the scene
    private var spinnyNode: SKShapeNode?  // Shape node used for touch interactions
    
    // This method is called when the scene is presented by an SKView
    override func didMove(to view: SKView) {
        // Retrieve a label node from the scene with the name "helloLabel" and store it
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0  // Set the label to be initially transparent
            label.run(SKAction.fadeIn(withDuration: 2.0))  // Animate label fade-in over 2 seconds
        }
        
        // Calculate size for the spinny shape node based on the scene’s dimensions
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode(rectOf: CGSize(width: w, height: w), cornerRadius: w * 0.3)
        
        // Configure the spinny shape node if it exists
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5  // Set the line width of the shape
            // Rotate the shape indefinitely with a 1-second rotation duration
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: 1)))
            // Create a sequence of actions: wait, fade out, and remove from parent node
            spinnyNode.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.5),
                SKAction.fadeOut(withDuration: 0.5),
                SKAction.removeFromParent()
            ]))
        }
    }
        
        // Handle a touch that begins at a specific point
        func touchDown(atPoint pos: CGPoint) {
            // Create a copy of the spinny node and set its position and color
            if let n = self.spinnyNode?.copy() as? SKShapeNode {
                n.position = pos
                n.strokeColor = SKColor.green  // Set stroke color to green
                self.addChild(n)  // Add the node to the scene
            }
        }
        
        // Handle a touch that moves to a new point
        func touchMoved(toPoint pos: CGPoint) {
            // Create a copy of the spinny node and set its position and color
            if let n = self.spinnyNode?.copy() as? SKShapeNode {
                n.position = pos
                n.strokeColor = SKColor.blue  // Set stroke color to blue
                self.addChild(n)  // Add the node to the scene
            }
        }
        
        // Handle a touch that ends at a specific point
        func touchUp(atPoint pos: CGPoint) {
            // Create a copy of the spinny node and set its position and color
            if let n = self.spinnyNode?.copy() as? SKShapeNode {
                n.position = pos
                n.strokeColor = SKColor.red  // Set stroke color to red
                self.addChild(n)  // Add the node to the scene
            }
        }
        
        // Called when a touch begins
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            // Run a pulse animation on the label when touched
            if let label = self.label {
                label.run(SKAction(named: "Pulse")!, withKey: "fadeInOut")
            }
            // For each touch, call touchDown at the touch's location
            for t in touches {
                self.touchDown(atPoint: t.location(in: self))
            }
        }
        
        // Called when a touch moves
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            // For each touch, call touchMoved at the touch's new location
            for t in touches {
                self.touchMoved(toPoint: t.location(in: self))
            }
        }
        
        // Called when a touch ends
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            // For each touch, call touchUp at the touch's location
            for t in touches {
                self.touchUp(atPoint: t.location(in: self))
            }
        }
        
        // Called when a touch is canceled (e.g., interrupted by an event like a phone call)
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            // For each touch, call touchUp at the touch's location
            for t in touches {
                self.touchUp(atPoint: t.location(in: self))
            }
        }
        
        // Called before each frame is rendered
        override func update(_ currentTime: TimeInterval) {
            // Use this function to update the game’s state or animations
        }
    }
    

