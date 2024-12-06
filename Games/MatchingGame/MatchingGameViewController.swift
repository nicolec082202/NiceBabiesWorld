import UIKit
import SpriteKit

class MatchingGameViewController: UIViewController {
    var equippedBaby: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as? SKView {
            // Load the Matching Game Loading Scene with equippedBaby
            let scene = MatchingGameLoadingScene(size: view.bounds.size, equippedBaby: equippedBaby)
            scene.scaleMode = .aspectFit
            view.presentScene(scene)

            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
