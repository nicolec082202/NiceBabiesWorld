import SwiftUI

struct GameCatalogView: View {
    @Environment(\.presentationMode) var isGameCatalogViewPresented
    @State private var isWorkoutGamePresented = false
    @State private var isMatchingGamePresented = false

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height

            ZStack {
                // Home Button to dismiss the view
                Button(action: {
                    isGameCatalogViewPresented.wrappedValue.dismiss()
                }) {
                    Image(systemName: "house.fill")
                        .font(.system(size: width * 0.05)) // Font size relative to width
                        .foregroundColor(.black)
                }
                .position(x: width * 0.1, y: height * 0.05) // Position relative to screen size

                Text("Game Catalog View")
                    .font(.title)
                    .position(x: width * 0.5, y: height * 0.1) // Centered relative to screen width

                VStack(spacing: height * 0.02) { // Spacing relative to height
                    // Button for Workout Game
                    Button(action: {
                        isWorkoutGamePresented = true
                        OrientationManager.landscapeSupported = true
                    }) {
                        Text("Launch Workout Game")
                            .font(.title2) // Adjusted for better responsiveness
                            .padding()
                            .frame(width: width * 0.8) // Width relative to screen size
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .fullScreenCover(isPresented: $isWorkoutGamePresented) {
                        // Launch the Workout Game
                        SpriteKitView(gameType: .workout)
                            .edgesIgnoringSafeArea(.all)
                            .onDisappear{
                                OrientationManager.landscapeSupported = false
                            }
                    }

                    // Button for Matching Game
                    Button(action: {
                        isMatchingGamePresented = true
                    }) {
                        Text("Launch Matching Game")
                            .font(.title2) // Adjusted for better responsiveness
                            .padding()
                            .frame(width: width * 0.8) // Width relative to screen size
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
                .frame(width: width, height: height)
                .position(x: width * 0.5, y: height * 0.5) // Centered in the view
            }
        }
    }
}

// Preview of the GameCatalogView for development in Xcode
struct GameCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        GameCatalogView()
    }
}
