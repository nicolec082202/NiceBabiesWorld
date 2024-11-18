//
//  SpriteKitView.swift
//  NiceBabies
//
//  Created by Jordez Fernandez on 11/14/24.
//

import SwiftUI
 
struct TutorialView: View {
    @Binding var currentStep: Int
    var steps: [TutorialStep]
    var onComplete: () -> Void
 
    var body: some View {
        if currentStep < steps.count {
            ZStack {
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        currentStep += 1
                        if currentStep >= steps.count {
                            onComplete()
                        }
                    }
 
                VStack {
                    Spacer()
                    steps[currentStep].arrowView
                    steps[currentStep].description
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    Spacer()
                }
            }
            .transition(.opacity)
            .animation(.easeInOut)
        }
    }
}
 
struct TutorialStep {
    var arrowView: AnyView  // Placeholder for the arrow
    var description: Text
}
 
