
import SwiftUI
import SpriteKit

enum GameType {
    case workout
    case matching
}

struct SpriteKitView: UIViewControllerRepresentable {
    @Binding var equippedBaby: String
    var gameType: GameType

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let skView = SKView(frame: UIScreen.main.bounds)

        // Load the appropriate scene based on game type
        let scene: SKScene
        switch gameType {
        case .workout:
            let workoutScene = WorkOutGameLoadingScene(size: UIScreen.main.bounds.size)
            // Customize your scene if necessary
            scene = workoutScene
        case .matching:
            let matchingLoadingScene = MatchingGameLoadingScene(size: UIScreen.main.bounds.size, equippedBaby: equippedBaby) // Use custom initializer
            scene = matchingLoadingScene
        }

        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        skView.showsFPS = true
        skView.showsNodeCount = true
        viewController.view = skView
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed for this implementation
    }
}
