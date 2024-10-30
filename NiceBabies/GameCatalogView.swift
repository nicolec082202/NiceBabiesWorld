import SwiftUI

struct GameCatalogView: View {
    @Environment(\.presentationMode) var isGameCatalogViewPresented
    @State private var isWorkoutGamePresented = false
    @State private var isMatchingGamePresented = false

    var body: some View {
        ZStack {
            // Home Button to dismiss the view
            Button(action: {
                isGameCatalogViewPresented.wrappedValue.dismiss()
            }) {
                Image(systemName: "house.fill")
                    .font(.system(size: 25))
                    .foregroundColor(.black)
            }
            .position(x: 50, y: 10)

            Text("Game Catalog View")
                .position(x: 200, y: 30)

            VStack(spacing: 20) {
                // Button for Workout Game
                Button(action: {
                    isWorkoutGamePresented = true
                }) {
                    Text("Launch Workout Game")
                        .font(.title)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $isWorkoutGamePresented) {
                    // Launch the Workout Game
                    SpriteKitView(gameType: .workout)
                        .edgesIgnoringSafeArea(.all)
                }

                // Button for Matching Game
                Button(action: {
                    isMatchingGamePresented = true
                }) {
                    Text("Launch Matching Game")
                        .font(.title)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $isMatchingGamePresented) {
                    // Launch the Matching Game
                    SpriteKitView(gameType: .matching)
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .position(x: 200, y: 200)
        }
    }
}

