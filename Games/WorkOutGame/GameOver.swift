//
//  GameOver.swift
//  NiceBabies
//
//  Created by Allan Prieb on 12/5/24.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    override func sceneDidLoad() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            let level1 = WorkOutGameScene(fileNamed: "Level1")
            level1?.scaleMode = .aspectFill
            self.view?.presentScene(level1)
            self.removeAllActions()
        }
    }
}
