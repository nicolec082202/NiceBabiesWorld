import Foundation
import SwiftUI
import SpriteKit

// Enum to identify which game to load
enum GameType {
    case workout
    case matching
}

// Define SpriteKitView struct that conforms to UIViewControllerRepresentable protocol
struct SpriteKitView: UIViewControllerRepresentable {
    var gameType: GameType  // Pass in the game type

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()

        // Create an SKView that will be the main view for the controller
        let skView = SKView(frame: UIScreen.main.bounds)

        // Load the appropriate scene based on the game type
        let scene: SKScene
        switch gameType {
        case .workout:
            scene = WorkOutGameLoadingScene(size: UIScreen.main.bounds.size)
        case .matching:
            scene = MatchingGameLoadingScene(size: UIScreen.main.bounds.size)
        }

        scene.scaleMode = .resizeFill  // Adjust to fit the view
        skView.presentScene(scene)  // Present the selected scene

        // Optional: Show FPS and node count for debugging
        skView.showsFPS = true
        skView.showsNodeCount = true

        // Set the SKView as the main view for the view controller
        viewController.view = skView
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed for this implementation
    }
}
