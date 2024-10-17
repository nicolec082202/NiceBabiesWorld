import UIKit  // Import UIKit for managing the view controller
import SpriteKit  // Import SpriteKit for handling game scenes and rendering
import GameplayKit  // Import GameplayKit for possible game mechanics or AI behavior

// Define a custom view controller for the workout game
class WorkOutGameViewController: UIViewController {

    // This method is called when the view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()  // Call the parent class's viewDidLoad method

        // Safely cast the main view to an SKView (SpriteKit view)
        if let view = self.view as? SKView {
            
            // Try to load the game scene from 'GameScene.sks' (a SpriteKit scene file)
            if let scene = SKScene(fileNamed: "GameScene") {
                
                // Set the scene’s scale mode to fill the window while maintaining the aspect ratio
                scene.scaleMode = .aspectFill
                
                // Present the scene in the SKView to display it on the screen
                view.presentScene(scene)
            }
            
            // Optimize rendering by ignoring the order of sibling nodes
            view.ignoresSiblingOrder = true
            
            // Enable FPS display to show frames per second (useful for debugging performance)
            view.showsFPS = true
            
            // Show the number of active nodes in the scene (useful for debugging)
            view.showsNodeCount = true
        }
    }

    // Specify the supported interface orientations
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // If the device is an iPhone, allow all orientations except upside down
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            // Allow all orientations on other devices (e.g., iPads)
            return .all
        }
    }

    // Hide the status bar for a more immersive game experience
    override var prefersStatusBarHidden: Bool {
        return true  // Return true to hide the status bar
    }
}
