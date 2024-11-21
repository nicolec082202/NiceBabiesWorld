//
//  SpriteKitView.swift
//  NiceBabies
//
//  Created by Jordez Fernandez on 11/14/24.
//

import SwiftUI

struct TutorialView: View {
    @Binding var showTutorial: Bool
    @Binding var currentTutorialStep: Int
    @State private var overlayOpacity: Double = 0.6
    @State private var isMenuOpen: Bool = false // Track the Hamburger Menu state

    var body: some View {
        ZStack {
            // Background Overlay to dim the rest of the screen
            Color.black.opacity(overlayOpacity).edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                // Step 1: Welcome Message
                if currentTutorialStep == 0 {
                    tutorialStepView(
                        message: "Welcome to NiceBabies! Here we'll give you a tour around the place!",
                        action: { currentTutorialStep = 1 }
                    )
                }

                // Step 2: Open Hamburger Menu
                if currentTutorialStep == 1 {
                    tutorialStepView(
                        message: "Tap here to pull out the Menu",
                        action: {
                            currentTutorialStep = 2
                            isMenuOpen = true // Open the Hamburger Menu
                        }
                    )
                }

                // Step 3–7: Explain Menu Features
                if currentTutorialStep >= 2 && currentTutorialStep < 8 {
                    HamburgerMenuView(isMenuOpen: $isMenuOpen, navigateToView: { viewName in
                        // Handle navigation here if needed
                    })
                    tutorialStepView(
                        message: tutorialMessage(for: currentTutorialStep),
                        action: { currentTutorialStep += 1 }
                    )
                }

                // Step 8: Close Hamburger Menu
                if currentTutorialStep == 8 {
                    tutorialStepView(
                        message: "Your NiceBaby is now excited to start playing with you!",
                        action: {
                            currentTutorialStep = 9
                            isMenuOpen = false // Close the Hamburger Menu
                        }
                    )
                }

                // Step 9: End of Tutorial
                if currentTutorialStep == 9 {
                    tutorialStepView(
                        message: "You're all set! Enjoy your experience.",
                        action: {
                            showTutorial = false
                            currentTutorialStep = 0
                        },
                        buttonText: "Start Now!"
                    )
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: currentTutorialStep)
    }

    // Helper View for Each Tutorial Step
    private func tutorialStepView(message: String, action: @escaping () -> Void, buttonText: String = "Got it!") -> some View {
        VStack {
            Text(message)
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(8)
                .padding(.bottom, 40)

            Image(systemName: "arrow.down.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
                .offset(y: -20)
                .padding()

            Button(action: action) {
                Text(buttonText)
                    .font(.headline)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
        }
        .transition(.move(edge: .top))
    }

    // Helper to return step-specific messages
    private func tutorialMessage(for step: Int) -> String {
        switch step {
        case 2: return "You tap the home icon to come see your house!"
        case 3: return "You tap the laptop icon to play some Minigames to upkeep your NiceBaby!"
        case 4: return "You tap the teddy bear to check up on the health of your NiceBaby!"
        case 5: return "You tap on the closet to switch out your NiceBaby's costume!"
        case 6: return "You tap the Exit sign if you feel you've given your NiceBaby enough attention!"
        case 7: return "Your NiceBaby is excited to start playing with you soon!"
        default: return ""
        }
    }
}
