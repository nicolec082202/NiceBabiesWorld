import Foundation
import SwiftUI
import SpriteKit

enum GameType {
    case workout
    case matching
}



struct SpriteKitView: UIViewControllerRepresentable {
    @Binding var equippedBaby: String
    var gameType: GameType
    var onExit: (() -> Void)? // Closure to handle the exit action
    @Binding var gameCompleted: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let skView = SKView(frame: UIScreen.main.bounds)

        // Load the appropriate scene based on game type
        let scene: SKScene
        switch gameType {
        case .workout:
            let workoutScene = WorkOutGameLoadingScene(size: UIScreen.main.bounds.size, equippedBaby: equippedBaby)
            workoutScene.sceneDelegate = context.coordinator // Set the delegate
            
            scene = workoutScene
        case .matching:
            let matchingLoadingScene = MatchingGameLoadingScene(size: UIScreen.main.bounds.size, equippedBaby: equippedBaby) // Use custom initializer
            scene = matchingLoadingScene
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
