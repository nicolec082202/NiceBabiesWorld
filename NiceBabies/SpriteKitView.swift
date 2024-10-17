import Foundation
import SwiftUI
import SpriteKit

// Define SpriteKitView struct that conforms to UIViewControllerRepresentable protocol
// This allows the use of a UIKit view controller within SwiftUI
struct SpriteKitView: UIViewControllerRepresentable {
    
    // Create and configure the view controller that will be used in the SwiftUI view
    func makeUIViewController(context: Context) -> UIViewController {
        // Create a new instance of UIViewController
        let viewController = UIViewController()
        
        // Create an SKView with the same size as the screen
        let skView = SKView(frame: UIScreen.main.bounds)
        
        // Load the custom SpriteKit game scene (WorkOutGameScene) with the screen size
        let scene = WorkOutGameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill  // Adjust the scene to fill the view, resizing as needed
        
        // Present the scene in the SKView
        skView.presentScene(scene)
        
        // Set the SKView as the view controller's main view
        viewController.view = skView
        
        // Return the configured view controller to be used in SwiftUI
        return viewController
    }
    
    // This function updates the view controller with new data or state changes (optional)
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates are needed for this implementation, so the body is left empty
    }
}

