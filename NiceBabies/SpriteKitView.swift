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
    var onExit: (() -> Void)? // Closure to handle the exit action
    @Binding var gameCompleted: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()

        // Create an SKView that will be the main view for the controller
        let skView = SKView(frame: UIScreen.main.bounds)

        // Load the appropriate scene based on the game type
        let scene: SKScene
        switch gameType {
        case .workout:
            let workoutScene = WorkOutGameLoadingScene(size: UIScreen.main.bounds.size)
            workoutScene.sceneDelegate = context.coordinator // Set the delegate
            
            print("Delegate set for WorkOutGameLoadingScene") // Debugging print
            scene = workoutScene
        case .matching:
            scene = MatchingGameLoadingScene(size: UIScreen.main.bounds.size)
        }

        scene.scaleMode = .resizeFill  // Adjust to fit the view
        skView.presentScene(scene)  // Present the selected scene

        // Optional: Show FPS and node count for debugging
        skView.showsFPS = false
        skView.showsNodeCount = false

        // Set the SKView as the main view for the view controller
        viewController.view = skView
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed for this implementation
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onExit: onExit, gameCompleted: $gameCompleted)
        }

    class Coordinator: NSObject, SpriteKitSceneDelegate {
        
        
        @Binding var gameCompleted: Bool
        var onExit: (() -> Void)?
        
        init(onExit: (() -> Void)?, gameCompleted: Binding<Bool>) {
            self.onExit = onExit
            self._gameCompleted = gameCompleted
        }

        func didRequestDismissal() {
            print("Delegate received dismissal request") // Debugging print
            OrientationManager.landscapeSupported = false
            onExit?() // Notify SwiftUI to dismiss the view
        }
        
        func didCompleteGame() {
            print("Delegate received game complete request")
            print("Before setting: gameCompleted = \(gameCompleted)")
            gameCompleted = true // Notify SwiftUI
            print("After setting: gameCompleted = \(gameCompleted)")
        }
    }
}
