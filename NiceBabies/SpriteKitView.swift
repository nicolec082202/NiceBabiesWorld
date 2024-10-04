//
//  SpriteKitView.swift
//  NiceBabies
//
//  Created by Nicole Potter on 9/27/24.
//

import Foundation
import SwiftUI
import SpriteKit


struct SpriteKitView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let skView = SKView(frame: UIScreen.main.bounds)
        
        // Load your SpriteKit game scene
        let scene = WorkOutGameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        
        // Present the scene
        skView.presentScene(scene)
        viewController.view = skView
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Leave empty for now
    }
}
